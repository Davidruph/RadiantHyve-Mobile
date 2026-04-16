import 'package:get/get.dart';

import '../controllers/reminder_to_parents_information_controller.dart';

class ReminderToParentsInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReminderToParentsInformationController>(
      () => ReminderToParentsInformationController(),
    );
  }
}
