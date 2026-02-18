import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void submitEmail(BuildContext context) {
    if (emailController.text.isNotEmpty) {
      // Logic to send OTP to email would go here
      print("Sending OTP to ${emailController.text}");
      
      // Navigate to OTP page
      context.push(Routes.OTP);
    } else {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        colorText: Colors.white,
        backgroundColor: Colors.red.withOpacity(0.8),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
