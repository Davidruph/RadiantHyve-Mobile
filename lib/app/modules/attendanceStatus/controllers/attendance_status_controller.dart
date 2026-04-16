import 'dart:developer';
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
import '../model/ListStudentAttedanceModel.dart';

class AttendanceStatusController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
    listStudentAttedanceApi();
  }

  final searchController = TextEditingController();
  Timer? _debounce;

  void debounceSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      page = 1;
      listStudentAttedanceApi();
    });
  }

  var flag, selectedDate;

  @override
  void onInit() {
    scrollController = ScrollController()..addListener(loadMore);
    if (Get.arguments != null) {
      flag = Get.arguments['flag'];
      selectedDate = Get.arguments['selectedDate'];
      log('selectedDate====>$selectedDate');
    }
    listStudentAttedanceApi();
    internetChecker();
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
        listStudentAttedanceApi();
        update();
      }
    });
  }
  //endregion

  var page = 1;
  RxBool isLoading = false.obs;
  RxBool isSubmittedLoading = false.obs;

  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  ScrollController scrollController = ScrollController();

  String formatUtcTimeToLocal(String timeStr) {
    if (timeStr.isEmpty) return '-';

    // Correctly construct a UTC datetime string
    final utcDateTime = DateTime.parse('1970-01-01T${timeStr}Z');

    final localDateTime = utcDateTime.toLocal();
    return DateFormat('hh:mm a').format(localDateTime); // Example: 09:55 AM
  }

  List<ListStudentAttedanceData> listStudentAttedanceDataList = [];

  var isSubmitted = false.obs;
  var isClockOutAllStudent = false.obs;

  listStudentAttedanceApi({var LoadMore}) async {
    if (LoadMore != 1) {
      isLoading.value = true;
      page = 1;
    } else {
      isLoadMoreRunning.value = false;
    }
    String type = '';
    switch (selectedIndex.value) {
      case 0:
        type = 'present';
        break;
      case 1:
        type = 'absent';
        break;
      case 2:
        type = 'out';
        break;
      default:
        type = 'present';
    }
    final queryParams = {
      'page': page.toString(),
      'type': type,
      'date': convertDisplayDateToApiDate(selectedDate),
      if (searchController.text.trim().isNotEmpty) 'search': searchController.text.trim(),


    };
    final uri = Uri.parse(ApiUrl.listStudentAttedance).replace(queryParameters: queryParams);
    final baseUrl = uri.toString();

    log('baseUrl :- $baseUrl');
    return NetworkClient.getInstance.callApi(
      baseUrl: baseUrl,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        ListStudentAttedanceModel getServicesData = ListStudentAttedanceModel.fromJson(response);
        if (getServicesData.status == 1) {
          if (LoadMore != 1) {
            listStudentAttedanceDataList = getServicesData.data!;
            isSubmitted.value = getServicesData.isSubmitted!;
            isClockOutAllStudent.value = getServicesData.isClockoutAllStudent!;
            isLoading.value = false;
            update();
          } else {
            isLoadMoreRunning.value = false;
            if (listStudentAttedanceDataList.isNotEmpty) {
              listStudentAttedanceDataList.addAll(getServicesData.data!);
              isLoading.value = false;
            } else {
              hasNextPage.value = false;
            }
            update();
          }
        } else {
          isLoading.value = false;
        }
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
      await listStudentAttedanceApi(LoadMore: 1);
    }
  }

  String convertDisplayDateToApiDate(String displayDate) {
    try {
      DateTime parsedDate = DateFormat('EEEE, dd MMMM, yyyy').parse(displayDate);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return '';
    }
  }

  submittedAttedanceApi() async {
    isSubmittedLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.submittedAttedance,
      method: MethodType.post,
      params: {'date': convertDisplayDateToApiDate(selectedDate)},
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back();
        } else {
          isSubmittedLoading.value = false;
        }
        isSubmittedLoading.value = false;
      },
      failureCallback: (status, message) {
        isSubmittedLoading.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isSubmittedLoading.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
}
