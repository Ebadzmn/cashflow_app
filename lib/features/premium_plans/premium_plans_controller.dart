import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumPlansController extends GetxController {
  final isYearly = false.obs;

  void togglePlan(bool yearly) {
    isYearly.value = yearly;
  }

  Future<void> restorePurchases() async {
    final inAppPurchase = InAppPurchase.instance;

    try {
      final isAvailable = await inAppPurchase.isAvailable();
      if (!isAvailable) {
        Get.snackbar(
          'Restore Purchases',
          'The App Store purchase flow is not available on this device.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        );
        return;
      }

      await inAppPurchase.restorePurchases();

      Get.snackbar(
        'Restore Purchases',
        'Restore request sent to the App Store.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    } catch (_) {
      Get.snackbar(
        'Restore Purchases',
        'Unable to start purchase restoration right now.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    }
  }
}
