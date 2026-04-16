import 'package:get/get.dart';

import '../controllers/edit_personal_information_controller.dart';

class EditPersonalInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPersonalInformationController>(
      () => EditPersonalInformationController(),
    );
  }
}
