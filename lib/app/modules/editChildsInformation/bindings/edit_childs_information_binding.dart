import 'package:get/get.dart';

import '../controllers/edit_childs_information_controller.dart';

class EditChildsInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditChildsInformationController>(
      () => EditChildsInformationController(),
    );
  }
}
