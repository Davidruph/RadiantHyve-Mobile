import 'package:get/get.dart';

import '../controllers/make_payment_controller.dart';

class MakePaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MakePaymentController>(
      () => MakePaymentController(),
    );
  }
}
