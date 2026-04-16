import 'package:get/get.dart';

import '../controllers/parents_list_controller.dart';

class ParentsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentsListController>(
      () => ParentsListController(),
    );
  }
}
