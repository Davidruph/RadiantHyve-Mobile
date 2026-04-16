import 'package:get/get.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../shift/model/ListShiftModel.dart';

class ShiftDetailsController extends GetxController {
  ListShiftData? shiftData;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      shiftData = Get.arguments["details"];
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

  var isDeleteLoading = false.obs;

  deleteShiftApi({shiftID}) async {
    isDeleteLoading.value = true;
    update();
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.deleteShift}/?shift_id=${shiftData!.id}",
      method: MethodType.delete,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back(result: {'shiftID': shiftData!.id});
        } else {
          isDeleteLoading.value = false;
        }
        isDeleteLoading.value = false;
      },
      failureCallback: (status, message) {
        isDeleteLoading.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isDeleteLoading.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
}
