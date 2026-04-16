import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/ListMenuStudentModel.dart';

class MealTrackingController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List mealTracking = [
    {'mealType': 'Morning Snack', 'student': 'Dianne Howard', 'date': '28/10/2024', 'time': '09:30 AM'},
    {'mealType': 'Lunch', 'student': 'All Student', 'date': '28/10/2024', 'time': '12:30 PM'},
  ];

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

  String formatDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String formatTime(String inputTime) {
    DateTime time = DateFormat("HH:mm:ss").parse(inputTime);
    return DateFormat("hh:mm a").format(time);
  }

  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;
  RxBool isLoading = false.obs;
  ScrollController scrollController = ScrollController();
  List<ListMenuStudentData> menuStudentDataList = [];

  listMenuStudentApi({var LoadMore}) async {
    if (LoadMore != 1) {
      isLoading.value = true;
      page = 1;
    } else {
      isLoadMoreRunning.value = false;
    }

    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.listMenuStudent}/?page=$page",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        ListMenuStudentModel menuStudentModel = ListMenuStudentModel.fromJson(response);
        if (menuStudentModel.status == 1) {
          if (LoadMore != 1) {
            menuStudentDataList = menuStudentModel.data!;
            isLoading.value = false;
            update();
          } else {
            isLoadMoreRunning.value = false;
            if (menuStudentDataList.length > 0) {
              menuStudentDataList.addAll(menuStudentModel.data!);
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
    if (hasNextPage.value == true && isLoading.value == false && isLoadMoreRunning.value == false && scrollController.offset >= scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await listMenuStudentApi(LoadMore: 1);
    }
  }
}
