import 'package:get/get.dart';

import '../controllers/meal_tracking_controller.dart';

class MealTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealTrackingController>(
      () => MealTrackingController(),
    );
  }
}
