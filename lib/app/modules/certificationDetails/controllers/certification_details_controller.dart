import 'dart:developer';

import 'package:get/get.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../certification/model/CertificateListModel.dart';

class CertificationDetailsController extends GetxController {
  CertificateListData? certification;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      certification = Get.arguments["details"];
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

  //region Delete Certification API
  RxBool isDeleteLoader = false.obs;
  deleteCertificationApi() async {
    isDeleteLoader.value = true;
    update();
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.deleteCertification}?certificate_id=${certification!.id}",
      method: MethodType.delete,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        log("response----->$response");
        Get.back(result: 1);
        Get.back(result: 1);
        toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
        isDeleteLoader.value = false;
        update();
      },
      failureCallback: (status, message) {
        isDeleteLoader.value = false;
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
  //endregion
}
