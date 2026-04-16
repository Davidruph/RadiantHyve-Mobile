import 'package:get/get.dart';

import '../controllers/classroom_report_controller.dart';

class ClassroomReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassroomReportController>(
      () => ClassroomReportController(),
    );
  }
}
