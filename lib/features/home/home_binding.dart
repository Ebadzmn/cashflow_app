import 'package:get/get.dart';
import 'home_controller.dart';
import 'controllers/transaction_controller.dart';
import 'controllers/add_transaction_controller.dart';
import 'controllers/stats_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => TransactionController());
    Get.lazyPut(() => AddTransactionController());
    Get.lazyPut(() => StatsController());
  }
}
