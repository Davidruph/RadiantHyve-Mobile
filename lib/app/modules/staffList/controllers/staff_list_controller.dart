import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../model/ListStaffModel.dart';

class StaffListController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchController = TextEditingController();
  var selectedIndex = -1;

  List<StaffData> staffList = [];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(ListStudentLoadMore);
    listStaffAPI();
    internetChecker();
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

  //region List staff api
  var isLoadMoreRunning = false.obs;
  var page = 1, hasNextPage = true.obs;
  ScrollController scrollController = ScrollController();

  listStaffAPI({int isLoadMore = 0}) async {
    if (isLoadMore == 1) {
      isLoadMoreRunning.value = true;
    } else {
      page = 1;
      isLoading.value = true;
      isLoadMoreRunning.value = false;
      hasNextPage.value = true;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: searchController.text.isEmpty ? "${ApiUrl.listStaff}?page=$page" : "${ApiUrl.listStaff}?page=$page&search=${searchController.text}",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        log("response-------->${response}");
        ListStaffModel responseData = ListStaffModel.fromJson(response);

        if (isLoadMore != 1) {
          if (responseData.staffData != null) {
            staffList = responseData.staffData ?? [];
          }
        } else {
          if (responseData.staffData!.isNotEmpty) {
            staffList.addAll(responseData.staffData ?? []);
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
        listStaffAPI();
        update();
      }
    });
  }
  //endregion

  //region List Student LoadMore Function
  Future<void> ListStudentLoadMore() async {
    if (hasNextPage.value &&
        !isLoading.value &&
        !isLoadMoreRunning.value &&
        scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await listStaffAPI(isLoadMore: 1);
    }
  }
  //endregion
}
