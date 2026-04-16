import 'package:get/get.dart';

import '../controllers/certification_details_controller.dart';

class CertificationDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CertificationDetailsController>(
      () => CertificationDetailsController(),
    );
  }
}
