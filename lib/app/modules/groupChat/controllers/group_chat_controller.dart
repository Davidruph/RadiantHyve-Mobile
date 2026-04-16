import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../commonWidgets/commonPermissionHandler.dart';
import '../../../../commonWidgets/connect_socket.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/GetLessonChatMessageModel.dart';

class GroupChatController extends GetxController {
  TextEditingController messageController = TextEditingController();

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

  var uploadedFiles1;
  String? filePath;
  String? fileName;

  pickFiles() async {
    var files = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'doc', 'jpg', 'jpeg', 'png', 'bmp'],
      type: FileType.custom,
      allowMultiple: false,
    );

    if (files != null) {
      filePath = files.files.first.path!;
      fileName = files.files.first.name;
      print('fileName---------> $fileName');
      sendMessageApi(type: "Document");
      update();
    }
  }

  removeFile() {
    uploadedFiles1 = null;
    update();
  }

  var chatId, userId, storeSocketId, schoolId;

  Future<void> downloadAttendanceSheet(String url, String fileName) async {
    try {
      String saveDir = await FileStorage._localPath;
      String savePath = '$saveDir/$fileName';

      Dio dio = Dio();
      await dio.download(url, savePath);

      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text('PDF downloaded and saved at: $savePath')));
      }

      print("PDF downloaded and saved at: $savePath");
    } catch (e) {
      print("Failed to download PDF: $e");
    }
  }

  @override
  void onInit() {
    if (Get.arguments != null) {
      // otherID = Get.arguments["otherID"];
      chatId = Get.arguments['chatId'];
      schoolId = Get.arguments['schoolId'];
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

  onWillPop() {
    leftRoomCalled();
    Get.back(result: 1);
  }

  joinRoomCalled() {
    print('Ashish Malani');
    socket?.emit(ApiUrl.joinGroup, {'user_id': box.read(PrefsKey.userId), 'school_id': schoolId});
  }

  leftRoomCalled() {
    socket?.emit(ApiUrl.leftGroup, {'user_id': box.read(PrefsKey.userId), 'school_id': schoolId});
  }

  NewMessage() async {
    socket?.on('${ApiUrl.newLessonChatMessage}', (data) {
      print("<------newMessage-----> $data");
      GetLessonChatMessageData chatData = GetLessonChatMessageData.fromJson(data);
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
  List<GetLessonChatMessageData> messageDataList = [];

  getChatMessageApi({var loadMore}) async {
    print('chatId====<$chatId');
    if (loadMore != 1) {
      isChatLoading.value = true;
      update();
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.getLessonChatMessage}?page=$page",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) {
        GetLessonChatMessageModel model = GetLessonChatMessageModel.fromJson(response);
        log('response--------------->${response}');
        if (model.status == 1) {
          if (loadMore != 1) {
            messageDataList = model.getlessonchatmessagedata ?? [];
            isChatLoading.value = false;
            update();
          } else {
            isLoadMoreRunning.value = false;
            if (model.getlessonchatmessagedata!.isNotEmpty) {
              messageDataList.addAll(model.getlessonchatmessagedata!);
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
      // leftRoomCalled();
      await joinRoomCalled();
    }
    if (type == 'Image') {
      isSendMessageLoading.value = true;
      percentage.value = 0.01;
    }
    isSendMessageLoading.value = true;
    log({'chat_id': chatId, 'message_type': type}.toString());
    var data =
        type == "Text"
            ? FormData.fromMap({
              if (image.value != '')
                'media': await MultipartFile.fromFile(image.value, filename: image.toString().split('/').last.toString().split('\'').first),
              'chat_id': chatId,
              'message_text': message,
              'message_type': '["Text"]',
            })
            : type == "Image"
            ? FormData.fromMap({
              if (image.value != '')
                'media': await MultipartFile.fromFile(image.value, filename: image.toString().split('/').last.toString().split('\'').first),
              'chat_id': chatId,
              'message_type': '["Image"]',
            })
            : type == "Document"
            ? FormData.fromMap({
              if (filePath != null)
                'media': await MultipartFile.fromFile(filePath!, filename: filePath.toString().split('/').last.toString().split('\'').first),
              'chat_id': chatId,
              'message_type': '["Document"]',
              'file_name': '["$fileName"]',
            })
            : '';
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.sendLessonChatMessage,
      params: data,
      method: MethodType.post,
      successCallback: (response, message) async {
        log('response--------<$response');
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

class UploadedFile {
  final String fileName;
  final String filePath;

  UploadedFile({required this.fileName, required this.filePath});
}

class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    var status = await Permission.storage.status;
    print("permission status");
    print(status);
    await Permission.storage.request();
    if (!status.isGranted) {}
    Directory _directory = Directory("dir");
    if (Platform.isAndroid) {
      _directory = Directory("/storage/emulated/0/Download/RadiantHyve-Teachers");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }
    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }
}
