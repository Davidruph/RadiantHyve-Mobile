import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:radianthyve_unified/commonWidgets/constant.dart';
import 'package:radianthyve_unified/utils/prefsKey.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';

class ChangePasswordController extends GetxController {
  /// Email
  TextEditingController emailController = TextEditingController();
  var isSelect = 0.obs;
  var errorEmail = ''.obs;

  /// Old Password
  TextEditingController oldPasswordController = TextEditingController();
  var errorOldPassword = ''.obs;
  var isVisibilityOldPassword = true.obs;

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
    emailController.text = box.read(PrefsKey.emailId);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var isOldPassword = false.obs, isNewPassword = false.obs, isConfirmPassword = false.obs;

  isValidOldPassword() {
    isOldPassword.value = isValidationOldPassword();
    if (newPasswordController.text.trim().isNotEmpty) {
      isNewPassword.value = isValidationNewPassword();
    }
  }

  isValidNewPassword() {
    isNewPassword.value = isValidationNewPassword();
    if (oldPasswordController.text.trim().isNotEmpty) {
      isOldPassword.value = isValidationOldPassword();
    }
  }

  isValidConfirmPassword() {
    isConfirmPassword.value = isValidationConPassword();
  }

  bool isValidationOldPassword() {
    bool isValid = true;
    errorOldPassword.value = "";
    String password = oldPasswordController.text.trim();
    if (password.isEmpty) {
      errorOldPassword.value = "Current password is required.";
      isValid = false;
    } else if (password.length < 8) {
      errorOldPassword.value = "Current password must be at least 8 characters long.";
      isValid = false;
    }
    return isValid;
  }

  bool isValidationNewPassword() {
    errorNewPassword.value = "";
    bool isValid = true;
    String newPassword = newPasswordController.text.trim();
    String oldPassword = oldPasswordController.text.trim();
    if (newPassword.isEmpty) {
      errorNewPassword.value = "New password is required.";
      isValid = false;
    } else if (newPassword.length < 8) {
      errorNewPassword.value = "New password must be at least 8 characters long.";
      isValid = false;
    } else if (newPassword == oldPassword) {
      errorNewPassword.value = "New password cannot be the same as the current password.";
      isValid = false;
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$').hasMatch(newPassword)) {
      errorNewPassword.value = "New password must include uppercase and lowercase letters, a number, and a special character (e.g., Abc@1234).";
      isValid = false;
    }
    return isValid;
  }

  bool isValidationConPassword() {
    bool isValid = true;
    errorConfirmPassword.value = "";
    String confirmPassword = confirmPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    if (confirmPassword.isEmpty) {
      errorConfirmPassword.value = "Confirm password is required.";
      isValid = false;
    } else if (confirmPassword != newPassword) {
      errorConfirmPassword.value = "Passwords do not match. Please re-enter the same password.";
      isValid = false;
    }
    return isValid;
  }

  RxBool isLoading = false.obs;

  changePasswordApi({required BuildContext context}) async {
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    final param = {"password": oldPasswordController.text, "newPassword": newPasswordController.text};
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.changePassword,
      method: MethodType.patch,
      params: param,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back();
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
