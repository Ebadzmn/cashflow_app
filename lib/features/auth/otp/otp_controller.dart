import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  
  final List<FocusNode> otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  final timerText = '02:59'.obs;
  Timer? _timer;
  int _start = 179; // 2 minutes 59 seconds

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
        } else {
          _start--;
          int minutes = _start ~/ 60;
          int seconds = _start % 60;
          timerText.value = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        }
      },
    );
  }

  void verifyOtp() {
    String otp = otpControllers.map((e) => e.text).join();
    if (otp.length == 6) {
      // Handle OTP verification logic here
      print("OTP Verified: $otp");
      // Navigate to next screen or show success
    } else {
      Get.snackbar('Error', 'Please enter a complete 6-digit OTP');
    }
  }

  void resendOtp() {
    _start = 179;
    timerText.value = '02:59';
    _timer?.cancel();
    startTimer();
    // Call API to resend OTP
    Get.snackbar('Success', 'OTP resent successfully');
  }
}
