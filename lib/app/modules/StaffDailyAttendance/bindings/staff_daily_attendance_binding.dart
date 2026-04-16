import 'package:get/get.dart';

import '../controllers/staff_daily_attendance_controller.dart';

class StaffDailyAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaffDailyAttendanceController>(
      () => StaffDailyAttendanceController(),
    );
  }
}
