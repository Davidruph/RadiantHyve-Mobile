import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:radianthyve_unified/app/modules/notifications/model/ListNotificationModel.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';

class NotificationsController extends GetxController {
  var page = 1, hasNextPage = true.obs, isLoadMoreRunning = false.obs;
  ScrollController scrollController = ScrollController();
  var isLoading = false.obs;

  @override
  void onInit() {
    scrollController = ScrollController()..addListener(loadMore);
    listNotificationApi();
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


  String formatToRelativeDate(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(const Duration(days: 1));

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMMM, yyyy').format(date);
    }
  }

  String getTimeDifference(String apiCreatedAt) {
    final DateTime createdAt = DateTime.parse(apiCreatedAt);
    final currentTime = DateTime.now();
    final timeDifference = currentTime.difference(createdAt);

    if (timeDifference.inSeconds < 60) {
      return '${timeDifference.inSeconds} seconds ago';
    } else if (timeDifference.inMinutes < 60) {
      return '${timeDifference.inMinutes} minutes ago';
    } else if (timeDifference.inHours < 24) {
      return '${timeDifference.inHours} hours ago';
    } else if (timeDifference.inDays < 30) {
      return '${timeDifference.inDays} days ago';
    } else if (timeDifference.inDays < 365) {
      final months = (timeDifference.inDays / 30).floor();
      return '$months months ago';
    } else {
      final years = (timeDifference.inDays / 365).floor();
      return '$years years ago';
    }
  }

  List<ListNotificationData> sortNotifications(List<ListNotificationData> notifications) {
    notifications.sort((a, b) {
      DateTime dateA = DateTime.parse(a.createdAt!);
      DateTime dateB = DateTime.parse(b.createdAt!);
      String formattedDateA = formatToRelativeDate(dateA);
      String formattedDateB = formatToRelativeDate(dateB);

      if (formattedDateA == 'Today' && formattedDateB != 'Today') return -1;
      if (formattedDateB == 'Today' && formattedDateA != 'Today') return 1;
      if (formattedDateA == 'Yesterday' && formattedDateB != 'Yesterday') return -1;
      if (formattedDateB == 'Yesterday' && formattedDateA != 'Yesterday') return 1;

      return dateB.compareTo(dateA);
    });
    return notifications;
  }

  String convertUtcToLocal(String utcTime) {
    DateTime utcDate = DateTime.parse(utcTime);
    DateTime localDate = utcDate.toLocal();

    String formattedDate = DateFormat('dd MMMM yyyy').format(localDate);
    String formattedTime = DateFormat('hh:mm a').format(localDate);

    return '$formattedDate at $formattedTime';
  }

  ListNotificationModel listNotificationModel = ListNotificationModel();

  List<ListNotificationData> listNotification = [];

  listNotificationApi({var LoadMore}) async {
    if (LoadMore != 1) {
      isLoading.value = true;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.listNotification}/?page=$page",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        listNotificationModel = ListNotificationModel.fromJson(response);
        log('response------------->${response}');
        if (LoadMore != 1) {
          listNotification = listNotificationModel.notificationdata!;
          isLoading.value = false;
          update();
        } else {
          isLoadMoreRunning.value = false;
          if (listNotificationModel.notificationdata!.isNotEmpty) {
            listNotification.addAll(listNotificationModel.notificationdata!);
            isLoading.value = false;
          } else {
            hasNextPage.value = false;
          }

          update();
        }
        isLoading.value = false;
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
      await listNotificationApi(LoadMore: 1);
    }
  }


}
