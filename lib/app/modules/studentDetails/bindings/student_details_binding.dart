import 'package:get/get.dart';

import '../controllers/student_details_controller.dart';

class StudentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentDetailsController>(
      () => StudentDetailsController(),
    );
  }
}
