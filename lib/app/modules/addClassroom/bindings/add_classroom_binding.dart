import 'package:get/get.dart';

import '../controllers/add_classroom_controller.dart';

class AddClassroomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddClassroomController>(
      () => AddClassroomController(),
    );
  }
}
