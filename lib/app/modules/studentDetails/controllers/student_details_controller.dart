import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../commonWidgets/commonPermissionHandler.dart';
import '../../../../commonWidgets/enums.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../chat/views/chat_view.dart';
import '../model/StudentDetailsModel.dart';

class StudentDetailsController extends GetxController {
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
      if (sdkInt <= 32) {
        granted = await commonPermissionsHandler(permission: permission);
      } else {
        granted = true;
      }
    }
    if (granted) {
      final pickedFile = await mediaPicker.pickImage(source: argument == 1 ? ImageSource.camera : ImageSource.gallery);
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final double fileSizeInMB = await imageFile.length() / (1024 * 1024);
        if (!_isImageFile(pickedFile.path)) return;
        if (fileSizeInMB > 10) return;
        image.value = pickedFile.path ?? '';
        editAccountApi();
        update();
      }
    }
  }

  bool _isImageFile(String filePath) {
    return filePath.toLowerCase().endsWith('.jpg') || filePath.toLowerCase().endsWith('.jpeg') || filePath.toLowerCase().endsWith('.png');
  }

  var isLoading = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      studentId = Get.arguments['studentId'];
      log('studentId====>${studentId}');
    }
    studentDetailsApi();
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

  String formatDate(String apiDate) {
    DateTime parsedDate = DateTime.parse(apiDate);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  var studentId;
  StudentDetailsData? studentDetailsData;

  studentDetailsApi({flag}) async {
    if (flag != 0) {
      isLoading.value = true;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.studentDetails}/?student_id=$studentId",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        StudentDetailsModel getMenuModel = StudentDetailsModel.fromJson(response);
        if (getMenuModel.status == 1) {
          studentDetailsData = getMenuModel.data!;
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

  RxBool isChatLoading = false.obs;

  createChatApi() async {
    isChatLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.createChat,
      params: {"chat_to": studentDetailsData?.studentParent?.id},
      method: MethodType.post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.to(
            () => ChatView(),
            arguments: {
              'flag': ChatType.StudentDetails,
              'chatId': response["chat"]["id"],
              'profilePic': studentDetailsData?.studentParent?.profilePic,
              'fullName': studentDetailsData?.studentParent?.fullName,
              "otherID": studentDetailsData?.studentParent?.id,
            },
          );
        }
        isChatLoading.value = false;
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

  RxBool isEditLoading = false.obs;

  editAccountApi() async {
    Map<String, dynamic> finalJson = {
      'profile_pic': await MultipartFile.fromFile(image.value, filename: image.split('/').last),
      "student_id": studentId,
    };
    isEditLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.editStudentProfilePic,
      method: MethodType.put,
      params: FormData.fromMap(finalJson),
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        StudentDetailsModel getMenuModel = StudentDetailsModel.fromJson(response);
        if (getMenuModel.status == 1) {
          image = getMenuModel.data!.profilePic!;
          studentDetailsApi(flag: 0);
        } else {
          isEditLoading.value = false;
        }
        isEditLoading.value = false;
        update();
      },
      failureCallback: (status, message) {
        isEditLoading.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isEditLoading.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
}
