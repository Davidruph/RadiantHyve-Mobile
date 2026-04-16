import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../commonWidgets/constant.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../resetPassword/views/reset_password_view.dart';

class VerificationController extends GetxController {
  TextEditingController otpPin = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  Timer? _timer;

  var remainingTime = 60.obs;

  String get formattedTime {
    int minutes = remainingTime.value ~/ 60;
    int seconds = remainingTime.value % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void startTimer() {
    _timer?.cancel();
    remainingTime.value = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
      }
    });
  }

  var emailId, otp;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      otp = Get.arguments['otp'];
      emailId = Get.arguments['emailId'];
    }
    startTimer();
    remainingTime.value = 60;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  RxBool isLoading = false.obs;

  forgotVerifyApi({required BuildContext context}) async {
    final param = {"email": emailId, "otp": otpPin.text, "role": 'teacher'};
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.forgotVerify,
      method: MethodType.post,
      params: param,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          box.write(PrefsKey.refreshToken, '${response['refresh_token']}');
          Get.to(() => ResetPasswordView(), arguments: {'emailId': emailId});
        } else {
          isLoading.value = false;
        }
        otpPin.clear();

        isLoading.value = false;
        update();
      },
      failureCallback: (status, message) {
        otpPin.clear();
        isLoading.value = false;
        update();
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

  RxBool isResendOtpLoading = false.obs;

  resendOtpApi({required BuildContext context}) async {
    final param = {"email": emailId, "role": "teacher"};
    isResendOtpLoading.value = true;
    isResendOtpLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isResendOtpLoading.value = false;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.forgotePassword,
      method: MethodType.post,
      params: param,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          FocusScope.of(context).requestFocus(focusNode);
          startTimer();
          update();
        } else {
          isResendOtpLoading.value = false;
        }
        isResendOtpLoading.value = false;
      },
      failureCallback: (status, message) {
        isResendOtpLoading.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isResendOtpLoading.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
}
