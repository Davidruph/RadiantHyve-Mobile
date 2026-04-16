import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/utils/messages.dart';

class AddProgramController extends GetxController {

  /// Program Name
  TextEditingController programNameController = TextEditingController();
  var isSelect = 0.obs;
  var errorProgramName = ''.obs;

  var flag;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      flag = Get.arguments['flag'];
      if (flag == 'editProgram') {
        programNameController.text = 'Program 1';
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
    errorProgramName.value = '';

    bool isValid = true;

    if (programNameController.text.trim().isEmpty) {
      errorProgramName.value = AppMessage.pleaseEnterProgramName;
      isValid = false;
    }
    return isValid;
  }

}
