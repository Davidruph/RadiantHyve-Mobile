import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/ListStudentsInvoiceModel.dart';

class PaidFeeDetailsController extends GetxController {
  var studentId = 0;

  List paidFeesDetailList = [
    {'amount': '\$199.00', 'transactionId': '1234ABCD5678', 'date': '28/10/2024'},
    {'amount': '\$199.00', 'transactionId': '1234ABCD5678', 'date': '27/09/2024'},
    {'amount': '\$199.00', 'transactionId': '1234ABCD5678', 'date': '29/08/2024'},
  ];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      studentId = Get.arguments['studentId'] ?? studentId;
      log('studentId==============$studentId');
      listStudentsInvoiceAPI();
    }

    scrollController.addListener(ListStudentsInvoiceLoadMore);
    internetChecker();
  }

  @override
  void onReady() {
    super.onReady();
  }


  @override
  void onClose() {
    if (internetCheckerSubscription != null) {
      internetCheckerSubscription.cancel();
    }
    super.onClose();
  }
  var isLoadMoreRunning = false.obs;
  var page = 1, hasNextPage = true.obs;
  String formatDate(String apiDate) {
    DateTime parsedDate = DateTime.parse(apiDate);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }
  ScrollController scrollController = ScrollController();
  List<ListStudentsInvoiceData> listStudentsInvoiceDataList = [];
  listStudentsInvoiceAPI({int isLoadMore = 0}) async {
    if (isLoadMore == 1) {
      isLoadMoreRunning.value = true;
    } else {
      page = 1;
      isLoading.value = true;
      isLoadMoreRunning.value = false;
      hasNextPage.value = true;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.listStudentsInvoice}?page=$page&student_id=$studentId",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        log('response----------------> $response');
        ListStudentsInvoiceModel responseData = ListStudentsInvoiceModel.fromJson(response);
        if (isLoadMore != 1) {
          if (responseData.data != null) {
            listStudentsInvoiceDataList = responseData.data ?? [];
          }
        } else {
          if (responseData.data!.isNotEmpty) {
            listStudentsInvoiceDataList.addAll(responseData.data ?? []);
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

  Future<void> ListStudentsInvoiceLoadMore() async {
    if (hasNextPage.value &&
        !isLoading.value &&
        !isLoadMoreRunning.value &&
        scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await listStudentsInvoiceAPI(isLoadMore: 1);
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
        listStudentsInvoiceAPI();
        update();
      }
    });
  }
}
