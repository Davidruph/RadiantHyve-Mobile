import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../model/GetAssignStudentModel.dart';
import '../model/GetShiftModel.dart';

class AssignedStudentController extends GetxController {
  final searchController0 = TextEditingController();
  var staffId, shiftId = '';
  var selectedIndex1 = -1;
  var isLoading = false.obs;
  ScrollController scrollController = ScrollController();

  Timer? _debounce;
  void debounceSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      page = 1;
      getAssignStudentApi();
    });
  }

  @override
  void onInit() {
    if (Get.arguments != null) {
      staffId = Get.arguments['staffId'];
    }
    getShiftApi();
    getAssignStudentApi();
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

  removeFilter() {
    selectedIndex1 = -1;
    shiftId = '';
    Get.back();
    getAssignStudentApi();
  }

  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;
  List<GetAssignStudentData> getAssignStudentDataList = [];

  getAssignStudentApi({var LoadMore}) async {
    if (LoadMore != 1) {
      isLoading.value = true;
      page = 1;
    } else {
      isLoadMoreRunning.value = true;
    }
    final queryParams = {
      'page': page.toString(),
      'staff_id': staffId.toString(),
      if (searchController0.text.trim().isNotEmpty) 'search': searchController0.text.trim(),
      if (shiftId != '') 'shift_id': shiftId.toString(),
    };
    final uri = Uri.parse(ApiUrl.getAssignStudent).replace(queryParameters: queryParams);
    final baseUrl = uri.toString();
    return NetworkClient.getInstance.callApi(
      baseUrl: baseUrl,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        GetAssignStudentModel model = GetAssignStudentModel.fromJson(response);
        if (model.status == 1) {
          final List<GetAssignStudentData>? newData = model.data;
          if (LoadMore != 1) {
            getAssignStudentDataList = newData!;
          } else {
            if (newData != null && newData.isNotEmpty) {
              getAssignStudentDataList.addAll(newData);
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

  Future<void> loadMore() async {
    if (hasNextPage.value &&
        !isLoading.value &&
        !isLoadMoreRunning.value &&
        scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await getAssignStudentApi(LoadMore: 1);
    }
  }

  List<GetShiftData> getShiftDataList = [];

  getShiftApi() async {
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.getShift,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        GetShiftModel model = GetShiftModel.fromJson(response);
        if (model.status == 1) {
          getShiftDataList = model.data!;
        }
        isLoading.value = false;
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
}
