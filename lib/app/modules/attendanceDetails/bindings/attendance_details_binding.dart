import 'package:get/get.dart';

import '../controllers/attendance_details_controller.dart';

class AttendanceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceDetailsController>(
      () => AttendanceDetailsController(),
    );
  }
}
