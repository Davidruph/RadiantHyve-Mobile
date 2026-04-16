import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/add_leave_controller.dart';

class AddLeaveView extends GetView<AddLeaveController> {
  const AddLeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddLeaveController>(
      init: AddLeaveController(),
      assignId: true,
      builder: (controller) {
        return Obx(() {
          return IgnorePointer(
            ignoring: controller.isLoading.value,
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                backgroundColor: color.white,
                appBar: commonWidget.appBar(
              titleText: AppMessage.addLeave,
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
                        commonText.medium(
                          text: AppMessage.leaveType,
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
                              border: Border.all(
                                color: controller.errorLeaveType == '' ? color.onboardingBorderColor : color.textFieldErrorColor,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: GetBuilder<AddLeaveController>(
                                builder: (controller) {
                                  return DropdownButton<String>(
                                    hint: commonText.regular(
                                      text: AppMessage.select,
                                      textColor: color.onboardingTextColor,
                                      fontSize: MySize.getScaledSizeHeight(14),
                                    ),
                                    dropdownColor: color.white,
                                    value: controller.selectedLeaveType,
                                    icon: Icon(Icons.keyboard_arrow_down, color: color.black, size: 20),
                                    borderRadius: BorderRadius.circular(12),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        controller.selectedLeaveType = newValue;
                                        controller.errorLeaveType.value = '';
                                        controller.update();
                                      }
                                    },
                                    items:
                                        controller.leaveTypeList.map<DropdownMenuItem<String>>((String value) {
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
                        Obx(
                          () =>
                              controller.errorLeaveType.value == ''
                                  ? SizedBox()
                                  : commonText
                                      .medium(
                                        text: controller.errorLeaveType.value,
                                        fontSize: MySize.getScaledSizeHeight(10),
                                        textColor: color.textFieldErrorColor,
                                        textAlign: TextAlign.center,
                                      )
                                      .paddingOnly(top: MySize.getScaledSizeHeight(2)),
                        ),
                        16.0.hSpace(),
                        Obx(() {
                          return commonWidget.commonTextField(
                            readOnly: true,
                            controller: controller.dateController,
                            labelText: AppMessage.date,
                            hintText: AppMessage.selectDate,
                            errorText: controller.errorDate.value,
                            suffixIcon: Image.asset(icons.calendarIcon, scale: 4),
                            contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(12), left: MySize.getScaledSizeWidth(10)),
                            onTap: () {
                              controller.isSelect.value = 0;
                              FocusScope.of(context).unfocus();
                              controller.dateOfLeaveCalendar(context);
                              controller.update();
                            },
                            onChanged: (value) {
                              controller.isSelect.value = 0;
                              if (controller.dateController.text.isEmpty) {
                                controller.errorDate.value = "Please select your birth date.";
                              } else {
                                controller.errorDate.value = "";
                              }
                              controller.update();
                            },
                            isbordervisibal: controller.isSelect.value == 0 ? true : false,
                          );
                        }),
                        18.0.hSpace(),
                        Obx(() {
                          return commonWidget.commonTextField(
                            keyboardType: TextInputType.text,
                            controller: controller.reasonController,
                            labelText: AppMessage.reason,
                            hintText: 'Enter reason',
                            height: MySize.getScaledSizeHeight(110),
                            maxLines: 4,
                            minLines: 4,
                            errorText: controller.errorReason.value,
                            onTap: () {
                              controller.isSelect.value = 1;
                            },
                            onChanged: (value) {
                              controller.isSelect.value = 1;
                              controller.errorReason.value = "";
                            },
                            isbordervisibal: controller.isSelect.value == 1 ? true : false,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: commonWidget
                    .customButton(
                      isLoading: controller.isLoading.value,
                      text: AppMessage.save,
                      onTap: () {
                        if (controller.isValidation()) {
                          controller.staffApplyLeaveApi();
                        }
                      },
                    )
                    .paddingOnly(
                      left: MySize.getScaledSizeHeight(16),
                      right: MySize.getScaledSizeHeight(16),
                      bottom: MySize.getScaledSizeHeight(Platform.isIOS ? 25 : 16),
                    ),
              ),
            ),
          );
        });
      },
    );
  }
}
