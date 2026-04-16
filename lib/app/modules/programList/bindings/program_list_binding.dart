import 'package:get/get.dart';

import '../controllers/program_list_controller.dart';

class ProgramListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProgramListController>(
      () => ProgramListController(),
    );
  }
}
