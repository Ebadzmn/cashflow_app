import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'widgets/add_transaction_modal.dart';

class HomeController extends GetxController {
  final selectedIndex = 0.obs;
  // Initialize to true to maintain backward compatibility if no argument is passed (e.g. from hot reload)
  final isPro = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Catch the extra arg passed from GoRouter
    // Note: In GoRouter, context.go extra args aren't available via Get.arguments.
    // We should either read it from the GoRouter state in the builder, or, since this is simple static logic,
    // we can pass it via Get.arguments from LoginPage if we used Get.toNamed,
    // OR we can just inject it from HomePage.
    // We will let HomePage pass it to the controller if needed, or read from GoRouter State.
  }

  void changeTabIndex(int index) {
    if (index == 4) {
      Get.dialog(
        const AddTransactionModal(),
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(
          0.3,
        ), // Light overlay, blur is inside the widget
      );
    } else {
      selectedIndex.value = index;
    }
  }
}
