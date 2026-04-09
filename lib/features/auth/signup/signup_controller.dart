import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_router.dart';
import '../../../routes/app_routes.dart';

class SignupController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final StorageService _storageService = Get.find<StorageService>();

  final nameController = TextEditingController(); // Replaced fullNameController
  final contactController = TextEditingController(); // Added
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final termsAccepted = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    contactController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void toggleTerms() {
    termsAccepted.value = !termsAccepted.value;
  }

  Future<void> signUp() async {
    if (!_validate()) return;

    isLoading.value = true;

    try {
      final response = await _authRepository.signUp({
        'name': nameController.text.trim(),
        'contact': contactController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      });

      if (response.success && response.data != null) {
        await _saveUser(response.data!);
        
        Get.snackbar(
          'Success',
          'Account created successfully 🎉',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigate to Login screen directly (OTP bypassed)
        AppRouter.router.go(Routes.LOGIN);
      } else {
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validate() {
    final name = nameController.text.trim();
    final contact = contactController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty) {
      _showError('Full name is required');
      return false;
    }
    if (contact.isEmpty) {
      _showError('Contact number is required');
      return false;
    }
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      _showError('Please enter a valid email address');
      return false;
    }
    if (password.isEmpty || password.length < 6) {
      _showError('Password must be at least 6 characters');
      return false;
    }
    if (password != confirmPassword) {
      _showError('Passwords do not match');
      return false;
    }
    if (!termsAccepted.value) {
      _showError('Please accept the Terms and Conditions');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _saveUser(dynamic data) async {
    await _storageService.saveUserData(
      userId: data.id,
      name: data.name,
      email: data.email,
      role: data.role,
      image: data.image,
      plan: data.plan,
      verified: data.verified,
    );
  }
}
