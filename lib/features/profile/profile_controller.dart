import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/network_exception.dart';
import '../../data/models/profile_response.dart';
import '../../data/repositories/auth_repository.dart';

class ProfileController extends GetxService {
  final AuthRepository _authRepository = AuthRepository();

  final Rxn<ProfileData> userProfile = Rxn<ProfileData>();
  final RxBool isLoading = false.obs;

  Future<void> fetchProfile({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }

    try {
      final response = await _authRepository.getProfile();
      if (response.success && response.data != null) {
        userProfile.value = response.data;
        return;
      }

      throw NetworkException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Failed to load profile',
      );
    } on NetworkException catch (e) {
      if (showLoading) {
        Get.snackbar(
          'Error',
          e.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      rethrow;
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  String? get profileImageUrl {
    final image = userProfile.value?.image.trim();
    if (image == null || image.isEmpty) {
      return null;
    }

    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }

    return '${ApiEndpoints.baseUrl}$image';
  }

  Future<void> clearProfile() async {
    userProfile.value = null;
    isLoading.value = false;
  }
}
