import 'package:get/get.dart';

import '../controllers/add_staff_controller.dart';

class AddStaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddStaffController>(
      () => AddStaffController(),
    );
  }
}
