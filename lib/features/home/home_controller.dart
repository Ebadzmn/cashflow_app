import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'widgets/add_transaction_modal.dart';

class HomeController extends GetxController {
  final selectedIndex = 0.obs;

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
