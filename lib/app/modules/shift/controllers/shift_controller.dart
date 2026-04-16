import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../model/ListShiftModel.dart';

class ShiftController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  var selectedIndex = -1;

  List<ListShiftData> shiftList = [];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(ListStudentLoadMore);
    internetChecker();
    listShiftAPI();
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
        listShiftAPI();
        update();
      }
    });
  }

  //endregion

  //region List Student api
  var isLoadMoreRunning = false.obs;
  var page = 1, hasNextPage = true.obs;

  listShiftAPI({int isLoadMore = 0}) async {
    if (isLoadMore == 1) {
      isLoadMoreRunning.value = true;
    } else {
      page = 1;
      isLoading.value = true;
      isLoadMoreRunning.value = false;
      hasNextPage.value = true;
      shiftList.clear();
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: searchController.text.isNotEmpty ? "${ApiUrl.listShift}?page=$page&search=${searchController.text}" : "${ApiUrl.listShift}?page=$page",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        ListShiftModel responseData = ListShiftModel.fromJson(response);
        if (isLoadMore != 1) {
          if (responseData.listShiftData != null) {
            shiftList = responseData.listShiftData ?? [];
          }
        } else {
          if (responseData.listShiftData!.isNotEmpty) {
            shiftList.addAll(responseData.listShiftData ?? []);
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

  //region List Student LoadMore Function
  ScrollController scrollController = ScrollController();

  Future<void> ListStudentLoadMore() async {
    if (hasNextPage.value &&
        !isLoading.value &&
        !isLoadMoreRunning.value &&
        scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await listShiftAPI(isLoadMore: 1);
    }
  }
//endregion
}
