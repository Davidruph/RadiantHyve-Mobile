import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:radianthyve_unified/app/modules/home/views/home_view.dart';
import 'package:radianthyve_unified/app/modules/home/views/teachers_home_view.dart';
import 'package:radianthyve_unified/app/modules/home/views/principal_home_view.dart';
import 'package:radianthyve_unified/commonWidgets/constant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/prefsKey.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/roleBasedNavigation.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/loginModel.dart';

class LoginController extends GetxController {
  /// Email
  TextEditingController emailController = TextEditingController();
  var isSelect = 0.obs;
  var errorEmail = ''.obs;

  /// Password
  TextEditingController passwordController = TextEditingController();
  var errorPassword = ''.obs;
  var isVisibilityPassword = true.obs;

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
    errorPassword.value = '';

    bool isValid = true;

    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

    final password = passwordController.text.trim();
    final email = emailController.text.trim();

    if (email.isEmpty) {
      errorEmail.value = AppMessage.pleaseEnterYourEmail;
      isValid = false;
    } else if (!emailRegex.hasMatch(email)) {
      errorEmail.value = AppMessage.pleaseEnterValidEmail;
      isValid = false;
    }

    if (password.isEmpty || password.length < 8) {
      errorPassword.value = password.isEmpty
          ? AppMessage.pleaseEnterYourPassword
          : "Password should be at least 8 characters long.";
      isValid = false;
    }

    return isValid;
  }

  RxBool isLoading = false.obs;

  loginApi() async {
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    final param = {
      "email": emailController.text,
      "password": passwordController.text,
      "device_id": await commonMethod.getDeviceId(),
      "device_token": await commonMethod.getDeviceToken(),
      "device_type": Platform.isIOS ? 'ios' : 'android',
    };
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.login,
      method: MethodType.post,
      params: param,
      successCallback: (response, message) async {
        LoginModel responseData = LoginModel.fromJson(response);
        if (response['status'] == 1) {
          await commonMethod.storeUserData(responseData);
          // Store user role for role-based navigation
          if (responseData.data?.role != null) {
            await box.write(PrefsKey.role, responseData.data!.role);
          }
          // Route to correct home view based on role
          final userRole = getUserRole().toLowerCase();
          switch (userRole) {
            case 'teacher':
              Get.offAll(() => const TeachersHomeView());
              break;
            case 'principal':
            case 'admin':
              Get.offAll(() => const PrincipalHomeView());
              break;
            default:
              Get.offAll(() => HomeView());
          }
          toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
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
