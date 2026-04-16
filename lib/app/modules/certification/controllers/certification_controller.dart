import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../model/CertificateListModel.dart';

class CertificationController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<CertificateListData> certificationList = [];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    internetChecker();
    listCertification();
    scrollController.addListener(listCertificationLoadMore);
    // isLoading.value = true;
    // Future.delayed(const Duration(seconds: 1), () {
    //   isLoading.value = false;
    //   update();
    // });
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

  //region list Certification API
  var isLoadMoreRunning = false.obs;
  var page = 1, hasNextPage = true.obs;
  ScrollController scrollController = ScrollController();

  listCertification({int isLoadMore = 0}) async {
    if (isLoadMore == 1) {
      isLoadMoreRunning.value = true;
    } else {
      page = 1;
      isLoading.value = true;
      isLoadMoreRunning.value = false;
      hasNextPage.value = true;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.listCertification}?page=$page",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        CertificateListModel responseData = CertificateListModel.fromJson(response);

        if (isLoadMore != 1) {
          if (responseData.certificateListDataData != null) {
            certificationList = responseData.certificateListDataData ?? [];
          }
        } else {
          if (responseData.certificateListDataData!.isNotEmpty) {
            certificationList.addAll(responseData.certificateListDataData ?? []);
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
        listCertification();
        update();
      }
    });
  }
  //endregion

  //region List Certification LoadMore Function
  Future<void> listCertificationLoadMore() async {
    if (hasNextPage.value &&
        !isLoading.value &&
        !isLoadMoreRunning.value &&
        scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await listCertification(isLoadMore: 1);
    }
  }
  //endregion
}
