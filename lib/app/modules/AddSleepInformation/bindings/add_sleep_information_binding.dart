import 'package:get/get.dart';

import '../controllers/add_sleep_information_controller.dart';

class AddSleepInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddSleepInformationController>(
      () => AddSleepInformationController(),
    );
  }
}
