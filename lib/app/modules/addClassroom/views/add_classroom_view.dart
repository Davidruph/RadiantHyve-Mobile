import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../controllers/add_classroom_controller.dart';

class AddClassroomView extends GetView<AddClassroomController> {
  const AddClassroomView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddClassroomController>(
      init: AddClassroomController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: color.white,
            appBar: commonWidget.appBar(
              titleText: AppMessage.addClassroom,
              backgroundColor: color.transparentColor,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.black),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return commonWidget.commonTextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                          FilteringTextInputFormatter.deny(
                              RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                        ],
                        keyboardType: TextInputType.text,
                        controller: controller.classNameController,
                        labelText: AppMessage.classroom,
                        hintText: AppMessage.enterClassName,
                        errorText: controller.errorClassName.value,
                        onTap: () {
                          controller.isSelect.value = 0;
                        },
                        onChanged: (value) {
                          controller.isSelect.value = 0;
                          controller.errorClassName.value = "";
                        },
                        isbordervisibal: controller.isSelect.value == 0 ? true : false,
                      );
                    }),
                    18.0.hSpace(),
                    Obx(() {
                      return commonWidget.commonTextField(
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        keyboardType: TextInputType.number,
                        controller: controller.totalStudentCapacityController,
                        labelText: AppMessage.totalStudentCapacity,
                        hintText: AppMessage.enterCapacity,
                        errorText: controller.errorTotalStudentCapacity.value,
                        onTap: () {
                          controller.isSelect.value = 1;
                        },
                        onChanged: (value) {
                          controller.isSelect.value = 1;
                          controller.errorTotalStudentCapacity.value = "";
                        },
                        isbordervisibal: controller.isSelect.value == 1 ? true : false,
                      );
                    }),
                    18.0.hSpace(),
                    commonText.medium(
                      text: AppMessage.assignedStaff,
                      textColor: color.textFieldTextColor,
                      fontSize: MySize.getScaledSizeHeight(14),
                    ),
                    08.0.hSpace(),
                    Obx(() {
                      return Container(
                        height: MySize.getScaledSizeHeight(48),
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                          border: Border.all(color: controller.errorAssignedStaff == '' ? color.onboardingBorderColor : color.textFieldErrorColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: GetBuilder<AddClassroomController>(
                            builder: (controller) {
                              return DropdownButton<String>(
                                hint: commonText.regular(
                                  text: AppMessage.select,
                                  textColor: color.onboardingTextColor,
                                  fontSize: MySize.getScaledSizeHeight(14),
                                ),
                                dropdownColor: color.white,
                                value: controller.selectedAssignedStaff,
                                icon: Icon(Icons.keyboard_arrow_down, color: color.black, size: 20),
                                borderRadius: BorderRadius.circular(12),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    controller.selectedAssignedStaff = newValue;
                                    controller.errorAssignedStaff.value = '';
                                    controller.update();
                                  }
                                },
                                items: controller.assignedStaffList.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: commonText.medium(
                                      text: value,
                                      textColor: color.black,
                                      fontSize: MySize.getScaledSizeHeight(14),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ).paddingSymmetric(horizontal: MySize.getScaledSizeHeight(10)),
                      );
                    }),
                    Obx(() => controller.errorAssignedStaff == ''
                        ? SizedBox()
                        : commonText
                            .medium(
                              text: controller.errorAssignedStaff.value,
                              fontSize: MySize.getScaledSizeHeight(10),
                              textColor: color.textFieldErrorColor,
                              textAlign: TextAlign.center,
                            )
                            .paddingOnly(top: MySize.getScaledSizeHeight(2))),
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
