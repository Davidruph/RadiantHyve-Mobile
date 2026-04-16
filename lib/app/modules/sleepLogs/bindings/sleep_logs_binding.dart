import 'package:get/get.dart';

import '../controllers/sleep_logs_controller.dart';

class SleepLogsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SleepLogsController>(
      () => SleepLogsController(),
    );
  }
}
