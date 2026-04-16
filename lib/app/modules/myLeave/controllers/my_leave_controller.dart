import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/ListLeaveTeacherModel.dart';

class MyLeaveController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<int> selectedMonthIndexes = [];

  List<Map<String, String>> getPastMonthsOfCurrentYearList() {
    List<Map<String, String>> allMonths = [
      {'month': AppMessage.January},
      {'month': AppMessage.February},
      {'month': AppMessage.March},
      {'month': AppMessage.April},
      {'month': AppMessage.May},
      {'month': AppMessage.June},
      {'month': AppMessage.July},
      {'month': AppMessage.August},
      {'month': AppMessage.September},
      {'month': AppMessage.October},
      {'month': AppMessage.November},
      {'month': AppMessage.December},
    ];
    return allMonths;
  }

  List<String> selectedMonths = [];
  List<ListLeaveTeacherData> allLeaves = [];
  List<ListLeaveTeacherData> filteredLeaves = [];

  void onApplyFilterButtonPressed() {
    if (selectedMonths.isEmpty || selectedMonths.contains("This Month")) {
      final currentMonth = DateFormat.MMMM().format(DateTime.now());
      filteredLeaves =
          allLeaves.where((leave) {
            final leaveMonth = DateFormat.MMMM().format(leave.date);
            return leaveMonth == currentMonth;
          }).toList();
    } else {
      filteredLeaves =
          allLeaves.where((leave) {
            final leaveMonth = DateFormat.MMMM().format(leave.date);
            return selectedMonths.contains(leaveMonth);
          }).toList();
    }
    update();
  }

  void applyMonthYearFilter({required List<String> selectedMonthNames, required String selectedYearValue}) {
    const monthMap = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };
    selectedMonthIndexes.clear();
    for (var month in selectedMonthNames) {
      if (monthMap.containsKey(month)) {
        selectedMonthIndexes.add(monthMap[month]!);
      }
    }
    selectedYear = selectedYearValue;
    update();
  }

  List<int> selectedIndexes = [];
  var isLoading = false.obs;

  @override
  void onInit() {
    listLeaveTeacherApi();
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
        listLeaveTeacherApi();
        update();
      }
    });
  }

  //endregion
  List<ListLeaveTeacherData> listLeaveTeacherDataList = [];

  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;
  ScrollController scrollController = ScrollController();
  String? selectedMonth;
  int? selectedMonthIndex;
  String selectedYear = DateTime.now().year.toString();

  listLeaveTeacherApi({var LoadMore, isLoadingValue}) async {
    if (LoadMore != 1) {
      if (isLoadingValue != false) {
        isLoading.value = true;
      }
      page = 1;
    } else {
      isLoadMoreRunning.value = false;
    }

    String monthParam = selectedMonthIndexes.isNotEmpty ? "&month=${selectedMonthIndexes.join(',')}" : "";
    String yearParam = selectedMonthIndexes.isNotEmpty ? "&year=$selectedYear" : "";
    String baseUrl = "${ApiUrl.listLeaveTeacher}?page=$page$monthParam$yearParam";

    return NetworkClient.getInstance.callApi(
      baseUrl: baseUrl,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        ListLeaveTeacherModel model = ListLeaveTeacherModel.fromJson(response);
        if (model.status == 1) {
          if (LoadMore != 1) {
            listLeaveTeacherDataList = model.data!;
            isLoading.value = false;
          } else {
            isLoadMoreRunning.value = false;
            if (model.data!.isNotEmpty) {
              listLeaveTeacherDataList.addAll(model.data!);
              isLoading.value = false;
            } else {
              hasNextPage.value = false;
            }
          }
        } else {
          hasNextPage.value = false;
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

  Future<dynamic> loadMore() async {
    if (hasNextPage.value == true &&
        isLoading.value == false &&
        isLoadMoreRunning.value == false &&
        scrollController.offset >= scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await listLeaveTeacherApi(LoadMore: 1);
    }
  }

  RxBool isCancelLeaveLoading = false.obs;

  cancelLeaveApi({index}) async {
    isCancelLeaveLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.cancelLeave,
      params: {'leave_id': listLeaveTeacherDataList[index].id},
      method: MethodType.post,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          listLeaveTeacherApi();
          toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
        } else {
          isCancelLeaveLoading.value = false;
        }
        isCancelLeaveLoading.value = false;
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
        isCancelLeaveLoading.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
}
