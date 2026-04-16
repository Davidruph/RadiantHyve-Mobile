import 'package:get/get.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';

class MakePaymentController extends GetxController {

  RxInt selectedIndex = (-1).obs;
  var errorPaymentMethod = ''.obs;
  List paymentList = [
    {
      'icon': icons.stripeIcon,
      'name': 'Stripe',
    },
    {
      'icon': icons.atmCardIcon,
      'name': '**** **** **** 5862',
    },
  ];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      update();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool isValidation() {

    errorPaymentMethod.value = '';


    bool isValid = true;

    if (selectedIndex == -1) {
      errorPaymentMethod.value = 'Please select your payment method.';
      isValid = false;
    }

    return isValid;
  }
}
