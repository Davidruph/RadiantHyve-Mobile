import 'package:get/get.dart';

import '../controllers/child_report_details_controller.dart';

class ChildReportDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChildReportDetailsController>(
      () => ChildReportDetailsController(),
    );
  }
}
