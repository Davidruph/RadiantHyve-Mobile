import 'package:get/get.dart';

import '../controllers/diaper_hygiene_tracker_controller.dart';

class DiaperHygieneTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiaperHygieneTrackerController>(
      () => DiaperHygieneTrackerController(),
    );
  }
}
