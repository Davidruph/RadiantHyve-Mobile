import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../login/views/login_view.dart';

class ResetPasswordController extends GetxController {
  /// New Password
  TextEditingController newPasswordController = TextEditingController();
  var isSelect = 0.obs;
  var errorNewPassword = ''.obs;
  var isVisibilityNewPassword = true.obs;

  /// Confirm Password
  TextEditingController confirmPasswordController = TextEditingController();
  var errorConfirmPassword = ''.obs;
  var isVisibilityConfirmPassword = true.obs;
  var emailId;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      emailId = Get.arguments['emailId'];
    }
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
    errorNewPassword.value = '';
    errorConfirmPassword.value = '';
    bool isValid = true;
    final password = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    if (password.isEmpty || password.length < 8) {
      errorNewPassword.value = password.isEmpty ? AppMessage.pleaseEnterYourPassword : "Password should be at least 8 characters long.";
      isValid = false;
    }
    if (confirmPassword.isEmpty || password != confirmPassword) {
      errorConfirmPassword.value = confirmPassword.isEmpty ? AppMessage.pleaseEnterConfirmPassword : AppMessage.passwordDoesNotMatch;
      isValid = false;
    }
    return isValid;
  }

  resetPasswordApi() async {
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    final param = {"email": emailId, "newPassword": newPasswordController.text};
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.resetPassword,
      method: MethodType.post,
      params: param,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.offAll(() => LoginView());
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
