import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';

class EditAccountInformationController extends GetxController {
  RxBool isLoading = false.obs;
  var type;

  /// Email
  TextEditingController emailController = TextEditingController();
  var isSelect = 0.obs;
  RxInt id = 0.obs;
  var errorEmail = ''.obs;

  /// New Password
  TextEditingController newPasswordController = TextEditingController();
  var errorNewPassword = ''.obs;
  var isVisibilityNewPassword = true.obs;

  /// Confirm Password
  TextEditingController confirmPasswordController = TextEditingController();
  var errorConfirmPassword = ''.obs;
  var isVisibilityConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      emailController.text = Get.arguments['email'];
      type = Get.arguments['type'];
      id.value = Get.arguments['staff_id'];
    }
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
    errorNewPassword.value = '';
    errorConfirmPassword.value = '';

    bool isValid = true;
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

    if (emailController.text.trim().isEmpty) {
      errorEmail.value = AppMessage.pleaseEnterYourEmail;
      isValid = false;
    } else if (!emailRegex.hasMatch(emailController.text)) {
      errorEmail.value = AppMessage.pleaseEnterValidEmail;
      isValid = false;
    }
    if (newPasswordController.text.trim().isEmpty ||
        (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@₹#.?\$&*~]).{8,}$').hasMatch(newPasswordController.text.trim()))) {
      errorNewPassword.value = newPasswordController.text.trim().isEmpty ? AppMessage.pleaseEnterYourPassword : AppMessage.passwordShouldContainUpper;
      isValid = false;
    }
    if (confirmPasswordController.text.trim().isEmpty || newPasswordController.text.trim() != confirmPasswordController.text.trim()) {
      errorConfirmPassword.value =
          confirmPasswordController.text.trim().isEmpty ? AppMessage.pleaseEnterConfirmPassword : AppMessage.passwordDoesNotMatch;
      isValid = false;
    }
    return isValid;
  }

  StaffPasswordApi() async {
    Map<String, dynamic> params = type == "staff"
        ? {"staff_id": id.value, "password": newPasswordController.text}
        : {"parent_id": id.value, "password": newPasswordController.text};
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: type == "staff" ? ApiUrl.changeStaffPassword : ApiUrl.changeParentPassword,
      method: MethodType.patch,
      params: params,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        Get.back();
        toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
        isLoading.value = false;
        update();
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
