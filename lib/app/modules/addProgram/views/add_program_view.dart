import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../controllers/add_program_controller.dart';

class AddProgramView extends GetView<AddProgramController> {
  const AddProgramView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProgramController>(
      init: AddProgramController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: color.white,
            appBar: commonWidget.appBar(
              titleText: controller.flag == 'editProgram' ? AppMessage.editProgram : AppMessage.addProgram,
              backgroundColor: color.transparentColor,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                child: Column(
                  children: [
                    Obx(() {
                      return commonWidget.commonTextField(
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                        keyboardType: TextInputType.text,
                        controller: controller.programNameController,
                        labelText: AppMessage.programName,
                        hintText: AppMessage.enterProgramName,
                        errorText: controller.errorProgramName.value,
                        onTap: () {
                          controller.isSelect.value = 0;
                        },
                        onChanged: (value) {
                          controller.isSelect.value = 0;
                          controller.errorProgramName.value = "";
                        },
                        isbordervisibal: controller.isSelect.value == 0 ? true : false,
                      );
                    }),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: commonWidget
                .customButton(
                  text: AppMessage.save,
                  onTap: () {
                    if (controller.isValidation()) {
                      Get.back();
                    }
                  },
                )
                .paddingAll(MySize.getScaledSizeHeight(16)),
          ),
        );
      },
    );
  }
}
