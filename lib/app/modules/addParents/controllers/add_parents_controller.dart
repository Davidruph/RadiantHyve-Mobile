import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import '../../../../commonWidgets/commonPermissionHandler.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../../parentsDetails/model/ParentsDetailsModel.dart';

class AddParentsController extends GetxController {
  var isLoading = false.obs;
  var errorImage = ''.obs;
  var networkPic = "", parentId;

  /// Full Name
  TextEditingController fullNameController = TextEditingController();
  var isSelect = 0.obs;
  var errorFullName = ''.obs;

  /// Email
  TextEditingController emailController = TextEditingController();
  var errorEmail = ''.obs;

  /// Phone Number
  TextEditingController phoneNumberController = TextEditingController();
  String isoCode = 'US';
  String countryCode = '+1';
  var maxLength = 10.obs;
  var errorPhoneNumber = ''.obs;

  /// About Staff
  TextEditingController addressController = TextEditingController();
  var errorAddress = ''.obs;

  var flag, profile;
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
      }
    }
  }

  bool _isImageFile(String filePath) {
    return filePath.toLowerCase().endsWith('.jpg') ||
        filePath.toLowerCase().endsWith('.jpeg') ||
        filePath.toLowerCase().endsWith('.png');
  }

  ParentsDetailsData? parentData;

  var errorGender = ''.obs;
  String? selectedGender;
  List<String> genderList = ['Male', 'Female'];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      flag = Get.arguments['flag'];
      if (flag == 'editParents') {
        parentData = Get.arguments["parent_details"];
        if (parentData!.profilePic != null) {
          networkPic = parentData!.profilePic!;
        }
        parentId = parentData!.id!;
        fullNameController.text = parentData!.fullName!;
        emailController.text = parentData!.email!;
        isoCode = parentData!.isoCode!;
        countryCode = parentData!.countryCode!;
        phoneNumberController.text = parentData!.mobileNo!.toString();
        String? genderFromPrefs = parentData!.gender!;
        if (genderFromPrefs != "") {
          selectedGender = genderList.firstWhere(
              (g) => g.toLowerCase() == genderFromPrefs.toLowerCase(),
              orElse: () => '');
        }
        addressController.text = parentData!.address!;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool isValidation() {
    errorFullName.value = '';
    errorEmail.value = '';
    errorPhoneNumber.value = '';
    errorGender.value = '';
    errorAddress.value = '';
    // errorImage.value = '';

    bool isValid = true;
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

    // if (flag == 'editParents') {
    // } else {
    //   if (image == '') {
    //     errorImage.value = 'Please Select Your Profile Image.';
    //     isValid = false;
    //   }
    // }
    if (fullNameController.text.trim().isEmpty) {
      errorFullName.value = AppMessage.pleaseEnterYourFullName;
      isValid = false;
    }
    if (emailController.text.trim().isEmpty) {
      errorEmail.value = AppMessage.pleaseEnterYourEmail;
      isValid = false;
    } else if (!emailRegex.hasMatch(emailController.text)) {
      errorEmail.value = AppMessage.pleaseEnterValidEmail;
      isValid = false;
    }
    if (phoneNumberController.text.trim().isEmpty) {
      errorPhoneNumber.value = AppMessage.pleaseEnterYourMobileNumber;
      isValid = false;
    }
    if (phoneNumberController.text.trim().isNotEmpty &&
        maxLength.value != phoneNumberController.text.length) {
      isValid = false;
      errorPhoneNumber.value = AppMessage.pleaseEnterValidMobileNumber;
    }
    if (selectedGender == null) {
      errorGender.value = AppMessage.pleaseSelectYourGender;
      isValid = false;
    }
    if (addressController.text.trim().isEmpty) {
      errorAddress.value = AppMessage.pleaseEnterYourAddress;
      isValid = false;
    }

    return isValid;
  }

  //region Add Parent Api
  addParentApi() async {
    Map<String, dynamic> params = {
      "email": emailController.text,
      "full_name": fullNameController.text,
      "gender": selectedGender == "Male" ? "male" : "female",
      "mobile_no": phoneNumberController.text,
      "country_code": countryCode,
      "iso_code": isoCode,
      "address": addressController.text,
    };
    if (image != "") {
      params['profile_pic'] = await MultipartFile.fromFile(image.value, filename: image.split("/").last);
    }

    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.addParent,
      method: MethodType.post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      params: FormData.fromMap(params),
      successCallback: (response, message) async {
        Get.back(result: 1);
        isLoading.value = false;
        toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
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

  //region Edit Parent Api
  editParentApi() async {
    Map<String, dynamic> params = {
      "email": emailController.text,
      "full_name": fullNameController.text,
      "gender": selectedGender == "Male" ? "male" : "female",
      "mobile_no": phoneNumberController.text,
      "country_code": countryCode,
      "iso_code": isoCode,
      "address": addressController.text,
      "parent_id": parentId,
    };
    if (image != "") {
      params['profile_pic'] = await MultipartFile.fromFile(image.value, filename: image.split("/").last);
    }

    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.editParent,
      method: MethodType.put,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      params: FormData.fromMap(params),
      successCallback: (response, message) async {
        Get.back(result: 1);
        isLoading.value = false;
        toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
      },
      failureCallback: (status, message) {
        log("status-----?${status}");
        log("message-----?${message}");
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
}
