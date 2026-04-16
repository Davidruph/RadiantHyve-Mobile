import 'package:get/get.dart';

import '../controllers/parents_reminder_controller.dart';

class ParentsReminderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentsReminderController>(
      () => ParentsReminderController(),
    );
  }
}
