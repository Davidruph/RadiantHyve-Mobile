import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../verification/views/verification_view.dart';

final box = GetStorage();

class ForgotPasswordController extends GetxController {
  /// Email
  TextEditingController emailController = TextEditingController();
  var isSelect = 0.obs;
  var errorEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
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
    errorEmail.value = '';
    bool isValid = true;
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (emailController.text.trim().isEmpty) {
      errorEmail.value = AppMessage.pleaseEnterYourEmail;
      isValid = false;
    } else if (!emailRegex.hasMatch(emailController.text)) {
      errorEmail.value = AppMessage.pleaseEnterValidEmail;
      isValid = false;
    }
    return isValid;
  }

  RxBool isLoading = false.obs;

  forgotPasswordApi() async {
    isLoading.value = true;
    if (!isValidation()) {
      isLoading.value = false;
      return;
    }    // final param = {"email": emailController.text, "role": userRole ?? 'parent'};
    final param = {"email": emailController.text};


    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.forgotePassword,
      method: MethodType.post,
      params: param,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.to(() => VerificationView(), arguments: {'emailId': emailController.text, 'otp': "${response['data']['otp']}"});
        } else {
          isLoading.value = false;
        }
        isLoading.value = false;
      },
      failureCallback: (status, message) {
        isLoading.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isLoading.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
}
