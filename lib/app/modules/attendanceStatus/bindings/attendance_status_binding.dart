import 'package:get/get.dart';

import '../controllers/attendance_status_controller.dart';

class AttendanceStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceStatusController>(
      () => AttendanceStatusController(),
    );
  }
}
