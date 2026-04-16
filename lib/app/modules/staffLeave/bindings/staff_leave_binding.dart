import 'package:get/get.dart';

import '../controllers/staff_leave_controller.dart';

class StaffLeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaffLeaveController>(
      () => StaffLeaveController(),
    );
  }
}
