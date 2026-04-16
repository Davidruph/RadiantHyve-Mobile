import 'package:get/get.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../medication/model/ListMedificationStudentModel.dart';

class MedicationInformationController extends GetxController {
  ListMedicationStudentData? listMedicationStudentData;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      listMedicationStudentData = Get.arguments['medicationData'];
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

  deleteMedificationApi() async {
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.deleteMedification}/?medication_id=${listMedicationStudentData?.id}",
      method: MethodType.delete,
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
