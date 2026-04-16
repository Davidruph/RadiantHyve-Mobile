import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';

class AddLeaveController extends GetxController {
  /// Gender
  var errorLeaveType = ''.obs;
  String? selectedLeaveType;

  List<String> leaveTypeList = ['Bereavement Leave', 'Casual Leave (CL)', 'Compensatory Off (comp-off)', 'Loss Of Pay Leave (LOP/LWP)', 'Marriage Leave', 'Maternity Leave (ML)', 'Sick Leave (SL)'];

  /// Date of Birth
  TextEditingController dateController = TextEditingController();
  var isSelect = 0.obs;
  DateTime? date;
  var dateOf = ''.obs;
  var errorDate = ''.obs;

  /// Reason
  TextEditingController reasonController = TextEditingController();
  var errorReason = ''.obs;

  Future dateOfLeaveCalendar(BuildContext context) async {
    date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: color.appColor, onPrimary: Colors.white, onSurface: Colors.black),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color.appColor)),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      dateController.text = DateFormat("yyy-MM-dd").format(DateTime.parse(date.toString()));
      errorDate.value = '';
      update();
    }
  }

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
    errorLeaveType.value = '';
    errorDate.value = '';
    errorReason.value = '';

    bool isValid = true;

    if (dateController.text.trim().isEmpty) {
      errorDate.value = AppMessage.pleaseSelectYourDate;
      isValid = false;
    }
    if (reasonController.text.trim().isEmpty) {
      errorReason.value = AppMessage.pleaseEnterYourReason;
      isValid = false;
    }
    if (selectedLeaveType == null) {
      errorLeaveType.value = AppMessage.pleaseSelectYourLeaveType;
      isValid = false;
    }
    return isValid;
  }

  RxBool isLoading = false.obs;

  staffApplyLeaveApi() async {
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    final param = {"leave_type": selectedLeaveType, "reason": reasonController.text.trim(), "date": dateController.text.trim()};
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.staffApplyLeave,
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
}
