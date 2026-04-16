import 'package:get/get.dart';

import '../controllers/add_certification_controller.dart';

class AddCertificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCertificationController>(
      () => AddCertificationController(),
    );
  }
}
