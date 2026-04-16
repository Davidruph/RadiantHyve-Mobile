import 'package:get/get.dart';

import '../controllers/birthday_details_controller.dart';

class BirthdayDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BirthdayDetailsController>(
      () => BirthdayDetailsController(),
    );
  }
}
