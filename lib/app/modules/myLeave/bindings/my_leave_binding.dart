import 'package:get/get.dart';

import '../controllers/my_leave_controller.dart';

class MyLeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyLeaveController>(
      () => MyLeaveController(),
    );
  }
}
