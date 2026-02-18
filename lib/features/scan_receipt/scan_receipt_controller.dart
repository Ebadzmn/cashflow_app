import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanReceiptController extends GetxController {
  final categoryController = TextEditingController();

  @override
  void onClose() {
    categoryController.dispose();
    super.onClose();
  }
}
