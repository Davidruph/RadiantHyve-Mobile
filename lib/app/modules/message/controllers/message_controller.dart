import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../commonWidgets/connect_socket.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../groupChat/views/group_chat_view.dart';
import '../model/MessageListModel.dart';

class MessageController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    getPersonalChatsApi();
    countUpdateEmit();
    internetChecker();
    lessonChatCountUpdateEmit();
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
        getPersonalChatsApi();
        update();
      }
    });
  }

  //endregion
  String formatUtcToLocalTime(String utcString) {
    final utcDateTime = DateTime.parse(utcString).toUtc();
    final localDateTime = utcDateTime.toLocal();
    return DateFormat('hh:mm a').format(localDateTime);
  }

  void countUpdateEmit() {
    print("updateCountFunction");
    socket?.on(ApiUrl.countUpdate, (data) async {
      print("COUNT UPDATE EMIT DATA USER ===>> $data");
      GetPersonalChatsData incomingData = GetPersonalChatsData.fromJson(data);
      updateCountMessage(data: incomingData);
    });
  }

  void updateCountMessage({required GetPersonalChatsData data}) {
    int existingIndex = getPersonalChatsDataList.indexWhere((e) => e.id == data.id);
    if (existingIndex != -1) {
      getPersonalChatsDataList[existingIndex].messages?.first.messageText = data.messages?.first.messageText;
      getPersonalChatsDataList[existingIndex].messages?.first.messageType = data.messages?.first.messageType;
      getPersonalChatsDataList[existingIndex].messages?.first.id = data.messages?.first.id;
      getPersonalChatsDataList[existingIndex].createdAt = data.createdAt;
      getPersonalChatsDataList[existingIndex].unreadMessagesCount = data.unreadMessagesCount;
      final updatedItem = getPersonalChatsDataList.removeAt(existingIndex);
      getPersonalChatsDataList.insert(0, updatedItem);
    } else {
      getPersonalChatsDataList.insert(0, data);
    }

    update();
  }

  Future<bool> checkXChatId({required GetPersonalChatsData data}) async {
    for (int i = 0; i < getPersonalChatsDataList.length; i++) {
      if (getPersonalChatsDataList[i].id == data.id) {
        getPersonalChatsDataList[i].messages?.first.messageText = data.messages?.first.messageText;
        getPersonalChatsDataList[i].messages?.first.messageType = data.messages?.first.messageType;
        getPersonalChatsDataList[i].messages?.first.id = data.messages?.first.id;
        getPersonalChatsDataList[i].createdAt = data.createdAt;
        getPersonalChatsDataList[i].unreadMessagesCount = data.unreadMessagesCount;
        GetPersonalChatsData updated = getPersonalChatsDataList.removeAt(i);
        getPersonalChatsDataList.insert(0, updated);

        return true;
      }
    }

    return false;
  }

  var chatCount = 0.obs;

  lessonChatCountUpdateEmit() async {
    print("updateCountFunction");
    log("updateCountFunction");
    socket?.on(ApiUrl.lessonChatCountUpdate, (data) async {
      print("COUNT UPDATE EMIT DATA USER ===>> $data");
      log("COUNT UPDATE EMIT DATA USER ===>> $data");
      chatCount.value = data['unreadMessagesCount'];
      update();
    });
  }

  RxBool isLoading = false.obs;
  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;
  var lessonChatId;
  ScrollController scrollController = ScrollController();
  List<GetPersonalChatsData> getPersonalChatsDataList = [];

  getPersonalChatsApi({var loadMore}) async {
    if (loadMore != 1) {
      isLoading.value = true;
      page = 1;
    } else {
      isLoadMoreRunning.value = false;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: '${ApiUrl.getPersonalChats}/?page=$page',
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        GetPersonalChatsModel model = GetPersonalChatsModel.fromJson(response);
        if (model.status == 1) {
          if (loadMore != 1) {
            getPersonalChatsDataList = model.data!;
            lessonChatId = model.lessonChatId;
            chatCount.value = model.lessonChatUnreadCount;
            isLoading.value = false;
          } else {
            isLoadMoreRunning.value = false;
            if (getPersonalChatsDataList.isNotEmpty) {
              getPersonalChatsDataList.addAll(model.data!);
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
      await getPersonalChatsApi(loadMore: 1);
    }
  }

  createLessonChatApi({index}) async {
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.createLessonChat,
      method: MethodType.post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          final myId = int.tryParse(box.read(PrefsKey.userId).toString());
          final chatBy = response["chat"]["chat_by"];
          final chatTo = response["chat"]["chat_to"];
          final schoolId = response["chat"]["school_id"];

          if (lessonChatId == null) {
            Get.to(
              () => GroupChatView(),
              arguments: {'chatId': response["chat"]["id"], "otherID": myId == chatBy ? chatTo : chatBy, "schoolId": schoolId},
            )?.then((value) {
              chatCount.value = 0;
              update();
            });
          } else {
            Get.to(() => GroupChatView(), arguments: {"schoolId": schoolId})?.then((value) {
              chatCount.value = 0;
              update();
            });
          }
        }
      },
      failureCallback: (status, message) {
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
}
