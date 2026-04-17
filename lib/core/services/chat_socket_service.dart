import 'dart:convert';
import 'dart:async';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../network/api_endpoints.dart';
import 'secure_storage_service.dart';

class ChatSocketService extends GetxService {
  final SecureStorageService _storageService = SecureStorageService();
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  IO.Socket? _socket;
  String? _joinedRoomId;
  bool _isConnecting = false;
  String? _resolvedMessageEvent;

  // Keep this true while diagnosing backend event names to avoid dropping payloads.
  static const bool _bypassMessageEventFilter = true;

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect() async {
    if (_socket?.connected == true || _isConnecting) {
      return;
    }

    if (_socket != null) {
      _socket?.connect();
      return;
    }

    _isConnecting = true;

    final token = (await _storageService.getAccessToken())?.trim();
    final hasToken = token != null && token.isNotEmpty;

    final options = <String, dynamic>{
      'transports': <String>['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'forceNew': false,
      if (hasToken)
        'extraHeaders': <String, dynamic>{'Authorization': 'Bearer $token'},
      if (hasToken)
        'query': <String, dynamic>{'token': token, 'accessToken': token},
      if (hasToken)
        'auth': <String, dynamic>{
          'token': token,
          'accessToken': token,
          'authorization': 'Bearer $token',
          'Authorization': 'Bearer $token',
        },
    };

    final socket = IO.io(ApiEndpoints.socketBaseUrl, options);
    _socket = socket;

    socket.onConnect((_) {
      _isConnecting = false;
      _resolvedMessageEvent = null;
      Get.log('Chat socket connected');
      _bindResolvedMessageEvent();
      _joinRoomIfConnected();
    });

    socket.onDisconnect((reason) {
      _isConnecting = false;
      Get.log('Chat socket disconnected: $reason');
    });

    socket.onConnectError((error) {
      _isConnecting = false;
      Get.log('Chat socket connect error: $error');
    });

    socket.onError((error) {
      Get.log('Chat socket error: $error');
    });

    socket.onAny(_handleAnyEvent);

    Get.log('Chat socket connecting to ${ApiEndpoints.socketBaseUrl}');
    socket.connect();
  }

  void joinRoom(String chatRoomId) {
    if (chatRoomId.isEmpty) {
      return;
    }

    _joinedRoomId = chatRoomId;
    _joinRoomIfConnected();
  }

  void leaveRoom(String chatRoomId) {
    if (chatRoomId.isEmpty) {
      return;
    }

    _emitIfConnected('leave_room', _roomPayload(chatRoomId));
    if (_joinedRoomId == chatRoomId) {
      _joinedRoomId = null;
    }
  }

  void emitMarkRead(String chatRoomId) {
    if (chatRoomId.isEmpty) {
      return;
    }

    _emitIfConnected('mark_read', _roomPayload(chatRoomId));
  }

  void disconnect() {
    _isConnecting = false;
    _resolvedMessageEvent = null;
    _joinedRoomId = null;
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
  }

  void _handleIncomingEvent(dynamic payload, {String? sourceEvent}) {
    final normalized = _normalizePayload(payload);
    if (normalized.isNotEmpty) {
      if (sourceEvent != null && sourceEvent.isNotEmpty) {
        Get.log('Socket message from "$sourceEvent": $normalized');
      }
      _messageController.add(normalized);
    }
  }

  void _handleAnyEvent(dynamic eventName, dynamic payload) {
    final event = eventName?.toString().trim().toLowerCase() ?? '';
    Get.log('Socket onAny event="$event" payload=$payload');

    if (_isBlockedSystemEvent(event)) {
      return;
    }

    if (_resolvedMessageEvent != null && event != _resolvedMessageEvent) {
      return;
    }

    if (!_bypassMessageEventFilter && !_looksLikeMessageEvent(event, payload)) {
      return;
    }

    final normalized = _normalizePayload(payload);
    if (normalized.isEmpty) {
      return;
    }

    var justDiscoveredEvent = false;
    final isMessagePayload = _looksLikeMessageMap(normalized);
    if (isMessagePayload && _resolvedMessageEvent == null) {
      _resolvedMessageEvent = event;
      justDiscoveredEvent = true;
      Get.log('Discovered chat message event: $_resolvedMessageEvent');
      _bindResolvedMessageEvent();
    }

    // Avoid duplicate emission when exact listener is already bound.
    if (_resolvedMessageEvent != null &&
        event == _resolvedMessageEvent &&
        !justDiscoveredEvent) {
      return;
    }

    _messageController.add(normalized);
  }

  void _bindResolvedMessageEvent() {
    final socket = _socket;
    final event = _resolvedMessageEvent;
    if (socket == null || event == null || event.isEmpty) {
      return;
    }

    socket.off(event);
    socket.on(event, (dynamic payload) {
      _handleIncomingEvent(payload, sourceEvent: event);
    });
  }

  void _joinRoomIfConnected() {
    final socket = _socket;
    final roomId = _joinedRoomId;
    if (socket == null || roomId == null || roomId.isEmpty) {
      return;
    }

    if (!socket.connected) {
      Get.log('join_room deferred until connected');
      return;
    }

    final payload = _roomPayload(roomId);
    socket.emitWithAck(
      'join_room',
      payload,
      ack: (dynamic response) {
        Get.log('join_room ACK: $response');
      },
    );
    Get.log('join_room emitted for room=$roomId');
  }

  void _emitIfConnected(String event, Map<String, dynamic> payload) {
    final socket = _socket;
    if (socket == null || !socket.connected) {
      Get.log('Skipped emit "$event" because socket is not connected');
      return;
    }

    socket.emit(event, payload);
  }

  bool _looksLikeMessageMap(Map<String, dynamic> map) {
    return map.containsKey('content') ||
        map.containsKey('message') ||
        map.containsKey('messageType') ||
        map.containsKey('chatRoomId') ||
        map.containsKey('chatRoom') ||
        map.containsKey('roomId') ||
        map.containsKey('sender') ||
        map.containsKey('createdAt') ||
        map.containsKey('_id') ||
        map.containsKey('id');
  }

  bool _isBlockedSystemEvent(String event) {
    const blockedEvents = <String>{
      'connect',
      'disconnect',
      'reconnect',
      'reconnect_attempt',
      'reconnect_error',
      'reconnect_failed',
      'error',
      'ping',
      'pong',
      'open',
      'close',
    };

    if (blockedEvents.contains(event)) {
      return true;
    }

    return false;
  }

  bool _looksLikeMessageEvent(String event, dynamic payload) {
    if (event.contains('message') ||
        event.contains('chat') ||
        event.contains('room_message')) {
      return true;
    }

    if (payload is Map) {
      final map = payload.map((key, value) => MapEntry(key.toString(), value));
      return map.containsKey('content') ||
          map.containsKey('message') ||
          map.containsKey('messageType') ||
          map.containsKey('chatRoomId') ||
          map.containsKey('chatRoom') ||
          map.containsKey('roomId') ||
          map.containsKey('sender') ||
          map.containsKey('data') ||
          map.containsKey('_id') ||
          map.containsKey('id');
    }

    if (payload is List) {
      return payload.any((item) => item is Map || item is String);
    }

    if (payload is String) {
      return payload.contains('content') ||
          payload.contains('messageType') ||
          payload.contains('chatRoomId') ||
          payload.contains('chatRoom') ||
          payload.contains('roomId');
    }

    return false;
  }

  Map<String, dynamic> _roomPayload(String chatRoomId) {
    return <String, dynamic>{
      'chatRoomId': chatRoomId,
      'chatRoom': chatRoomId,
      'roomId': chatRoomId,
      'id': chatRoomId,
      'room': chatRoomId,
    };
  }

  Map<String, dynamic> _normalizePayload(dynamic payload) {
    if (payload is String) {
      final decoded = _decodeJson(payload);
      if (decoded != null) {
        return _normalizePayload(decoded);
      }

      return <String, dynamic>{};
    }

    if (payload is Map<String, dynamic>) {
      return _flattenPayload(payload);
    }

    if (payload is Map) {
      return _flattenPayload(
        payload.map((key, value) => MapEntry(key.toString(), value)),
      );
    }

    if (payload is List && payload.isNotEmpty) {
      for (final item in payload) {
        if (item is Map<String, dynamic>) {
          return _flattenPayload(item);
        }

        if (item is Map) {
          return _flattenPayload(
            item.map((key, value) => MapEntry(key.toString(), value)),
          );
        }

        if (item is String) {
          final decoded = _decodeJson(item);
          if (decoded is Map) {
            return _flattenPayload(
              decoded.map((key, value) => MapEntry(key.toString(), value)),
            );
          }
        }
      }
    }

    return <String, dynamic>{};
  }

  Map<String, dynamic> _flattenPayload(Map<String, dynamic> payload) {
    final flattened = <String, dynamic>{...payload};

    for (final nestedKey in const [
      'data',
      'message',
      'chatMessage',
      'payload',
    ]) {
      final nested = payload[nestedKey];
      if (nested is Map) {
        final nestedMap = nested.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        flattened.addAll(nestedMap);
      } else if (nested is String) {
        final decoded = _decodeJson(nested);
        if (decoded is Map) {
          final nestedMap = decoded.map(
            (key, value) => MapEntry(key.toString(), value),
          );
          flattened.addAll(nestedMap);
        }
      }
    }

    return flattened;
  }

  dynamic _decodeJson(String value) {
    try {
      return jsonDecode(value);
    } catch (_) {
      return null;
    }
  }

  @override
  void onClose() {
    disconnect();
    _messageController.close();
    super.onClose();
  }
}
