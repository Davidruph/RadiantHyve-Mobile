import 'dart:developer';
import 'dart:io' show Platform, File;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../commonWidgets/commonPermissionHandler.dart';
import '../../../../commonWidgets/connect_socket.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/customToast.dart';
import '../../../../commonWidgets/enums.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/GetPersonalChatMessageModel.dart';

class ChatController extends GetxController {
  TextEditingController messageController = TextEditingController();
  ChatType chatFlag = ChatType.CreateChat;
  var isImagePick = false.obs;

  var image = ''.obs;
  final ImagePicker mediaPicker = ImagePicker();

  pickMedia({required int argument}) async {
    Permission permission;
    int sdkInt = 36;
    if (Platform.isIOS) {
      permission = argument == 1 ? Permission.camera : Permission.photos;
    } else {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      sdkInt = androidInfo.version.sdkInt;
      if (argument == 1) {
        permission = Permission.camera;
      } else {
        permission = sdkInt <= 32 ? Permission.storage : Permission.photos;
      }
    }
    bool granted = true;
    if (argument == 1) {
      granted = await commonPermissionsHandler(permission: permission);
    } else {
      if (Platform.isAndroid && sdkInt > 32) {
        granted = true;
      } else {
        granted = await commonPermissionsHandler(permission: permission);
      }
    }
    if (granted) {
      final pickedFile = await mediaPicker.pickImage(source: argument == 1 ? ImageSource.camera : ImageSource.gallery);
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final double fileSizeInMB = await imageFile.length() / (1024 * 1024);
        if (fileSizeInMB > 10) return;
        image.value = pickedFile.path ?? '';
        if (pickedFile.path != "") {
          sendMessageApi(type: "Image");
        }
        isImagePick.value = true;
      }
    }
  }


  var profilePic, fullName, chatId, userId, otherID, storeSocketId;

  onWillPopBack() {
    leftRoomCalled();
    if (messageDataList.isNotEmpty) {
      if (chatFlag == ChatType.CreateChat) {
        Get.back(
          result: {
            "lastMessage": messageDataList[0].messageText,
            "lastMessageTime": messageDataList[0].createdAt,
            "messageType": messageDataList[0].messageType,
            "messageChatId": messageDataList[0].chatId,
            "messageId": messageDataList[0].id,
          },
        );
        Get.back(
          result: {
            "lastMessage": messageDataList[0].messageText,
            "lastMessageTime": messageDataList[0].createdAt,
            "messageType": messageDataList[0].messageType,
            "messageChatId": messageDataList[0].chatId,
            "messageId": messageDataList[0].id,
          },
        );
      } else {
        log("Hello 11");
        Get.back(
          result: {
            "lastMessage": messageDataList[0].messageText,
            "lastMessageTime": messageDataList[0].createdAt,
            "messageType": messageDataList[0].messageType,
            "messageChatId": messageDataList[0].chatId,
            "messageId": messageDataList[0].id,
          },
        );
      }
    } else {
      if (chatFlag == ChatType.CreateChat) {
        Get.back(result: 1);
        Get.back(result: 1);
      } else {
        Get.back(result: 1);
      }
    }
  }

  @override
  void onInit() {
    storeSocketId = box.read(PrefsKey.socketId);
    if (Get.arguments != null) {
      chatFlag = Get.arguments['flag'];
      otherID = Get.arguments["otherID"];
      profilePic = Get.arguments['profilePic'] ?? '';
      fullName = Get.arguments['fullName'] ?? '';
      chatId = Get.arguments['chatId'];
    }

    if (box.read(PrefsKey.userId) != null) {
      userId = box.read(PrefsKey.userId);
    }

    scrollController = ScrollController()..addListener(loadMore);
    getChatMessageApi();
    joinRoomCalled();
    NewMessage();
    super.onInit();
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
        getChatMessageApi();
        update();
      }
    });
  }

  //endregion

  joinRoomCalled() {
    print('joinRoomCalled');
    socket?.emit(ApiUrl.joinRoom, {'user_id': box.read(PrefsKey.userId), 'chat_id': chatId});
  }

  leftRoomCalled() {
    socket?.emit(ApiUrl.leftRoom, {'user_id': box.read(PrefsKey.userId), 'chat_id': chatId});
    print('leftRoomCalled');
  }

  NewMessage() async {
    socket?.on('${ApiUrl.newMessage}', (data) {
      print("<------newMessage-----> $data");
      GetPersonalChatMessageData chatData = GetPersonalChatMessageData.fromJson(data);
      messageDataList.insert(0, chatData);
      update();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var percentage = 0.0.obs;
  RxBool isSendMessageLoading = false.obs;
  double currentPosition = 0.0;
  var scroll = false.obs;
  var expanded = false.obs;
  ScrollController scrollController = ScrollController();
  var isChatLoading = false.obs;
  var page = 1, hasNextPage = true.obs, isLoadMoreRunning = false.obs;
  List<GetPersonalChatMessageData> messageDataList = [];

  getChatMessageApi({var loadMore}) async {
    if (loadMore != 1) {
      isChatLoading.value = true;
      update();
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.getPersonalChatMessage}?page=$page&chat_id=$chatId",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) {
        GetPersonalChatMessageModel model = GetPersonalChatMessageModel.fromJson(response);
        log('response--------------->${response}');
        if (model.status == 1) {
          if (loadMore != 1) {
            messageDataList = model.data ?? [];
            isChatLoading.value = false;
            update();
          } else {
            isLoadMoreRunning.value = false;
            if (model.data!.isNotEmpty) {
              messageDataList.addAll(model.data!);
              isChatLoading.value = false;
            } else {
              hasNextPage.value = false;
            }
            update();
          }
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

  Future<dynamic> loadMore() async {
    currentPosition = scrollController.position.pixels;
    if (currentPosition == 0.0) {
      scroll.value = false;
    } else if (currentPosition != 0.0) {
      scroll.value = true;
    }
    if (hasNextPage.value == true &&
        isChatLoading.value == false &&
        isLoadMoreRunning.value == false &&
        scrollController.offset >= scrollController.position.maxScrollExtent - 2000) {
      isLoadMoreRunning.value = true;
      page++;
      await getChatMessageApi(loadMore: 1);
    }
  }

  Future<void> sendMessageApi({required String type, message}) async {
    scrollController.animateTo(scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 800), curve: Curves.linear);
    if (storeSocketId != socketID) {
      await joinRoomCalled();
    }
    if (type == 'Image') {
      isSendMessageLoading.value = true;
      percentage.value = 0.01;
    }
    isSendMessageLoading.value = true;
    log({'other_id': otherID, 'chat_id': chatId, 'message_type': type}.toString());
    var data =
        type == "Text"
            ? FormData.fromMap({
              if (image.value != '')
                'media': await MultipartFile.fromFile(image.value, filename: image.toString().split('/').last.toString().split('\'').first),
              'other_id': otherID,
              'chat_id': chatId,
              'message_text': message,
              'message_type': '["Text"]',
            })
            : type == "Image"
            ? FormData.fromMap({
              if (image.value != '')
                'media': await MultipartFile.fromFile(image.value, filename: image.toString().split('/').last.toString().split('\'').first),
              'other_id': otherID,
              'chat_id': chatId,
              'message_type': '["Image"]',
            })
            : '';
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.sendPersonalChatMessage,
      params: data,
      method: MethodType.post,
      successCallback: (response, message) async {
        isSendMessageLoading.value = false;
        if (response['status'] == 1) {
          messageController.clear();
          update();
        }
      },
      failureCallback: (status, message) {
        isSendMessageLoading.value = false;
        update();
      },
      timeOutCallback: () {
        isSendMessageLoading.value = false;
        update();
        showCustomToast(message: 'You\'re offline! Check your internet connection.', backgroundColor: Colors.red, isError: true);
      },
    );
  }

  RxBool isLoading = false.obs;

  clearChatApi() async {
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.clearChat}?chat_id=$chatId",
      method: MethodType.delete,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back();
          getChatMessageApi();
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

  String formattedDate(String createdAt) {
    try {
      DateTime dateTime = DateTime.parse(createdAt).toLocal();

      final DateTime now = DateTime.now();
      final DateTime yesterday = now.subtract(const Duration(days: 1));

      if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
        return 'Today, ${DateFormat('d MMMM').format(dateTime)}';
      } else if (dateTime.year == yesterday.year && dateTime.month == yesterday.month && dateTime.day == yesterday.day) {
        return 'Yesterday, ${DateFormat('d MMMM').format(dateTime)}';
      } else {
        return DateFormat('d MMMM, y').format(dateTime);
      }
    } catch (e) {
      return 'Invalid date';
    }
  }
}
