import 'package:get/get.dart';

import '../controllers/paid_fee_details_controller.dart';

class PaidFeeDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaidFeeDetailsController>(
      () => PaidFeeDetailsController(),
    );
  }
}
