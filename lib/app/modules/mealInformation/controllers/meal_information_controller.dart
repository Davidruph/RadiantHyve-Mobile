import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/GetMenuModel.dart';

class MealInformationController extends GetxController {
  var menuId;
  List weeklyScheduleList = [
    {'day': 'Mon', 'isSelect': true},
    {'day': 'Tue', 'isSelect': false},
    {'day': 'Wed', 'isSelect': true},
    {'day': 'Thu', 'isSelect': false},
    {'day': 'Fri', 'isSelect': true},
    {'day': 'Sat', 'isSelect': false},
    {'day': 'Sun', 'isSelect': false},
  ];

  var isLoading = false.obs;
  var isDeleteLoading = false.obs;
  var allStudent = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      allStudent = Get.arguments['allStudent'] ?? false;
      menuId = Get.arguments['menuId'] ?? 0;
      log("menuId====> $menuId");
    }
    getMenuApi();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String formatDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String formatTime(String inputTime) {
    DateTime time = DateFormat("HH:mm:ss").parse(inputTime);
    return DateFormat("hh:mm a").format(time);
  }

  GetMenuData? getMenuData;

  getMenuApi() async {
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.getMenu}/?menu_id=$menuId",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        GetMenuModel getMenuModel = GetMenuModel.fromJson(response);
        if (getMenuModel.status == 1) {
          getMenuData = getMenuModel.data!;
          final apiDaySet = getMenuData?.menuDay?.map((e) => e.menuDay?.toLowerCase() ?? '').toSet() ?? {};
          weeklyScheduleList =
              weeklyScheduleList.map((item) {
                final day = item['day'].toString().toLowerCase();
                return {'day': item['day'], 'isSelect': apiDaySet.contains(day)};
              }).toList();
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

  deleteMenuApi() async {
    isDeleteLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.deleteMenu}/?menu_id=$menuId",
      method: MethodType.delete,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back(result: 1);
          Get.back(result: 1);
        } else {
          isDeleteLoading.value = false;
        }
        isDeleteLoading.value = false;
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
        isDeleteLoading.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
}
