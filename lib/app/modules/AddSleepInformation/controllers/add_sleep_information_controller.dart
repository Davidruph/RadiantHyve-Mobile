
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../sleepLogs/model/ListSleepLoagStudentModel.dart';

class AddSleepInformationController extends GetxController {
  ListSleepLogsStudentData? listSleepLogsStudentData;

  /// Student Name
  TextEditingController studentNameController = TextEditingController();
  var isSelect = 0.obs;
  var errorStudentName = ''.obs;

  /// Parents Name
  TextEditingController parentsNameController = TextEditingController();
  var errorParentsName = ''.obs;

  /// Email
  TextEditingController emailController = TextEditingController();
  var errorEmail = ''.obs;

  /// Time to Sleeping
  TextEditingController timeToSleepingController = TextEditingController();
  var errorTimeToSleeping = ''.obs;
  RxString sleepingTimeForApi = ''.obs;

  /// Time to Wake up
  TextEditingController timeToWakeUpController = TextEditingController();
  var errorTimeToWakeUp = ''.obs;
  RxString toWakeUpTimeForApi = ''.obs;

  var flag;
  var studentId, addStudentId;

  String formatTimeTo12Hour(String time24) {
    try {
      final DateTime dateTime = DateFormat("HH:mm:ss").parse(time24);
      final String formattedTime = DateFormat("hh:mm a").format(dateTime);
      return formattedTime;
    } catch (e) {
      return '';
    }
  }

  String formatTimeTo24Hour(String timeWithSeconds) {
    try {
      final dateTime = DateFormat("HH:mm:ss").parse(timeWithSeconds);
      return DateFormat("HH:mm").format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  void onInit() {
    if (Get.arguments != null) {
      listSleepLogsStudentData = Get.arguments['sleepLogsData'];
      studentNameController.text = listSleepLogsStudentData?.fullName;
      parentsNameController.text = listSleepLogsStudentData?.parentName;
      emailController.text = listSleepLogsStudentData?.email ?? '';
      studentId = listSleepLogsStudentData?.sleepLoag?.id;
      addStudentId = listSleepLogsStudentData?.id;
      flag = Get.arguments['flag'];
      if (flag == 'editSleepLogs') {
        timeToSleepingController.text = formatTimeTo12Hour(listSleepLogsStudentData?.sleepLoag?.startTime); // UI
        sleepingTimeForApi.value = formatTimeTo24Hour(listSleepLogsStudentData?.sleepLoag?.startTime ?? ''); // API
        timeToWakeUpController.text = formatTimeTo12Hour(listSleepLogsStudentData?.sleepLoag?.endTime); // UI
        toWakeUpTimeForApi.value = formatTimeTo24Hour(listSleepLogsStudentData?.sleepLoag?.endTime ?? ''); // API
      }
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

  TimeOfDay? sleepingTime;

  Future<void> selectSleepingTime(BuildContext context) async {
    TimeOfDay initialTime;
    if (sleepingTimeForApi.value.isNotEmpty) {
      try {
        final parts = sleepingTimeForApi.value.split(":");
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        initialTime = TimeOfDay(hour: hour, minute: minute);
      } catch (e) {
        initialTime = TimeOfDay.now();
      }
    } else {
      initialTime = TimeOfDay.now();
    }

    // TimeOfDay initialTime = sleepingTime ?? TimeOfDay.now();

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.input,

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: color.appColor,
            hintColor: color.appColor,
            colorScheme: ColorScheme.light(primary: color.appColor, onPrimary: color.white, onSurface: color.black),
            timePickerTheme: TimePickerThemeData(
              dayPeriodColor: color.appColor,
              dayPeriodTextColor: color.black,
              dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: color.white)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      sleepingTime = pickedTime; // save selected time for reuse
      timeToSleepingController.text = pickedTime.format(context);

      final dt = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, pickedTime.hour, pickedTime.minute);
      final formattedApiTime = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

      sleepingTimeForApi.value = formattedApiTime;
      errorTimeToSleeping.value = '';
    } else {
      errorTimeToSleeping.value = 'Please select a time';
    }
  }

  TimeOfDay? wakeUpTime;

  Future<void> selectToWakeUpTime(BuildContext context) async {
    TimeOfDay initialTime;
    if (toWakeUpTimeForApi.value.isNotEmpty) {
      try {
        final parts = toWakeUpTimeForApi.value.split(":");
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        initialTime = TimeOfDay(hour: hour, minute: minute);
      } catch (e) {
        initialTime = TimeOfDay.now();
      }
    } else {
      initialTime = TimeOfDay.now();
    }

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: color.appColor,
            hintColor: color.appColor,
            colorScheme: ColorScheme.light(primary: color.appColor, onPrimary: color.white, onSurface: color.black),
            timePickerTheme: TimePickerThemeData(
              dayPeriodColor: color.appColor,
              dayPeriodTextColor: color.black,
              dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: color.white)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      wakeUpTime = pickedTime;
      timeToWakeUpController.text = pickedTime.format(context);

      final dt = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, pickedTime.hour, pickedTime.minute);
      final formattedApiTime = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      toWakeUpTimeForApi.value = formattedApiTime;
      errorTimeToWakeUp.value = '';
    } else {
      errorTimeToWakeUp.value = 'Please select a time';
    }
  }

  bool isValidation() {
    errorTimeToSleeping.value = '';
    errorTimeToWakeUp.value = '';
    bool isValid = true;
    if (timeToSleepingController.text.trim().isEmpty) {
      errorTimeToSleeping.value = AppMessage.pleaseSelectTimeToSleeping;
      isValid = false;
    }
    if (timeToWakeUpController.text.trim().isEmpty) {
      errorTimeToWakeUp.value = AppMessage.pleaseSelectTimeToWakeUp;
      isValid = false;
    }
    return isValid;
  }

  RxBool isLoading = false.obs;

  addSleepLogsApi() async {
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    final param = {"student_id": addStudentId, "start_time": sleepingTimeForApi.value, "end_time": toWakeUpTimeForApi.value};
    log('param=====>$param');
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.addSleepLogs,
      method: MethodType.post,
      params: param,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back(result: 1);
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

  editSleepLogsApi() async {
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    final param = {"id": studentId, "start_time": sleepingTimeForApi.value, "end_time": toWakeUpTimeForApi.value};
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.editSleepLogs,
      method: MethodType.put,
      params: param,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back(result: 1);
          Get.back(result: 1);
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
