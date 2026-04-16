import 'package:get/get.dart';

import '../controllers/daily_attendance_controller.dart';

class DailyAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyAttendanceController>(
      () => DailyAttendanceController(),
    );
  }
}
