import 'package:get/get.dart';

import '../controllers/medication_information_controller.dart';

class MedicationInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicationInformationController>(
      () => MedicationInformationController(),
    );
  }
}
