import 'package:get/get.dart';

import '../controllers/student_edit_profile_controller.dart';

class StudentEditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentEditProfileController>(
      () => StudentEditProfileController(),
    );
  }
}
