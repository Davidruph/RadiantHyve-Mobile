import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../Model/BirthdayModel.dart';

class UpcomingBirthdayController extends GetxController {
  ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var selectedIndex = 0.obs;

  List<BirthdayData> upcomingBirthdayList = [];

  void changeTab(int index) {
    selectedIndex.value = index;
    listBirthdayAPI(tab: selectedIndex.value);
    update();
  }

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(ListBirthdayLoadMore);
    listBirthdayAPI(tab: selectedIndex.value);
    internetChecker();
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
    upcomingBirthdayList.clear();
  }

  //region List birthday API
  var isLoadMoreRunning = false.obs;
  var page = 1, hasNextPage = true.obs;

  listBirthdayAPI({int isLoadMore = 0, tab}) async {
    if (isLoadMore == 1) {
      isLoadMoreRunning.value = true;
    } else {
      page = 1;
      isLoading.value = true;
      isLoadMoreRunning.value = false;
      hasNextPage.value = true;
      upcomingBirthdayList.clear();
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: tab == 0 ? "${ApiUrl.listUpcomingBirthday}?page=$page&type=staff" : "${ApiUrl.listUpcomingBirthday}?page=$page&type=student",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        BirthdayModel responseData = BirthdayModel.fromJson(response);
        if (isLoadMore != 1) {
          if (responseData.birthdayData != null) {
            upcomingBirthdayList.clear();
            upcomingBirthdayList = responseData.birthdayData ?? [];
          }
        } else {
          if (responseData.birthdayData!.isNotEmpty) {
            upcomingBirthdayList.addAll(responseData.birthdayData ?? []);
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

  //region List Birthday Load More Function
  Future<void> ListBirthdayLoadMore() async {
    if (hasNextPage.value &&
        !isLoading.value &&
        !isLoadMoreRunning.value &&
        scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await listBirthdayAPI(isLoadMore: 1, tab: selectedIndex.value);
    }
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
        listBirthdayAPI(tab: selectedIndex.value);
        update();
      }
    });
  }
  //endregion
}
