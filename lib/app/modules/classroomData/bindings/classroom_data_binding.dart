import 'package:get/get.dart';

import '../controllers/classroom_data_controller.dart';

class ClassroomDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassroomDataController>(
      () => ClassroomDataController(),
    );
  }
}
