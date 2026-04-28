import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../commonWidgets/commonPermissionHandler.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/prefsKey.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../editChildsInformation/model/StudentsListModel.dart';
import '../model/GetShiftModel.dart';

class StudentEditProfileController extends GetxController {
  var errorImage = ''.obs;
  RxString? selectedShift = "".obs;

  /// Full Name
  TextEditingController fullNameController = TextEditingController();
  var isSelect = 0.obs;
  var errorFullName = ''.obs;

  /// Home Phone Number
  TextEditingController homePhoneNumberController = TextEditingController();
  String isoCode = 'US';
  String countryCode = '1';
  var maxLength = 10.obs;
  var errorHomePhoneNumber = ''.obs;
  var minLength = 10.obs;
  var isPhone = true.obs;

  /// Date of Birth
  TextEditingController dateOfBirthController = TextEditingController();
  DateTime? birthDate;
  var dateOfBirth = ''.obs;
  var errorDateOfBirth = ''.obs;

  /// Relation to child
  TextEditingController relationToChildController = TextEditingController();
  var errorRelationToChild = ''.obs;

  /// Medical Insurance Number
  TextEditingController medicalInsuranceNumberController = TextEditingController();
  var errorMedicalInsuranceNumber = ''.obs;

  /// Address
  TextEditingController addressController = TextEditingController();
  var errorAddress = ''.obs;


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
        studentDetailsData?.profilePic = null;
        image.value = pickedFile.path;
        errorImage.value = '';
        update();
      }
    }
  }


  bool _isImageFile(String filePath) {
    return filePath.toLowerCase().endsWith('.jpg') || filePath.toLowerCase().endsWith('.jpeg') || filePath.toLowerCase().endsWith('.png');
  }

  var errorGender = ''.obs;
  String? selectedGender;
  List<String> genderList = ['Male', 'Female'];

  var errorFrequencyAttendance = ''.obs;


  Future<void> dateOfBirthCalendar(BuildContext context) async {
    DateTime now = DateTime.now();

    birthDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
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

    if (birthDate != null) {
      dateOfBirthController.text =
          DateFormat("yyyy-MM-dd").format(birthDate!);
      errorDateOfBirth.value = '';
      update();
    }
  }



  var flag, studentId;
  StudentsListData? studentDetailsData;

  @override
  void onInit() {
    if (flag != 'studentEdit') {
      getShiftApi();
    }
    if (Get.arguments != null) {
      flag = Get.arguments['flag'];
      studentId = Get.arguments['studentId'];
      studentDetailsData = Get.arguments['studentDetailsData'];
      if (flag == 'studentEdit') {
        editData();
      }
    }
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

  editData() {
    errorImage.value = '';
    fullNameController.text = studentDetailsData!.fullName;
    homePhoneNumberController.text = '${studentDetailsData?.mobileNo}';
    dateOfBirthController.text = studentDetailsData?.dob;
    String? genderFromPrefs = studentDetailsData?.gender;
    if (genderFromPrefs != null) {
      selectedGender = genderList.firstWhere((g) => g.toLowerCase() == genderFromPrefs.toLowerCase(), orElse: () => '');
    }
    relationToChildController.text = studentDetailsData?.relationToChild;
    if (studentDetailsData!.shiftName != null) {
      selectedShift!.value = studentDetailsData!.shiftName;
      shiftId.value = studentDetailsData!.shiftId;
    }
    medicalInsuranceNumberController.text = studentDetailsData?.madicalInsuaranceNo;
    addressController.text = studentDetailsData?.address;
    isoCode = studentDetailsData!.isoCode.toString().toUpperCase();
    countryCode = studentDetailsData?.countryCode;
    image = studentDetailsData?.profilePic;
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


  bool isValidation() {
    errorFullName.value = '';
    errorHomePhoneNumber.value = '';
    errorDateOfBirth.value = '';
    errorGender.value = '';
    errorRelationToChild.value = '';
    errorFrequencyAttendance.value = '';
    errorMedicalInsuranceNumber.value = '';
    errorAddress.value = '';
    errorImage.value = '';

    bool isValid = true;
    if (image == '' || image.isEmpty) {
      errorImage.value = 'Please select image';
      isValid = false;
    }
    if (fullNameController.text.trim().isEmpty) {
      errorFullName.value = AppMessage.pleaseEnterYourFullName;
      isValid = false;
    }
    if (homePhoneNumberController.text.trim().isEmpty) {
      errorHomePhoneNumber.value = AppMessage.pleaseEnterYourMobileNumber;
      isValid = false;
    }
    if (homePhoneNumberController.text.trim().isNotEmpty && maxLength.value != homePhoneNumberController.text.length) {
      isValid = false;
      errorHomePhoneNumber.value = AppMessage.pleaseEnterValidMobileNumber;
    }
    if (dateOfBirthController.text.trim().isEmpty) {
      errorDateOfBirth.value = AppMessage.pleaseSelectYourBirthDate;
      isValid = false;
    }
    if (selectedGender == null) {
      errorGender.value = AppMessage.pleaseSelectYourGender;
      isValid = false;
    }
    if (relationToChildController.text.trim().isEmpty) {
      errorRelationToChild.value = AppMessage.pleaseSelectYourRelation;
      isValid = false;
    }
    if (selectedShift == null || selectedShift!.value.trim().isEmpty) {
      errorFrequencyAttendance.value = AppMessage.pleaseSelectYourFrequencyAttendance;
      isValid = false;
    }
    if (medicalInsuranceNumberController.text.trim().isEmpty) {
      errorMedicalInsuranceNumber.value = AppMessage.pleaseEnterMedicalInsuranceNumber;
      isValid = false;
    }
    if (addressController.text.trim().isEmpty) {
      errorAddress.value = AppMessage.pleaseEnterYourAddress;
      isValid = false;
    }
    return isValid;
  }

  RxBool isLoading = false.obs;

  List<GetShiftData> getShiftDataList = [];
  var shiftId = 0.obs;

  getShiftApi() async {
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.getShift,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        GetShiftModel model = GetShiftModel.fromJson(response);
        if (model.status == 1) {
          getShiftDataList = model.data!;
        }
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

  addStudentApi() async {
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    Map<String, dynamic> finalJson = {
      'full_name': fullNameController.text,
      "gender": selectedGender == "Male" ? "male" : "female",
      "dob": dateOfBirthController.text,
      'madical_insuarance_no': medicalInsuranceNumberController.text,
      'relation_to_child': relationToChildController.text,
      'shift_id': shiftId,
      "mobile_no": homePhoneNumberController.text,
      "country_code": '+$countryCode',
      "iso_code": isoCode,
      "address": addressController.text,
      if (image != '') 'profile_pic': await MultipartFile.fromFile(image.value, filename: image.split("/").last),
    };
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.addStudent,
      method: MethodType.post,
      params: FormData.fromMap(finalJson),
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        if (response['status'] == 1) {
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

  Map<String, dynamic> originalProfileData = {};

  editStudentApi() async {
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
      toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      return;
    }
    Map<String, dynamic> finalJson = {};
    if ((fullNameController.text ?? '') != (originalProfileData['full_name'] ?? '')) {
      finalJson['full_name'] = fullNameController.text;
    }
    if ((selectedGender ?? '').toLowerCase() != (originalProfileData['gender'] ?? '').toLowerCase()) {
      finalJson['gender'] = selectedGender?.toLowerCase();
    }
    if ((dateOfBirthController.text ?? '') != (originalProfileData['dob'] ?? '')) {
      finalJson['dob'] = dateOfBirthController.text;
    }
    if ((medicalInsuranceNumberController.text ?? '') != (originalProfileData['madical_insuarance_no'] ?? '')) {
      finalJson['madical_insuarance_no'] = medicalInsuranceNumberController.text;
    }
    if ((relationToChildController.text ?? '') != (originalProfileData['relation_to_child'] ?? '')) {
      finalJson['relation_to_child'] = relationToChildController.text;
    }

    if (shiftId != originalProfileData['shift_id']) {
      finalJson['shift_id'] = shiftId;
    }

    if ((homePhoneNumberController.text ?? '') != (originalProfileData['mobile_no'] ?? '')) {
      finalJson['mobile_no'] = homePhoneNumberController.text;
    }

    if ('$countryCode' != (originalProfileData['country_code'] ?? '')) {
      finalJson['country_code'] = '$countryCode';
    }

    if ((isoCode ?? '') != (originalProfileData['iso_code'] ?? '')) {
      finalJson['iso_code'] = isoCode;
    }

    if ((addressController.text ?? '') != (originalProfileData['address'] ?? '')) {
      finalJson['address'] = addressController.text;
    }

    // Handle profile_pic only if changed and local
    if (image != '' && !image.startsWith('http') && image != (originalProfileData['profile_pic'] ?? '')) {
      finalJson['profile_pic'] = await MultipartFile.fromFile(image.value, filename: image.split("/").last);
    }
    finalJson['student_id'] = studentId;
    if (finalJson.keys.length <= 1) {
      isLoading.value = false;
      toastyInfo.showToast(message: "No changes detected.");
      return;
    }

    log("finalJson------>$finalJson");
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.editStudent,
      method: MethodType.put,
      params: FormData.fromMap(finalJson),
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back(result: 1);
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
