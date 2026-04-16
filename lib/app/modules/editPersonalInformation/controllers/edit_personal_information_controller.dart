
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:radianthyve_unified/utils/common_color.dart';

import '../../../../commonWidgets/constant.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../login/model/loginModel.dart';

class EditPersonalInformationController extends GetxController {
  /// Full Name
  TextEditingController fullNameController = TextEditingController();
  var isSelect = 0.obs;
  var errorFullName = ''.obs;
  RxBool isLoading = false.obs;

  /// Email
  TextEditingController emailController = TextEditingController();
  var errorEmail = ''.obs;

  /// Phone Number
  TextEditingController phoneNumberController = TextEditingController();
  String isoCode = 'US';
  var countryCode = "1";
  var maxLength = 10.obs;
  var errorPhoneNumber = ''.obs;

  /// Gender
  var errorGender = ''.obs;
  String? selectedGender;
  List<String> genderList = ['Male', 'Female'];

  /// Date of Birth
  TextEditingController dateOfBirthController = TextEditingController();
  DateTime? birthDate;
  var dateOfBirth = ''.obs;
  var errorDateOfBirth = ''.obs;

  /// Joining Date
  TextEditingController joiningDateController = TextEditingController();
  DateTime? joiningDate;
  var selectJoiningDate = ''.obs;
  var errorJoiningDate = ''.obs;

  /// Experience
  TextEditingController experienceController = TextEditingController();
  var errorExperience = ''.obs;

  /// About Staff
  TextEditingController aboutStaffController = TextEditingController();
  var errorAboutStaff = ''.obs;

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
              primary: color.appColor, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: color.appColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (birthDate != null) {
      dateOfBirthController.text = DateFormat(
        "yyy-MM-dd",
      ).format(DateTime.parse(birthDate.toString()));
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
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: color.appColor),
            ),
          ),
          child: child!,
        );
      },
    );

    if (joiningDate != null) {
      joiningDateController.text = DateFormat(
        "yyy-mm-dd",
      ).format(DateTime.parse(joiningDate.toString()));
      errorJoiningDate.value = '';
      update();
    }
  }

  editData() {
    fullNameController.text = box.read(PrefsKey.fullName) ?? '';
    emailController.text = box.read(PrefsKey.emailId) ?? '';
    isoCode = box.read(PrefsKey.isoCode) ?? '';
    countryCode = box.read(PrefsKey.countryCode) ?? '';
    String? genderFromPrefs = box.read(PrefsKey.gender);
    if (genderFromPrefs != null) {
      selectedGender = genderList.firstWhere(
        (g) => g.toLowerCase() == genderFromPrefs.toLowerCase(),
        orElse: () => '',
      );
    }
    dateOfBirthController.text = box.read(PrefsKey.dob) ?? '';
    joiningDateController.text = box.read(PrefsKey.joiningDate) ?? '';
    experienceController.text = box.read(PrefsKey.experience) ?? '';
    aboutStaffController.text = box.read(PrefsKey.aboutStaff) ?? '';
    if (box.read(PrefsKey.mobileNo) != null) {
      phoneNumberController.text = box.read(PrefsKey.mobileNo).toString();
    }
    maxLength.value = getMaxLengthForCountry(isoCode);
  }

  int getMaxLengthForCountry(String iso) {
    switch (iso) {
      case 'AW': // Aruba
        return 7;
      case 'US':
        return 10;
      default:
        return 10;
    }
  }

  @override
  void onInit() {
    editData();
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

  bool isValidation() {
    errorFullName.value = '';
    errorEmail.value = '';
    errorPhoneNumber.value = '';
    errorGender.value = '';
    errorDateOfBirth.value = '';
    errorJoiningDate.value = '';
    errorExperience.value = '';
    errorAboutStaff.value = '';

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

  editAccountApi({required BuildContext context}) async {
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    Map<String, dynamic> finalJson = {
      'full_name': fullNameController.text,
      'iso_code': isoCode,
      'country_code': countryCode,
      'mobile_no': phoneNumberController.text,
      "dob": dateOfBirthController.text,
      "gender": selectedGender == "Male" ? "male" : "female",
      "joining_date": joiningDateController.text,
      "about_staff": aboutStaffController.text,
      "experience": experienceController.text,
    };
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.editTeacherProfile,
      method: MethodType.put,
      params: FormData.fromMap(finalJson),
      headers: NetworkClient.getInstance.getAuthHeaders(
        tokenRegister: box.read(PrefsKey.userToken),
      ),
      successCallback: (response, message) async {
        LoginModel accountSetupModel = LoginModel.fromJson(response);
        if (accountSetupModel.status == 1) {
          await commonMethod.storeUserData(accountSetupModel);
          Get.back(result: 1);
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
}
