import 'package:get/get.dart';

import '../../upcomingBirthday/Model/BirthdayModel.dart';

class BirthdayDetailsController extends GetxController {
  BirthdayData? birthdayData;

  var type;

  @override
  void onInit() {
    if (Get.arguments != null) {
      birthdayData = Get.arguments["details"];
      type = Get.arguments["type"];
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
