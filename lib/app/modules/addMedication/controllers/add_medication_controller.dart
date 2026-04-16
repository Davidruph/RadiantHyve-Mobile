import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../addMenu/model/TeacherAllStudentModel.dart';
import '../../medication/model/ListMedificationStudentModel.dart';

class AddMedicationController extends GetxController {
  ListMedicationStudentData? listMedicationStudentData;

  ///Student Name
  final List<String> studentNameOptions = [
    "Dianne Howard",
    "Brooklyn Simmons",
    "Henry Miles",
    "Esther Howard",
    "Marvin McKinney",
    "Courtney Henry",
  ];

  List<TeacherAllStudentData> getSuggestionsStudent(String query) {
    return getBookingsUserDataList
        .where((student) => student.fullName.contains(query.toLowerCase()))
        .toList();
  }

  RxBool isLoading = false.obs;
  var errorStudent = ''.obs;
  final TextEditingController studentListController = TextEditingController();
  var isSelect = 0.obs;

  /// Type of Disease
  TextEditingController typeOfDiseaseController = TextEditingController();
  var errorTypeOfDisease = ''.obs;

  /// Medication Details
  TextEditingController medicationDetailsController = TextEditingController();
  var errorMedicationDetails = ''.obs;

  /// Doctors Name
  TextEditingController doctorsNameController = TextEditingController();
  var errorDoctorsName = ''.obs;

  /// Doctors Phone Number
  TextEditingController doctorsPhoneNumberController = TextEditingController();
  var errorPhoneNumber = ''.obs;
  String isoCode = 'US';
  String countryCode = '+1';
  var maxLength = 10.obs;

  var flag;
  var selectStudentId, medicationId;

  void selectStudent(String student) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    studentListController.text = student;
    errorStudent.value = '';
    update();
  }

  @override
  void onInit() {
    teacherAllStudentApi();
    if (Get.arguments != null) {
      flag = Get.arguments['flag'];
      listMedicationStudentData = Get.arguments['medicationData'];
      log('listMedicationStudentData===>${jsonEncode(listMedicationStudentData)}');
    }
    if (flag == 'editMedication') {
      studentListController.text = listMedicationStudentData?.studentName;
      typeOfDiseaseController.text = listMedicationStudentData?.typeDisease;
      medicationDetailsController.text = listMedicationStudentData?.medicationDetails;
      doctorsNameController.text = listMedicationStudentData?.doctorName;
      if (listMedicationStudentData!.mobileNo != null) {
        doctorsPhoneNumberController.text = listMedicationStudentData!.mobileNo.toString();
      }
      isoCode = listMedicationStudentData?.isoCode;
      countryCode = listMedicationStudentData?.countryCode;
      medicationId = listMedicationStudentData?.id;
      selectStudentId = listMedicationStudentData?.studentId;
      maxLength.value = getMaxLengthForCountry(isoCode);
    }
    super.onInit();
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
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool isValidation() {
    errorStudent.value = '';
    errorTypeOfDisease.value = '';
    errorMedicationDetails.value = '';
    errorDoctorsName.value = '';
    errorPhoneNumber.value = '';

    bool isValid = true;
    if (studentListController.text.trim().isEmpty) {
      errorStudent.value = AppMessage.pleaseSelectStudentName;
      isValid = false;
    }
    if (typeOfDiseaseController.text.trim().isEmpty) {
      errorTypeOfDisease.value = AppMessage.pleaseEnterTypeOfDisease;
      isValid = false;
    }
    if (medicationDetailsController.text.trim().isEmpty) {
      errorMedicationDetails.value = AppMessage.pleaseEnterMedicationDetails;
      isValid = false;
    }
    if (doctorsPhoneNumberController.text.trim().isEmpty) {
      errorPhoneNumber.value = AppMessage.pleaseEnterYourMobileNumber;
      isValid = false;
    }
    if (doctorsPhoneNumberController.text.trim().isNotEmpty && maxLength.value != doctorsPhoneNumberController.text.length) {
      isValid = false;
      errorPhoneNumber.value = AppMessage.pleaseEnterValidMobileNumber;
    }
    return isValid;
  }

  List<TeacherAllStudentData> getBookingsUserDataList = [];

  teacherAllStudentApi() async {
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.teacherAllStudent,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        TeacherAllStudentModel teacherAllStudentModel = TeacherAllStudentModel.fromJson(response);
        if (teacherAllStudentModel.status == 1) {
          getBookingsUserDataList = teacherAllStudentModel.data!;
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

  addMedificationApi() async {
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    final param = {
      "student_id": selectStudentId,
      "doctor_name": doctorsNameController.text,
      "type_disease": typeOfDiseaseController.text,
      "medication_details": medicationDetailsController.text,
      "iso_code": isoCode,
      "country_code": countryCode.startsWith('+') ? countryCode : '+$countryCode',
      "mobile_no": doctorsPhoneNumberController.text,
    };
    log('param----------------------> $param');
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.addMedification,
      method: MethodType.post,
      params: param,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back(result: 1);
        } else {
          isLoading.value = false;
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

  editMedificationApi() async {
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    final param = {
      "medication_id": medicationId,
      "student_id": selectStudentId,
      "doctor_name": doctorsNameController.text,
      "type_disease": typeOfDiseaseController.text,
      "medication_details": medicationDetailsController.text,
      "iso_code": isoCode,
      "country_code": countryCode.startsWith('+') ? countryCode : '+$countryCode',
      "mobile_no": doctorsPhoneNumberController.text,
    };
    log('param----------------------> $param');
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.editMedification,
      method: MethodType.put,
      params: param,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back(result: 1);
          Get.back(result: 1);
        } else {
          isLoading.value = false;
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
