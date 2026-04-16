import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../commonWidgets/commonPermissionHandler.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../login/model/loginModel.dart';

class ProfileController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();





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
        editAccountApi();
      }
    }
  }


  bool _isImageFile(String filePath) {
    return filePath.toLowerCase().endsWith('.jpg') || filePath.toLowerCase().endsWith('.jpeg') || filePath.toLowerCase().endsWith('.png');
  }

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
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

  editAccountApi() async {
    Map<String, dynamic> finalJson = {'profile_pic': await MultipartFile.fromFile(image.value, filename: image.split('/').last)};
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.editTeacherProfile,
      method: MethodType.put,
      params: FormData.fromMap(finalJson),
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        LoginModel accountSetupModel = LoginModel.fromJson(response);
        log("accountSetupApi response---${response}");
        if (accountSetupModel.status == 1) {
          box.write(PrefsKey.profilePic, accountSetupModel.data!.profilePic);
        } else {
          isLoading.value = false;
        }
        isLoading.value = false;
        uiLoad();
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
}

var isUiLoad = false.obs;

uiLoad() {
  isUiLoad.value = true;
  Future.delayed(Duration(milliseconds: 200)).then((value) {
    isUiLoad.value = false;
  });
}
