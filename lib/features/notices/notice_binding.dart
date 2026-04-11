import 'package:get/get.dart';

import 'notice_controller.dart';

class NoticeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NoticeController());
  }
}
