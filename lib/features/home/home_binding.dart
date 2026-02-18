import 'package:get/get.dart';
import 'home_controller.dart';
import 'controllers/transaction_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => TransactionController());
  }
}
