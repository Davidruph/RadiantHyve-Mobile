
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../../certification/model/CertificateListModel.dart';
import '../../studentDetails/model/ListTeachersModel.dart';

class AddCertificationController extends GetxController {
  /// Course Name
  // TextEditingController courseNameController = TextEditingController();
  /* errorCourseName = ''.obs;*/

  /// Institution Name
  CertificateListData? certification;
  TextEditingController institutionNameController = TextEditingController();
  var errorInstitutionName = ''.obs;
  var isSelect = 0.obs, flag;

  var errorSelectStaff = ''.obs;
  RxString? selectedStaff = "".obs;

  var errorChecklist = ''.obs;
  String? selectedChecklist;
  List<String> checklistList = [
    'Certified by an institution',
    'Accredited certificate',
    'Official certificate',
    'School-endorsed certificate',
    'Recognized by an educational authority',
    'Proof of official qualification',
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      flag = Get.arguments['flag'];
      if (flag == 'editCertification') {
        certification = Get.arguments["details"];
        institutionNameController.text = certification!.institutionName!;
        staffId.value = certification!.staffId!;
        selectedStaff!.value = certification!.staffName!;
        selectedChecklist = certification!.hireChecklist!;
      }
    }
    getListTeacherApi();
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
    // errorCourseName.value = '';
    errorInstitutionName.value = '';
    errorSelectStaff.value = '';
    errorChecklist.value = '';

    bool isValid = true;

    // if (courseNameController.text.trim().isEmpty) {
    //   errorCourseName.value = AppMessage.pleaseEnterYourCourseName;
    //   isValid = false;
    // }
    if (institutionNameController.text.trim().isEmpty) {
      errorInstitutionName.value = AppMessage.pleaseEnterYourInstitutionName;
      isValid = false;
    }

    if (selectedStaff!.value == '') {
      errorSelectStaff.value = AppMessage.pleaseSelectStaffName;
      isValid = false;
    }
    if (selectedChecklist == null) {
      errorChecklist.value = AppMessage.pleaseSelectYourCertificate;
      isValid = false;
    }
    return isValid;
  }

  //region Add Certification Api
  RxBool isLoading = false.obs;
  addCertificationApi() async {
    Map<String, dynamic> params = {
      "staff_id": staffId.value,
      "hire_checklist": selectedChecklist,
      "institution_name": institutionNameController.text,
    };

    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.addCertification,
      method: MethodType.post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      params: params,
      successCallback: (response, message) async {
        isLoading.value = false;
        toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
        Get.back(result: 1);
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

  //region List Teacher Api
  RxInt staffId = 0.obs;
  List<ListTeachersData> staffList = [];

  getListTeacherApi() async {
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.listTeacher,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        ListTeachersModel data = ListTeachersModel.fromJson(response);
        if (data.status == 1) {
          staffList = data.listTeachersData!;
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
  //endregion

  //region edit certification Api
  editCertificationApi() async {
    Map<String, dynamic> params = {
      "certificate_id": certification!.id,
      "staff_id": staffId.value,
      "hire_checklist": selectedChecklist,
      "institution_name": institutionNameController.text,
    };

    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.editCertification,
      method: MethodType.put,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      params: params,
      successCallback: (response, message) async {
        if (response["status"] == 1) {
          certification?.institutionName = response["data"]["institution_name"].toString();
          certification!.staffId = response["data"]["staff_id"];
          certification!.staffName = selectedStaff!.value;
          certification!.hireChecklist = response["data"]["hire_checklist"];
          //

          toastyInfo.showToast(message: response['message'], backgroundColor: color.appColor);
          Get.back(result: 1);
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
}
