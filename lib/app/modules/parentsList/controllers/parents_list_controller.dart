import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../model/listParentModel.dart';

class ParentsListController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();

  List<ParentModelData> parentsList = [];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(ListParentLoadMore);
    listParentAPI();
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
  }

  //region List staff api
  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;
  ScrollController scrollController = ScrollController();

  listParentAPI({int isLoadMore = 0}) async {
    if (isLoadMore == 1) {
      isLoadMoreRunning.value = true;
    } else {
      page = 1;
      isLoading.value = true;
      isLoadMoreRunning.value = false;
      hasNextPage.value = true;
    }
    log("pageNo----->${page}");
    return NetworkClient.getInstance.callApi(
      baseUrl: searchController.text.isEmpty ? "${ApiUrl.listParent}?page=$page" : "${ApiUrl.listParent}?page=$page&search=${searchController.text}",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        listParentModel responseData = listParentModel.fromJson(response);

        if (isLoadMore != 1) {
          if (responseData.parentsData != null) {
            parentsList = responseData.parentsData ?? [];
          }
        } else {
          if (responseData.parentsData!.isNotEmpty) {
            parentsList.addAll(responseData.parentsData ?? []);
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

  //region List Parent LoadMore Function
  Future<void> ListParentLoadMore() async {
    if (hasNextPage.value &&
        !isLoading.value &&
        !isLoadMoreRunning.value &&
        scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await listParentAPI(isLoadMore: 1);
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
        listParentAPI();
        update();
      }
    });
  }
  //endregion
}
