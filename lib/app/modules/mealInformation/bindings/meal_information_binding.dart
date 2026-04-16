import 'package:get/get.dart';

import '../controllers/meal_information_controller.dart';

class MealInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealInformationController>(
      () => MealInformationController(),
    );
  }
}
