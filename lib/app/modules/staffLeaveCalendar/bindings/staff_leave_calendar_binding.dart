import 'package:get/get.dart';

import '../controllers/staff_leave_calendar_controller.dart';

class StaffLeaveCalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaffLeaveCalendarController>(
      () => StaffLeaveCalendarController(),
    );
  }
}
