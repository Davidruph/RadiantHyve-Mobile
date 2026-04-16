import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/GetStudentAttedanceModel.dart';

class StudentDailyAttendanceController extends GetxController {
  var studentId;

  @override
  void onInit() {
    if (Get.arguments != null) {
      studentId = Get.arguments['studentId'];
    }
    getStudentAttedanceApi();
    scrollController = ScrollController()
      ..addListener(loadMore);
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

  List<GetStudentAttedanceData> getStudentAttedanceDataList = [];

  var isLoadMoreRunning = false.obs,
      hasNextPage = true.obs;
  var page = 1;
  RxBool isLoading = false.obs;
  ScrollController scrollController = ScrollController();

  getStudentAttedanceApi({var LoadMore}) async {
    if (LoadMore != 1) {
      isLoading.value = true;
      page = 1;
    } else {
      isLoadMoreRunning.value = false;
    }
    String baseUrl = "${ApiUrl.getStudentAttedance}?page=$page&student_id=$studentId";
    return NetworkClient.getInstance.callApi(
      baseUrl: baseUrl,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        GetStudentAttedanceModel attedanceModel = GetStudentAttedanceModel.fromJson(response);
        if (attedanceModel.status == 1) {
          if (LoadMore != 1) {
            getStudentAttedanceDataList = attedanceModel.data!;
            isLoading.value = false;
          } else {
            isLoadMoreRunning.value = false;
            if (getStudentAttedanceDataList.isNotEmpty) {
              getStudentAttedanceDataList.addAll(attedanceModel.data!);
              isLoading.value = false;
            } else {
              hasNextPage.value = false;
            }
          }
        } else {
          isLoading.value = false;
        }
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

  Future<dynamic> loadMore() async {
    if (hasNextPage.value == true &&
        isLoading.value == false &&
        isLoadMoreRunning.value == false &&
        scrollController.offset >= scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await getStudentAttedanceApi(LoadMore: 1);
    }
  }
}
