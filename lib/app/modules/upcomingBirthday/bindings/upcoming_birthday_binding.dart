import 'package:get/get.dart';

import '../controllers/upcoming_birthday_controller.dart';

class UpcomingBirthdayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpcomingBirthdayController>(
      () => UpcomingBirthdayController(),
    );
  }
}
