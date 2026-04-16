import 'package:get/get.dart';

import '../controllers/edit_account_information_controller.dart';

class EditAccountInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditAccountInformationController>(
      () => EditAccountInformationController(),
    );
  }
}
