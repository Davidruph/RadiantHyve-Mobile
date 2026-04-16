import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddClassroomController extends GetxController {
  /// Full Name
  TextEditingController classNameController = TextEditingController();
  var isSelect = 0.obs;
  var errorClassName = ''.obs;

  /// Email
  TextEditingController totalStudentCapacityController = TextEditingController();
  var errorTotalStudentCapacity = ''.obs;

  var errorAssignedStaff = ''.obs;

  String? selectedAssignedStaff;
  List<String> assignedStaffList = ['Ronald Richards', 'Marvin McKinney', 'Courtney Henry'];

  @override
  void onInit() {
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
    errorClassName.value = '';
    errorTotalStudentCapacity.value = '';
    errorAssignedStaff.value = '';

    bool isValid = true;

    if (classNameController.text.trim().isEmpty) {
      errorClassName.value = 'Please enter class name.';
      isValid = false;
    }
    if (totalStudentCapacityController.text.trim().isEmpty) {
      errorTotalStudentCapacity.value = 'Please enter student capacity.';
      isValid = false;
    }
    if (selectedAssignedStaff == null) {
      errorAssignedStaff.value = 'Please select staff.';
      isValid = false;
    }
    return isValid;
  }
}
