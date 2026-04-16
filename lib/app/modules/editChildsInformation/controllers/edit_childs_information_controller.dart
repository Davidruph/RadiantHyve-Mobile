import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/StudentsListModel.dart';

class EditChildsInformationController extends GetxController {
  List<StudentsListData> studentsListDataList = [];
  var isLoading = false.obs;

  @override
  void onInit() {
    scrollController.addListener(StudentsListLoadMore);
    studentsListAPI();
    internetChecker();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    if (internetCheckerSubscription != null) {
      internetCheckerSubscription.cancel();
    }
    super.onClose();
  }
  var isLoadMoreRunning = false.obs;
  var page = 1, hasNextPage = true.obs;

  ScrollController scrollController = ScrollController();

  studentsListAPI({int isLoadMore = 0}) async {
    if (isLoadMore == 1) {
      isLoadMoreRunning.value = true;
    } else {
      page = 1;
      isLoading.value = true;
      isLoadMoreRunning.value = false;
      hasNextPage.value = true;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.studentsList}?page=$page",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        log("response-------->${response}");
        StudentsListModel responseData = StudentsListModel.fromJson(response);

        if (isLoadMore != 1) {
          if (responseData.data != null) {
            studentsListDataList = responseData.data ?? [];
          }
        } else {
          if (responseData.data!.isNotEmpty) {
            studentsListDataList.addAll(responseData.data ?? []);
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

  Future<void> StudentsListLoadMore() async {
    if (hasNextPage.value &&
        !isLoading.value &&
        !isLoadMoreRunning.value &&
        scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await studentsListAPI(isLoadMore: 1);
    }
  }

  var internetCheckerSubscription;
  bool isDeviceConnected = true;

  Future<void> internetChecker() async {
    internetCheckerSubscription = Connectivity().onConnectivityChanged.listen((result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected) {
        isLoading.value = true;
        update();
      } else {
        studentsListAPI();
        update();
      }
    });
  }
}
