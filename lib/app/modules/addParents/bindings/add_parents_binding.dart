import 'package:get/get.dart';

import '../controllers/add_parents_controller.dart';

class AddParentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddParentsController>(
      () => AddParentsController(),
    );
  }
}
