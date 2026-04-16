import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/GetShiftModel.dart';
import '../model/ListStudentTeacherModel.dart';

class ClassroomDataController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  var shiftId = '';
  removeFilter() {
    selectedIndex1 = -1;
    shiftId = '';
    Get.back();
    listStudentTeacherApi();
  }

  @override
  void onInit() {
    listStudentTeacherApi();
    getShiftApi();
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

  var selectedIndex1 = -1;
  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;
  RxBool isLoading = false.obs;
  ScrollController scrollController = ScrollController();
  List<ListStudentTeacherData> listStudentTeacherDataList = [];

  listStudentTeacherApi({var LoadMore}) async {
    if (LoadMore != 1) {
      isLoading.value = true;
      page = 1;
    } else {
      isLoadMoreRunning.value = false;
    }
    final queryParams = {
      'page': page.toString(),
      if (searchController.text.trim().isNotEmpty) 'search': searchController.text.trim(),
      if (shiftId != '') 'shift_id': shiftId.toString(),
    };
    final uri = Uri.parse(ApiUrl.listStudentTeacher).replace(queryParameters: queryParams);
    final baseUrl = uri.toString();
    return NetworkClient.getInstance.callApi(
      baseUrl: baseUrl,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        ListStudentTeacherModel listStudentTeacherModel = ListStudentTeacherModel.fromJson(response);
        if (listStudentTeacherModel.status == 1) {
          if (LoadMore != 1) {
            listStudentTeacherDataList = listStudentTeacherModel.liststudentteacherdata!;
            isLoading.value = false;
          } else {
            isLoadMoreRunning.value = false;
            if (listStudentTeacherDataList.isNotEmpty) {
              listStudentTeacherDataList.addAll(listStudentTeacherModel.liststudentteacherdata!);
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
      await listStudentTeacherApi(LoadMore: 1);
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
