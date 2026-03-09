import 'package:get/get.dart';

class PremiumPlansController extends GetxController {
  final isYearly = false.obs;

  void togglePlan(bool yearly) {
    isYearly.value = yearly;
  }
}
