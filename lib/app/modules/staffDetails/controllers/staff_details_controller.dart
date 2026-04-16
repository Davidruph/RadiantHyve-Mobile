import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radianthyve_unified/utils/prefsKey.dart';
import '../../../../commonWidgets/commonPermissionHandler.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/enums.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../chat/views/chat_view.dart';
import '../model/StaffDetailsModel.dart';

class StaffDetailsController extends GetxController {
  TextEditingController deleteReason = TextEditingController();
  var errorDelete = ''.obs, isSelect = 0.obs;

  TextEditingController blockReason = TextEditingController();

  var flag, isLoading = false.obs;
  var isBlockLoading = false.obs;

  StaffDetailsData? staffDetailsData;

  RxInt staffId = 0.obs;

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
        if (!_isImageFile(pickedFile.path)) return;
        if (fileSizeInMB > 10) return;
        image.value = pickedFile.path ?? '';
        changeProfileApi(image: image);
        update();
      }
    }
  }

  bool _isImageFile(String filePath) {
    return filePath.toLowerCase().endsWith('.jpg') || filePath.toLowerCase().endsWith('.jpeg') || filePath.toLowerCase().endsWith('.png');
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      staffId.value = Get.arguments["staff_id"];
      flag = Get.arguments['flag'];
    }
    internetChecker();
    getStaffDetailsApi();
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
        getStaffDetailsApi();
        update();
      }
    });
  }

  //endregion

  //region Get staff details api
  getStaffDetailsApi() async {
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.getStaff}?staff_id=${staffId.value}",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        StaffDetailsModel data = StaffDetailsModel.fromJson(response);
        if (data.status == 1) {
          staffDetailsData = data.staffDetailsData;
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

  //endregion

  //region Change profile Api
  changeProfileApi({image}) async {
    Map<String, dynamic> params = {"staff_id": staffId};
    params['profile_pic'] = await MultipartFile.fromFile(image, filename: image.split("/").last);

    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.editStaff,
      method: MethodType.put,
      params: FormData.fromMap(params),
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
        staffDetailsData?.profilePic = response["data"]["profile_pic"];
        update();
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

  //endregion

  //region Block Staff Api
  blockStaffApi({status}) async {
    Map<String, dynamic> params = {"staff_id": staffId.value, "block_reason": blockReason.text};
    isBlockLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.blockStaff,
      method: MethodType.post,
      params: params,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        if (status == "Block") {
          Get.back(result: 1);
          Get.back(result: 1);
          Get.back(result: 1);
        } else {
          getStaffDetailsApi();
        }
        toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
        isBlockLoading.value = false;
        update();
      },
      failureCallback: (status, message) {
        isBlockLoading.value = false;
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

  //endregion

  //region Delete Staff Api
  deleteStaffApi() async {
    isBlockLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.deleteStaff}?staff_id=${staffId.value}&delete_reason=${deleteReason.text}",
      method: MethodType.delete,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        Get.back(result: 1);
        Get.back(result: 1);
        Get.back(result: 1);
        toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
        isBlockLoading.value = false;
        update();
      },
      failureCallback: (status, message) {
        isBlockLoading.value = false;
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

  //endregion

  //region Create Chat API
  RxBool isChatLoading = false.obs;

  createChatApi() async {
    isChatLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.createChat,
      params: {"chat_to": staffId.value},
      method: MethodType.post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          final myId = int.tryParse(box.read(PrefsKey.userId).toString());
          final chatBy = response["chat"]["chat_by"];
          final chatTo = response["chat"]["chat_to"];
          Get.to(
            () => ChatView(),
            arguments: {
              'flag': ChatType.CreateChat,
              'chatId': response["chat"]["id"],
              'profilePic': staffDetailsData?.profilePic ?? '',
              'fullName': staffDetailsData?.fullName ?? '',
              'otherID': myId == chatBy ? chatTo : chatBy,
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

  //endregion
}
