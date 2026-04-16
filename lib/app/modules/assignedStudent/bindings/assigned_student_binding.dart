import 'package:get/get.dart';

import '../controllers/assigned_student_controller.dart';

class AssignedStudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignedStudentController>(
      () => AssignedStudentController(),
    );
  }
}
