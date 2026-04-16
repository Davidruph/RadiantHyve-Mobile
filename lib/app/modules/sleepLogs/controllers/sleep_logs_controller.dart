import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/ListSleepLoagStudentModel.dart';

class SleepLogsController extends GetxController {
  final searchController = TextEditingController();

  @override
  void onInit() {
    listMenuStudentApi();
    internetChecker();
    scrollController = ScrollController()..addListener(loadMore);
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

  String formatTimeTo12Hour(String time24) {
    try {
      final DateTime dt = DateFormat("HH:mm:ss").parse(time24);
      return DateFormat("hh:mm a").format(dt);
    } catch (e) {
      return time24;
    }
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
        listMenuStudentApi();
        update();
      }
    });
  }
  //endregion
  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;
  RxBool isLoading = false.obs;
  ScrollController scrollController = ScrollController();
  List<ListSleepLogsStudentData> listSleepLogsStudentDataList = [];

  listMenuStudentApi({var LoadMore}) async {
    if (LoadMore != 1) {
      isLoading.value = true;
      page = 1;
    } else {
      isLoadMoreRunning.value = false;
    }
    String baseUrl =
        "${ApiUrl.listSleepLoagStudent}?page=$page"
        "${searchController.text.trim().isNotEmpty ? "&search=${searchController.text.trim()}" : ""}";
    return NetworkClient.getInstance.callApi(
      baseUrl: baseUrl,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        ListSleepLogsStudentModel listSleepLogsStudentModel = ListSleepLogsStudentModel.fromJson(response);
        if (listSleepLogsStudentModel.status == 1) {
          if (LoadMore != 1) {
            listSleepLogsStudentDataList = listSleepLogsStudentModel.data!;
            isLoading.value = false;
          } else {
            isLoadMoreRunning.value = false;
            if (listSleepLogsStudentDataList.isNotEmpty) {
              listSleepLogsStudentDataList.addAll(listSleepLogsStudentModel.data!);
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
      await listMenuStudentApi(LoadMore: 1);
    }
  }
}
