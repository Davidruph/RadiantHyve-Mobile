import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:permission_handler/permission_handler.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import '../../../../commonWidgets/commonPermissionHandler.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../staffDetails/model/StaffDetailsModel.dart';

class AddStaffController extends GetxController {
  var errorImage = ''.obs;
  RxBool isLoading = false.obs;

  // Full Name
  TextEditingController fullNameController = TextEditingController();
  var isSelect = 0.obs;
  var errorFullName = ''.obs;

  // Email
  TextEditingController emailController = TextEditingController();
  var errorEmail = ''.obs;

  // Phone Number
  TextEditingController phoneNumberController = TextEditingController();
  String isoCode = 'US';
  String countryCode = '+1';
  var maxLength = 10.obs;
  var errorPhoneNumber = ''.obs;

  // Date of Birth
  TextEditingController dateOfBirthController = TextEditingController();
  DateTime? birthDate;
  var dateOfBirth = ''.obs;
  var errorDateOfBirth = ''.obs;

  // Joining Date
  TextEditingController joiningDateController = TextEditingController();
  DateTime? joiningDate;
  var selectJoiningDate = ''.obs;
  var errorJoiningDate = ''.obs;

  // Experience
  TextEditingController experienceController = TextEditingController();
  var errorExperience = ''.obs;

  // About Staff
  TextEditingController aboutStaffController = TextEditingController();
  var errorAboutStaff = ''.obs;


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
    return filePath.toLowerCase().endsWith('.jpg') || filePath.toLowerCase().endsWith('.jpeg') || filePath.toLowerCase().endsWith('.png');
  }

  var errorGender = ''.obs;
  String? selectedGender;
  List<String> genderList = ['Male', 'Female'];

  Future dateOfBirthCalendar(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);

    birthDate = await showDatePicker(
      context: context,
      initialDate: eighteenYearsAgo,
      firstDate: DateTime(1900),
      lastDate: eighteenYearsAgo,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: color.appColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color.appColor)),
          ),
          child: child!,
        );
      },
    );

    if (birthDate != null) {
      dateOfBirth.value = birthDate.toString();
      dateOfBirthController.text = DateFormat("yyy-MM-dd").format(DateTime.parse(birthDate.toString()));
      errorDateOfBirth.value = '';
      update();
    }
  }

  Future JoiningDateCalendar(BuildContext context) async {
    joiningDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: color.appColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color.appColor)),
          ),
          child: child!,
        );
      },
    );

    if (joiningDate != null) {
      selectJoiningDate.value = joiningDate.toString();
      joiningDateController.text = dateOfBirthController.text = DateFormat("yyy-MM-dd").format(DateTime.parse(birthDate.toString()));
      errorJoiningDate.value = '';
      update();
    }
  }

  StaffDetailsData? staffDetailsData;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      flag = Get.arguments["flag"];
      if (flag == 'editStaff') {
        staffDetailsData = Get.arguments["staff_details"];
        fullNameController.text = staffDetailsData!.fullName!;
        emailController.text = staffDetailsData!.email!;
        isoCode = staffDetailsData!.isoCode!;
        countryCode = staffDetailsData!.countryCode!;
        phoneNumberController.text = staffDetailsData!.mobileNo!.toString();
        String? genderFromPrefs = staffDetailsData!.gender!;
        if (genderFromPrefs != "") {
          selectedGender = genderList.firstWhere((g) => g.toLowerCase() == genderFromPrefs.toLowerCase(), orElse: () => '');
        }
        dateOfBirthController.text = staffDetailsData!.dob!;
        joiningDateController.text = staffDetailsData!.joiningDate!;
        experienceController.text = staffDetailsData!.experience!;
        aboutStaffController.text = staffDetailsData!.aboutStaff!;
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
    errorDateOfBirth.value = '';
    // errorSubject.value = '';
    errorJoiningDate.value = '';
    errorExperience.value = '';
    // errorShift.value = '';
    errorAboutStaff.value = '';
    // errorImage.value = '';

    bool isValid = true;
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

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
    if (phoneNumberController.text.trim().isNotEmpty && maxLength.value != phoneNumberController.text.length) {
      isValid = false;
      errorPhoneNumber.value = AppMessage.pleaseEnterValidMobileNumber;
    }
    if (selectedGender == null) {
      errorGender.value = AppMessage.pleaseSelectYourGender;
      isValid = false;
    }
    if (dateOfBirthController.text.trim().isEmpty) {
      errorDateOfBirth.value = AppMessage.pleaseSelectYourBirthDate;
      isValid = false;
    }

    if (joiningDateController.text.trim().isEmpty) {
      errorJoiningDate.value = AppMessage.pleaseSelectYourJoiningDate;
      isValid = false;
    }
    if (experienceController.text.trim().isEmpty) {
      errorExperience.value = AppMessage.pleaseEnterYourYearsOfExperience;
      isValid = false;
    }

    if (aboutStaffController.text.trim().isEmpty) {
      errorAboutStaff.value = AppMessage.pleaseEnterAboutStaff;
      isValid = false;
    }

    return isValid;
  }

  //region Add staff Api
  addStaffApi() async {
    Map<String, dynamic> params = {
      "email": emailController.text,
      "full_name": fullNameController.text,
      "gender": selectedGender == "Male" ? "male" : "female",
      "dob": dateOfBirthController.text,
      "joining_date": joiningDateController.text,
      "about_staff": aboutStaffController.text,
      "experience": experienceController.text,
      "mobile_no": phoneNumberController.text,
      "country_code": countryCode.startsWith('+') ? countryCode : '+$countryCode',
      "iso_code": isoCode,
    };
    if (image != '') {
      params['profile_pic'] = await MultipartFile.fromFile(image.value, filename: image.split("/").last);
    }
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.addStaff,
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

  //region edit profile Api
  editProfileApi() async {
    Map<String, dynamic> params = {
      "email": emailController.text,
      "full_name": fullNameController.text,
      "gender": selectedGender == "Male" ? "male" : "female",
      "dob": dateOfBirthController.text,
      "joining_date": joiningDateController.text,
      "about_staff": aboutStaffController.text,
      "experience": experienceController.text,
      "mobile_no": phoneNumberController.text,
      "country_code": countryCode.startsWith('+') ? countryCode : '+$countryCode',
      "iso_code": isoCode,
      "staff_id": staffDetailsData!.id,
    };
    if (image != '') {
      params['profile_pic'] = await MultipartFile.fromFile(image.value, filename: image.split("/").last);
    }
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.editStaff,
      method: MethodType.put,
      params: FormData.fromMap(params),
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
        Get.back(result: 1);
        isLoading.value = false;
        update();
      },
      failureCallback: (status, message) {
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
        isLoading.value = false;
      },
      timeOutCallback: () {
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
        isLoading.value = false;
      },
    );
  }
//endregion
}
