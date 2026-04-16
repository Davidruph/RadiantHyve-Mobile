import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../assignedStudent/model/GetAssignStudentModel.dart';
import '../../assignedStudent/model/GetShiftModel.dart';
import '../model/ListNewStudentModel.dart';

class StudentListController extends GetxController {
  ScrollController scrollController = ScrollController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController0 = TextEditingController();
  TextEditingController searchController1 = TextEditingController();
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
    newStudentList.clear();
    log('index :- $index');
    listStudentAPI(tab: selectedIndex.value);
  }

  // void changeTab(int index) {
  //   selectedIndex.value = index;
  //   newStudentList.clear();
  //   listStudentAPI(tab: selectedIndex.value);
  // }

  List<GetAssignStudentData> newStudentList = [];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getShiftApi();
    scrollController.addListener(ListStudentLoadMore);
    listStudentAPI(tab: 0);
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
    newStudentList.clear();
  }

  //region List Student api
  var isLoadMoreRunning = false.obs;
  var page = 1, hasNextPage = true.obs;

  listStudentAPI({int isLoadMore = 0, tab}) async {
    if (isLoadMore == 1) {
      isLoadMoreRunning.value = true;
    } else {
      page = 1;
      isLoading.value = true;
      isLoadMoreRunning.value = false;
      hasNextPage.value = true;
      newStudentList.clear();
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: tab == 0
          ? searchController0.text.isNotEmpty
              ? "${ApiUrl.listAllStudent}?page=$page&shift_id=${shiftId.value}&search=${searchController0.text}"
              : "${ApiUrl.listAllStudent}?page=$page&shift_id=${shiftId.value}"
          : searchController1.text.isNotEmpty
              ? "${ApiUrl.listNewStudent}?page=$page&search=${searchController1.text}"
              : "${ApiUrl.listNewStudent}?page=$page",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        ListNewStudentModel responseData = ListNewStudentModel.fromJson(response);
        if (isLoadMore != 1) {
          if (responseData.getStudentData != null) {
            newStudentList = responseData.getStudentData ?? [];
          }
        } else {
          if (responseData.getStudentData!.isNotEmpty) {
            newStudentList.addAll(responseData.getStudentData ?? []);
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

  //region Remove Filter Function
  RxInt shiftId = 0.obs;
  List<GetShiftData> getShiftDataList = [];

  removeFilter() {
    shiftId.value = 0;
    Get.back();
    listStudentAPI(tab: selectedIndex.value);
  }

  //endregion

  //region getShift Api
  getShiftApi() async {
    // isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.getShift,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        GetShiftModel model = GetShiftModel.fromJson(response);
        print('response=======>$response');
        if (model.status == 1) {
          getShiftDataList = model.data!;
        }
        // isLoading.value = false;
        update();
      },
      failureCallback: (status, message) {
        // isLoading.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        // isLoading.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
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
      await listStudentAPI(isLoadMore: 1, tab: selectedIndex.value);
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
        listStudentAPI(tab: selectedIndex.value);
        update();
      }
    });
  }
//endregion
}
