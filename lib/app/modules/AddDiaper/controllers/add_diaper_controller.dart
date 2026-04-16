import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../addMenu/model/TeacherAllStudentModel.dart';

class AddDiaperController extends GetxController {
  var isSelect = 0.obs;
  var selectedIndex = 0.obs;
  var errorStudent = ''.obs;
  final TextEditingController studentListController = TextEditingController();
  RxString selectedCategory = "".obs;
  RxBool isCategoryDropdownOpen = false.obs;
  RxString errorCategory = "".obs;

  RxString type = "Diaper".obs;

  TextEditingController otherCategoryController = TextEditingController();
  RxString errorOtherCategory = "".obs;

  List<String> get categories {
    if (type.value == "Diaper") {
      return ["Wet Only", "Soiled", "Wet & Soiled", "Rash Care Applied", "Other"];
    } else if (type.value == "Give Bath") {
      return [
        "Hygiene Incident – Soiling",
        "Hygiene Incident – Bathroom Accident",
        "Hygiene Incident – Clothing Soiled",
        "Comfort & Cleanliness – Freshen Up",
        "Other",
      ];
    } else {
      return [];
    }
  }

  selectStudent(String student) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    studentListController.text = student;
    errorStudent.value = '';
    update();
  }

  List<TeacherAllStudentData> getSuggestionsStudent(String query) {
    return getBookingsUserDataList.where((student) => student.fullName.contains(query.toLowerCase())).toList();
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      type.value = Get.arguments['type'];
      selectedIndex.value = Get.arguments['selectedIndex'];
      print('type  :- ${type.value}');
      print('selectedIndex  :- $selectedIndex');
    }
    teacherAllStudentApi();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  List<TeacherAllStudentData> getBookingsUserDataList = [];

  teacherAllStudentApi() async {
    print('teacherAllStudentApi    :- ');
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.teacherAllStudent,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        print('response    :- $response');
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

  bool isFormValid() {
    // Reset all error messages
    errorStudent.value = '';
    errorCategory.value = '';
    errorOtherCategory.value = '';

    bool isValid = true;

    // Validate student selection
    if (studentListController.text.trim().isEmpty) {
      errorStudent.value = AppMessage.pleaseSelectStudentName;
      isValid = false;
    }

    // Validate category selection
    if (selectedCategory.value.trim().isEmpty) {
      errorCategory.value = "Please select a category";
      isValid = false;
    }

    if (selectedCategory.value == "Other") {
      if (otherCategoryController.text.trim().isEmpty) {
        errorOtherCategory.value = "Please enter a note";
        isValid = false;
      } else if (otherCategoryController.text.trim().length < 3) {
        errorOtherCategory.value = "Note should be at least 3 characters";
        isValid = false;
      }
    }

    return isValid;
  }

  var selectStudentId = 0;
  RxBool isLoading = false.obs;

  addDiaperAndBathApi() async {
    isLoading.value = true;

    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
      toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      return;
    }

    // Determine reason dynamically
    String reasonValue = selectedCategory.value == "Other" ? otherCategoryController.text.trim() : selectedCategory.value;

    final param = {"student_id": selectStudentId, "reason": reasonValue, "type": type.value == "Diaper" ? "diaper" : "bath"};

    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.addDiaperAndBath,
      method: MethodType.post,
      params: param,
      successCallback: (response, message) async {
        isLoading.value = false;
        if (response['status'] == 1) {
          Get.back(result: {'selectedIndex': selectedIndex.value});
        } else {
          toastyInfo.showToast(message: message);
        }
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
