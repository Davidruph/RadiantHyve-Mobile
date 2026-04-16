import 'package:get/get.dart';

import '../controllers/sleep_logs_details_controller.dart';

class SleepLogsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SleepLogsDetailsController>(
      () => SleepLogsDetailsController(),
    );
  }
}
