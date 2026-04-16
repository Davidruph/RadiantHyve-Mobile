import 'dart:math';

import 'package:get/get.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../model/GetSosModel.dart';

class EmergencyController extends GetxController {
  bool isChecked = false;

  var selectedEmergency = false.obs;
  var selectedEmergencyOptions = 'Select'.obs;
  var sosId = 0.obs;
  var errorEmergency = ''.obs;

  @override
  void onInit() {
    getSosApi();
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
    errorEmergency.value = '';
    bool isValid = true;
    if (selectedEmergencyOptions == 'Select') {
      errorEmergency.value = AppMessage.pleaseSelectYourEmergencySituation;
      isValid = false;
    }
    return isValid;
  }

  List<GetSosModelData> GetSosModelDataList = [];

  getSosApi() async {
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.getSos,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        GetSosModel model = GetSosModel.fromJson(response);
        print('response===>$response');
        if (model.status == 1) {
          GetSosModelDataList = model.data!;
        }
        update();
      },
      failureCallback: (status, message) {
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }

  RxBool isLoading = false.obs;

  createSosApi() async {
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.createSos,
      method: MethodType.post,
      params: {"sos_type_id":  "$sosId"},
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back();


        }isLoading.value = false;
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
