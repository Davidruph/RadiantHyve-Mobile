import 'dart:developer';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/enums.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../chat/views/chat_view.dart';
import '../model/ListUserChatModel.dart';

class ChatListController extends GetxController {
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    listUserChatApi();
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
        listUserChatApi();
        update();
      }
    });
  }
  //endregion

  RxBool isLoading = false.obs;
  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;

  ScrollController scrollController = ScrollController();
  List<ListUserChatData> listUserChatDataList = [];

  listUserChatApi({var loadMore}) async {
    if (loadMore != 1) {
      isLoading.value = true;
      page = 1;
    } else {
      isLoadMoreRunning.value = false;
    }
    final queryParams = {'page': page.toString(), if (searchController.text.trim().isNotEmpty) 'search': searchController.text.trim()};
    final uri = Uri.parse(ApiUrl.listUserChat).replace(queryParameters: queryParams);
    final baseUrl = uri.toString();
    return NetworkClient.getInstance.callApi(
      baseUrl: baseUrl,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        ListUserChatModel model = ListUserChatModel.fromJson(response);
        if (model.status == 1) {
          if (loadMore != 1) {
            listUserChatDataList = model.data!;
            isLoading.value = false;
          } else {
            isLoadMoreRunning.value = false;
            if (listUserChatDataList.isNotEmpty) {
              listUserChatDataList.addAll(model.data!);
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
      await listUserChatApi(loadMore: 1);
    }
  }

  RxBool isChatLoading = false.obs;

  createChatApi({index}) async {
    isChatLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.createChat,
      params: {"chat_to": listUserChatDataList[index].id},
      method: MethodType.post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          final myId = int.tryParse(box.read(PrefsKey.userId).toString());
          final chatBy = response["chat"]["chat_by"];
          final chatTo = response["chat"]["chat_to"];
          log('listUserChatDataList[index].id${listUserChatDataList[index].id}');
          Get.to(
            () => ChatView(),
            arguments: {
              'flag': ChatType.CreateChat,
              'chatId': response["chat"]["id"],
              'profilePic': listUserChatDataList[index].profilePic ?? '',
              'fullName': listUserChatDataList[index].fullName ?? '',
              "otherID": myId == chatBy ? chatTo : chatBy,
            },
          );
        } else {
          isChatLoading.value = false;
        }
      },
      failureCallback: (status, message) {
        isChatLoading.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isChatLoading.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
}
