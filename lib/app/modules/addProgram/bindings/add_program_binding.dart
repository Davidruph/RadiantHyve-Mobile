import 'package:get/get.dart';

import '../controllers/add_program_controller.dart';

class AddProgramBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddProgramController>(
      () => AddProgramController(),
    );
  }
}
