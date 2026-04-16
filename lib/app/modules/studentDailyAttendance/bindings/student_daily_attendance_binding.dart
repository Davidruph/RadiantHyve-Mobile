import 'package:get/get.dart';

import '../controllers/student_daily_attendance_controller.dart';

class StudentDailyAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentDailyAttendanceController>(
      () => StudentDailyAttendanceController(),
    );
  }
}
