import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../home/model/ListAttendanceModel.dart';

class DailyAttendanceController extends GetxController {
  String formatApiTime(String utcTime) {
    DateTime dateTimeUtc = DateTime.parse(utcTime);
    DateTime localTime = dateTimeUtc.toLocal();
    return DateFormat('hh:mm a').format(localTime);
  }

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      loadMore(); // this is CRITICAL
    });
    internetChecker();
    listAttendanceApi();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

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
        listAttendanceApi();
        update();
      }
    });
  }
  //endregion

  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;
  RxBool isLoading = false.obs;
  List<AttendanceData> attendanceList = [];

  listAttendanceApi({var LoadMore}) async {
    if (LoadMore != 1) {
      isLoading.value = true;
      page = 1;
    } else {
      isLoadMoreRunning.value = true;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.attendanceList}/?page=$page",
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

  Future<dynamic> loadMore() async {
    if (hasNextPage.value == true && isLoading.value == false && isLoadMoreRunning.value == false && scrollController.offset >= scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await listAttendanceApi(LoadMore: 1);
    }
  }
}
