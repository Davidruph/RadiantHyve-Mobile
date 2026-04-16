import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../staffLeave/model/ListLeaveRequetsModel.dart';

class StaffLeaveCalendarController extends GetxController {
  var selectedDay = DateTime.now();
  var isLoading = false.obs;

  List dateList = [];

  List<ListLeaveRequetsData> staffLeaveList = [];

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(ListLeaveLoadMore);
    internetChecker();
    ListLeaveRequetsAPI();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    if (internetCheckerSubscription != null) {
      internetCheckerSubscription.cancel();
    }
  }

  //region List Leave Requets API
  var isLoadMoreRunning = false.obs;
  var page = 1, hasNextPage = true.obs;
  ScrollController scrollController = ScrollController();

  ListLeaveRequetsAPI({int isLoadMore = 0}) async {
    if (isLoadMore == 1) {
      isLoadMoreRunning.value = true;
    } else {
      page = 1;
      isLoading.value = true;
      isLoadMoreRunning.value = false;
      hasNextPage.value = true;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.listLeaves}?page=$page&date=${selectedDay.toString().split(" ").first}",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        ListLeaveRequetsModel responseData = ListLeaveRequetsModel.fromJson(response);

        if (isLoadMore != 1) {
          if (responseData.listLeaveRequetsData != null) {
            staffLeaveList = responseData.listLeaveRequetsData ?? [];
          }
        } else {
          if (responseData.listLeaveRequetsData!.isNotEmpty) {
            staffLeaveList.addAll(responseData.listLeaveRequetsData ?? []);
            isLoadMoreRunning.value = false;
          } else {
            hasNextPage.value = false;
            isLoadMoreRunning.value = false;
          }
        }
        isLoading.value = false;
        update();
      },
      failureCallback: (status, message) {
        isLoading.value = false;
        isLoadMoreRunning.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isLoading.value = false;
        isLoadMoreRunning.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
  //endregion

  //region Check internet connection function
  var internetCheckerSubscription;
  bool isDeviceConnected = true;

  Future<void> internetChecker() async {
    internetCheckerSubscription = Connectivity().onConnectivityChanged.listen((result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected) {
        isLoading.value = true;
        update();
      } else {
        ListLeaveRequetsAPI();
        update();
      }
    });
  }
  //endregion

  //region List Student LoadMore Function
  Future<void> ListLeaveLoadMore() async {
    if (hasNextPage.value &&
        !isLoading.value &&
        !isLoadMoreRunning.value &&
        scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await ListLeaveRequetsAPI(isLoadMore: 1);
    }
  }
  //endregion

  //region List Leave Requets API
  UpdateLeaveStatusAPI({status, leaveId, index}) async {
    if (status == "accepted") {
      staffLeaveList[index].isAcceptLoader = true;
    } else {
      staffLeaveList[index].isRejectLoader = true;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.updateLeaveStatus,
      method: MethodType.put,
      params: {"leave_id": leaveId, "leave_request_status": status},
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        if (response["status"] == 1) {
          toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
          if (status == "accepted") {
            staffLeaveList[index].leaveRequestStatus = "accepted";
          } else {
            staffLeaveList[index].leaveRequestStatus = "rejected";
          }
        } else {
          toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
        }
        staffLeaveList[index].isRejectLoader = false;
        staffLeaveList[index].isAcceptLoader = false;
        update();
      },
      failureCallback: (status, message) {
        staffLeaveList[index].isRejectLoader = false;
        staffLeaveList[index].isAcceptLoader = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        staffLeaveList[index].isRejectLoader = false;
        staffLeaveList[index].isAcceptLoader = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
  //endregion
}
