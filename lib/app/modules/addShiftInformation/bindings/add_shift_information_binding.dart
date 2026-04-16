import 'package:get/get.dart';

import '../controllers/add_shift_information_controller.dart';

class AddShiftInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddShiftInformationController>(
      () => AddShiftInformationController(),
    );
  }
}
