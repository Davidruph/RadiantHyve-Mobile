import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/common.dart';
import '../../home/model/ListAttendanceModel.dart';

class StaffDailyAttendanceController extends GetxController {
  RxInt userId = 0.obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      userId.value = Get.arguments["user_id"];
      print('userId.value====>${userId.value}');
    }
    listAttendanceApi();
    scrollController.addListener(loadMore);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;
  RxBool isLoading = false.obs;
  List<AttendanceData> attendanceList = [];

  //region List Attendance Api
  listAttendanceApi({var LoadMore}) async {
    if (LoadMore != 1) {
      isLoading.value = true;
      page = 1;
    } else {
      isLoadMoreRunning.value = true;
    }

    log("page----->$page");
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.getOtherAttendance}?page=$page&user_id=${userId.value}",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        ListAttendanceModel model = ListAttendanceModel.fromJson(response);
        if (model.status == 1) {
          final List<AttendanceData>? newData = model.attendanceData;
          if (LoadMore != 1) {
            attendanceList = newData!;
          } else {
            if (newData != null && newData.isNotEmpty) {
              attendanceList.addAll(newData);
            } else {
              hasNextPage.value = false;
            }
          }
        } else {
          hasNextPage.value = false;
        }

        isLoading.value = false;
        isLoadMoreRunning.value = false;
        update();
      },
      failureCallback: (status, message) {
        isLoading.value = false;
        isLoadMoreRunning.value = false;
        toastyInfo.showToast(message: message ?? "Something went wrong");
      },
      timeOutCallback: () {
        isLoading.value = false;
        isLoadMoreRunning.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
  //endregion

  Future<void> loadMore() async {
    if (hasNextPage.value &&
        !isLoading.value &&
        !isLoadMoreRunning.value &&
        scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await listAttendanceApi(LoadMore: 1);
    }
  }
}
