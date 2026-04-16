import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';

class ReminderToParentsInformationController extends GetxController {
  /// Student Name
  TextEditingController studentNameController = TextEditingController();
  var isSelect = 0.obs;

  var errorStudentName = ''.obs;

  /// Reminder Title
  TextEditingController reminderTitleController = TextEditingController();
  var errorReminderTitle = ''.obs;

  /// Description
  TextEditingController descriptionController = TextEditingController();
  var errorDescription = ''.obs;

  var studentId = 0;
  var year = 2025;
  var month = 8;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      studentId = Get.arguments['studentId'];
      year = Get.arguments['year'] ?? year;
      month = Get.arguments['month'] ?? month;

      log('year=======>$year');
      log('month=======>$month');
    }
    studentNameController.text =Get.arguments['studentName']??'' ;
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
    errorReminderTitle.value = '';
    errorDescription.value = '';

    bool isValid = true;

    if (reminderTitleController.text.trim().isEmpty) {
      errorReminderTitle.value = AppMessage.pleaseEnterReminderTitle;
      isValid = false;
    }
    if (descriptionController.text.trim().isEmpty) {
      errorDescription.value = AppMessage.pleaseEnterDescription;
      isValid = false;
    }
    return isValid;
  }

RxBool isLoading= false.obs;

  remainingFeesApi() async {
    final param = {
      "student_id": studentId,
      "month": month,
      "year": year,
      "body": descriptionController.text,
      "title": reminderTitleController.text,
    };
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.remainingFees,
      method: MethodType.post,
      params: param,
      successCallback: (response, message) async {
        isLoading.value = false;
        if (response['status'] == 1) {
          Get.back(result: 1);
        }
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
