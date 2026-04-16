import 'package:get/get.dart';

import '../controllers/add_diaper_controller.dart';

class AddDiaperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDiaperController>(
      () => AddDiaperController(),
    );
  }
}
