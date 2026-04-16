import 'package:get/get.dart';

import '../controllers/classroom_details_controller.dart';

class ClassroomDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassroomDetailsController>(
      () => ClassroomDetailsController(),
    );
  }
}
