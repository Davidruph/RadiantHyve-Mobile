import 'package:get/get.dart';

import '../controllers/child_reports_controller.dart';

class ChildReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChildReportsController>(
      () => ChildReportsController(),
    );
  }
}
