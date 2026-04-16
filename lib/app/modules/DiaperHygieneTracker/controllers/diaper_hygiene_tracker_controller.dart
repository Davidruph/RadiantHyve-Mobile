import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../Model/ListDiaperAndBathModel.dart';

class DiaperHygieneTrackerController extends GetxController {
  // Get current time string

  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
    listDiaperAndBathData.clear();
    listDiaperAndBathApi();
  }

  @override
  void onInit() {
    super.onInit();
    listDiaperAndBathApi();
    internetChecker();
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;
  RxBool isLoading = false.obs;
  ScrollController scrollController = ScrollController();
  List<ListDiaperAndBathData> listDiaperAndBathData = [];

  listDiaperAndBathApi({var LoadMore}) async {
    if (LoadMore != 1) {
      isLoading.value = true;
      page = 1;
    } else {
      isLoadMoreRunning.value = false;
    }
    String baseUrl = "${ApiUrl.listDiaperAndBath}?page=$page&type=${selectedIndex.value == 0 ? 'diaper' : 'bath'}";

    return NetworkClient.getInstance.callApi(
      baseUrl: baseUrl,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        print('response :- $response');
        ListDiaperAndBathModel model = ListDiaperAndBathModel.fromJson(response);
        if (model.status == 1) {
          if (LoadMore != 1) {
            listDiaperAndBathData = model.data!;
            isLoading.value = false;
          } else {
            isLoadMoreRunning.value = false;
            if (listDiaperAndBathData.isNotEmpty) {
              listDiaperAndBathData.addAll(model.data!);
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
      await listDiaperAndBathApi(LoadMore: 1);
    }
  }

  var internetCheckerSubscription;
  bool isDeviceConnected = true;

  Future<void> internetChecker() async {
    internetCheckerSubscription = Connectivity().onConnectivityChanged.listen((result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected) {
        isLoading.value = true;
        update();
      } else {
        listDiaperAndBathApi();
        update();
      }
    });
  }
}
