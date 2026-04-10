import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/network_exception.dart';

class ScanReceiptController extends GetxController {
  final ApiClient _apiClient = ApiClient.instance;
  final ImagePicker _imagePicker = ImagePicker();

  final selectedImage = Rxn<XFile>();
  final isLoading = false.obs;
  final ocrResult = <String, dynamic>{}.obs;

  Future<void> showImageSourceOptions(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1F2937),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Colors.white),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  unawaited(_pickImage(ImageSource.camera));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  unawaited(_pickImage(ImageSource.gallery));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = image;
        ocrResult.clear();
      }
    } catch (error) {
      Get.snackbar(
        'Failed to pick image',
        'Unable to access the image picker.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.log('Image pick failed: $error');
    }
  }

  Future<void> analyzeReceipt() async {
    final image = selectedImage.value;
    if (image == null) {
      Get.snackbar(
        'No image selected',
        'Please take a photo or choose an image first.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _uploadReceiptImage(image);

      final parsed = _extractOcrData(response.data);
      if (parsed.isEmpty) {
        Get.snackbar(
          'No data found',
          'No amount or category detected in the receipt.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      ocrResult.assignAll(parsed);

      Get.snackbar(
        'Receipt scanned',
        'Receipt analyzed successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } on NetworkException catch (error) {
      Get.snackbar(
        'Failed to scan receipt',
        error.message,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.log('OCR scan failed: $error');
      Get.snackbar(
        'Failed to scan receipt',
        'Upload fail',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<dynamic> _uploadReceiptImage(XFile image) async {
    final uploadFieldNames = <String>[
      'file',
      'image',
      'receipt',
      'receiptImage',
    ];

    NetworkException? lastUnexpectedFieldError;

    for (final fieldName in uploadFieldNames) {
      try {
        return await _apiClient.postMultipart(
          ApiEndpoints.ocrAnalyze,
          files: {fieldName: File(image.path)},
        );
      } on NetworkException catch (error) {
        if (_isUnexpectedFieldError(error)) {
          lastUnexpectedFieldError = error;
          continue;
        }

        rethrow;
      }
    }

    throw lastUnexpectedFieldError ??
        NetworkException(message: 'Unable to upload receipt image');
  }

  bool _isUnexpectedFieldError(NetworkException error) {
    final message = error.message.toLowerCase();
    return error.statusCode == 400 && message.contains('unexpected field');
  }

  Map<String, dynamic> _extractOcrData(dynamic data) {
    final raw = data is Map<String, dynamic> ? data['data'] ?? data : data;
    if (raw is! Map) {
      return <String, dynamic>{};
    }

    final map = raw.map((key, value) => MapEntry(key.toString(), value));

    final result = <String, dynamic>{
      'amount': _readText(map['amount']),
      'category': _readText(map['category']),
    };

    result.removeWhere(
      (key, value) => value == null || value.toString().isEmpty,
    );
    return result;
  }

  String _readText(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  void clearSelection() {
    selectedImage.value = null;
    ocrResult.clear();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
