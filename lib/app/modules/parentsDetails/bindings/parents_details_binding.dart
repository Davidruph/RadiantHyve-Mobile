import 'package:get/get.dart';

import '../controllers/parents_details_controller.dart';

class ParentsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentsDetailsController>(
      () => ParentsDetailsController(),
    );
  }
}
