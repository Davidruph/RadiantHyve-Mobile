
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../../shift/model/ListShiftModel.dart';

class AddShiftInformationController extends GetxController {
  ListShiftData? shiftData;

  /// Shift Name
  TextEditingController shiftNameController = TextEditingController();
  var isSelect = 0.obs, flag;
  var errorShiftName = ''.obs;

  /// Shift Fee
  TextEditingController shiftFeeController = TextEditingController();
  var errorShiftFee = ''.obs;
  TextEditingController lateFeeController = TextEditingController();
  var errorLateFee = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      flag = Get.arguments['flag'];
      if (flag == 'editShift') {
        shiftData = Get.arguments["details"];
        shiftNameController.text = shiftData!.shiftName!;
        shiftFeeController.text = shiftData!.shiftFee!.toString();
        lateFeeController.text = shiftData!.penalty?.toString() ?? '0';
      }
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
    errorShiftName.value = '';
    errorShiftFee.value = '';
    errorLateFee.value = '';

    bool isValid = true;

    if (shiftNameController.text.trim().isEmpty) {
      errorShiftName.value = AppMessage.pleasEnterShiftName;
      isValid = false;
    }
    if (shiftFeeController.text.trim().isEmpty) {
      errorShiftFee.value = AppMessage.pleaseEnterShiftFee;
      isValid = false;
    }
    if (lateFeeController.text.trim().isEmpty) {
      errorLateFee.value = AppMessage.pleaseEnterLatFee;
      isValid = false;
    }
    return isValid;
  }

  //region Add AddShift Api
  RxBool isLoading = false.obs;

  AddShiftApi() async {
    Map<String, dynamic> params = {"shift_name": shiftNameController.text, "shift_fee": shiftFeeController.text, "penalty": lateFeeController.text};
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.addShift,
      method: MethodType.post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      params: params,
      successCallback: (response, message) async {
        Get.back(result: 1);
        isLoading.value = false;
        toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
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

  //endregion

  //region Add EditShift Api
  EditShiftApi() async {
    Map<String, dynamic> params = {
      "shift_id": shiftData!.id,
      "shift_name": shiftNameController.text,
      "shift_fee": shiftFeeController.text,
      "penalty": lateFeeController.text,
    };

    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.editShift,
      method: MethodType.put,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      params: params,
      successCallback: (response, message) async {
        shiftData!.shiftName = response["data"]["shift_name"];
        shiftData!.shiftFee = int.parse(response["data"]["shift_fee"]);
        isLoading.value = false;
        toastyInfo.showToast(message: "Shift edit successfully", backgroundColor: color.appColor);
        Get.back(result: 2);
        Get.back(result: 2);
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
//endregion
}
