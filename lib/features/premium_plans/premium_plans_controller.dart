import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/services/storage_service.dart';

class PremiumPlansController extends GetxController {
  static const String monthlyBasicProductId = 'com.cashflowIQ.MonthlyBasic';

  final StorageService _storageService = Get.find<StorageService>();
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  final Rxn<ProductDetails> productDetails = Rxn<ProductDetails>();
  final isLoadingProducts = true.obs;
  final isPurchasing = false.obs;
  final isRestoringPurchases = false.obs;
  final isSubscribed = false.obs;
  final isYearly = false.obs;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  @override
  void onInit() {
    super.onInit();
    isSubscribed.value = _storageService.isSubscribed();
    _subscribeToPurchaseUpdates();
    unawaited(_loadMonthlyBasicProduct());
  }

  @override
  void onClose() {
    _purchaseSubscription?.cancel();
    super.onClose();
  }

  void togglePlan(bool yearly) {
    isYearly.value = yearly;
  }

  Future<void> _loadMonthlyBasicProduct() async {
    isLoadingProducts.value = true;
    Get.log('PremiumPlans: loading store product $monthlyBasicProductId');

    try {
      final available = await _inAppPurchase.isAvailable();
      Get.log('PremiumPlans: store available = $available');
      if (!available) {
        Get.log(
          'PremiumPlans: store unavailable, skipping product query for $monthlyBasicProductId',
        );
        _showSnackbar(
          'Store Unavailable',
          'The store is not available on this device right now.',
        );
        return;
      }

      final response = await _inAppPurchase.queryProductDetails({
        monthlyBasicProductId,
      });

      Get.log(
        'PremiumPlans: queryProductDetails response => found=${response.productDetails.length}, notFound=${response.notFoundIDs}, error=${response.error?.message ?? 'none'}',
      );
      if (response.productDetails.isNotEmpty) {
        Get.log(
          'PremiumPlans: product ids => ${response.productDetails.map((details) => '${details.id} (${details.title})').join(', ')}',
        );
      }

      if (response.error != null) {
        Get.log(
          'PremiumPlans: store query error details => ${response.error!.message}',
        );
        if (response.error!.message.contains('StoreKit')) {
          Get.log(
            'PremiumPlans: StoreKit could not return the product catalog. If this is a simulator, attach an Xcode StoreKit configuration file or test on a real device. If this is a device, verify the product exists in App Store Connect, is the exact case-sensitive id, and has the required agreements cleared.',
          );
        }
        _showSnackbar('Product Unavailable', response.error!.message);
      }

      if (response.notFoundIDs.contains(monthlyBasicProductId)) {
        Get.log(
          'PremiumPlans: product id $monthlyBasicProductId was not returned by the store. Check App Store Connect / Play Console product setup and product id spelling.',
        );
        _showSnackbar(
          'Product Unavailable',
          'Monthly Basic Growth is not available in the store.',
        );
      }

      if (response.productDetails.isNotEmpty) {
        productDetails.value = response.productDetails.firstWhere(
          (details) => details.id == monthlyBasicProductId,
          orElse: () => response.productDetails.first,
        );
      }
    } catch (error) {
      Get.log('Failed to load subscription product: $error');
      _showSnackbar(
        'Product Unavailable',
        'Unable to load the subscription details right now.',
      );
    } finally {
      isLoadingProducts.value = false;
    }
  }

  void _subscribeToPurchaseUpdates() {
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        isPurchasing.value = false;
        isRestoringPurchases.value = false;
        Get.log('Purchase stream error: $error');
      },
    );
  }

  Future<void> purchaseMonthlyBasic() async {
    Get.log(
      'PremiumPlans: purchaseMonthlyBasic tapped, current product=${productDetails.value?.id ?? 'null'}, subscribed=${isSubscribed.value}, loading=${isLoadingProducts.value}',
    );

    if (isSubscribed.value) {
      _showSnackbar(
        'Subscription Active',
        'Monthly Basic Growth is already unlocked on this device.',
      );
      return;
    }

    final details = productDetails.value;
    if (details == null) {
      _showSnackbar(
        'Product Unavailable',
        'Monthly Basic Growth is still loading from the store.',
      );
      return;
    }

    if (isPurchasing.value || isRestoringPurchases.value) {
      return;
    }

    final available = await _inAppPurchase.isAvailable();
    if (!available) {
      _showSnackbar(
        'Store Unavailable',
        'The store is not available on this device right now.',
      );
      return;
    }

    isPurchasing.value = true;
    Get.log(
      'PremiumPlans: starting purchase for $monthlyBasicProductId using store product ${details.id}',
    );

    try {
      await _inAppPurchase.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: details),
      );
    } on PlatformException catch (error) {
      isPurchasing.value = false;
      Get.log(
        'PremiumPlans: PlatformException while starting purchase => code=${error.code}, message=${error.message}, details=${error.details}',
      );
      _showSnackbar(
        'Purchase Failed',
        error.message ?? 'Unable to start the purchase flow.',
      );
    } catch (error) {
      isPurchasing.value = false;
      Get.log('Purchase start failed: $error');
      _showSnackbar(
        'Purchase Failed',
        'Unable to start the purchase flow right now.',
      );
    }
  }

  Future<void> restorePurchases() async {
    if (isPurchasing.value || isRestoringPurchases.value) {
      return;
    }

    isRestoringPurchases.value = true;

    try {
      final available = await _inAppPurchase.isAvailable();
      if (!available) {
        _showSnackbar(
          'Restore Purchases',
          'The store is not available on this device right now.',
        );
        return;
      }

      await _inAppPurchase.restorePurchases();

      _showSnackbar(
        'Restoring Purchases',
        'Checking the store for your previous subscription.',
      );
    } catch (error) {
      Get.log('Restore purchases failed: $error');
      _showSnackbar('Restore Failed', 'Unable to restore purchases right now.');
    } finally {
      isRestoringPurchases.value = false;
    }
  }

  void showUnsupportedPlan(String planName) {
    _showSnackbar(
      'Not Available',
      '$planName is not purchasable in this build.',
    );
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      Get.log(
        'PremiumPlans: purchase update => product=${purchase.productID}, status=${purchase.status}, pendingComplete=${purchase.pendingCompletePurchase}',
      );
      switch (purchase.status) {
        case PurchaseStatus.pending:
          isPurchasing.value = true;
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final valid = await _validatePurchase(purchase);
          if (valid) {
            await _unlockSubscription(purchase);
          } else {
            _showSnackbar(
              'Purchase Failed',
              'The purchase could not be verified.',
            );
          }
          break;
        case PurchaseStatus.canceled:
          _showSnackbar(
            'Purchase Cancelled',
            'The purchase was cancelled before completion.',
          );
          break;
        case PurchaseStatus.error:
          Get.log(
            'PremiumPlans: purchase error => ${purchase.error?.code}: ${purchase.error?.message}',
          );
          _showSnackbar(
            'Purchase Failed',
            purchase.error?.message ?? 'The purchase failed.',
          );
          break;
      }

      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
      }
    }

    isPurchasing.value = false;
    isRestoringPurchases.value = false;
  }

  Future<bool> _validatePurchase(PurchaseDetails purchase) async {
    if (purchase.productID != monthlyBasicProductId) {
      Get.log(
        'PremiumPlans: validation failed because product id ${purchase.productID} does not match $monthlyBasicProductId',
      );
      return false;
    }

    final serverVerificationData = purchase
        .verificationData
        .serverVerificationData
        .trim();

    if (serverVerificationData.isEmpty) {
      Get.log(
        'PremiumPlans: validation failed because serverVerificationData is empty for ${purchase.productID}',
      );
      return false;
    }

    Get.log(
      'PremiumPlans: validation passed for ${purchase.productID}, verification data length=${serverVerificationData.length}',
    );

    return true;
  }

  Future<void> _unlockSubscription(PurchaseDetails purchase) async {
    Get.log('PremiumPlans: unlocking subscription for ${purchase.productID}');
    isSubscribed.value = true;
    await _storageService.saveSubscriptionState(
      isSubscribed: true,
      productId: purchase.productID,
      plan: 'Monthly Basic Growth',
    );

    _showSnackbar(
      'Subscription Activated',
      'Monthly Basic Growth is now unlocked.',
    );
  }

  void _showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }
}
