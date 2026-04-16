import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/add_sleep_information_controller.dart';

class AddSleepInformationView extends GetView<AddSleepInformationController> {
  const AddSleepInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSleepInformationController>(
      init: AddSleepInformationController(),
      assignId: true,
      builder: (controller) {
        return Obx(() {
          return IgnorePointer(
            ignoring: controller.isLoading.value,
            child: Scaffold(
              backgroundColor: color.white,
              appBar: commonWidget.appBar(
                titleText: controller.flag == 'editSleepLogs' ? AppMessage.editSleepLogsDetails : AppMessage.addSleepInformation,
                backgroundColor: color.transparentColor,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                  child: Column(
                    children: [
                      Obx(() {
                        return commonWidget.commonTextField(
                          controller: controller.studentNameController,
                          labelText: AppMessage.studentName,
                          hintText: AppMessage.enter,
                          readOnly: true,
                          errorText: controller.errorStudentName.value,
                          onTap: () {
                            controller.isSelect.value = 0;
                          },
                          textColor: controller.flag == 'editSleepLogs' ? color.editTextColor : color.onboardingTextColor,
                          onChanged: (value) {
                            controller.isSelect.value = 0;
                            controller.errorStudentName.value = "";
                          },
                          isbordervisibal: controller.isSelect.value == 0 ? true : false,
                        );
                      }),
                      16.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          controller: controller.parentsNameController,
                          labelText: AppMessage.parentsName,
                          hintText: AppMessage.enter,
                          readOnly: true,
                          errorText: controller.errorParentsName.value,
                          onTap: () {
                            controller.isSelect.value = 1;
                          },
                          textColor: controller.flag == 'editSleepLogs' ? color.editTextColor : color.onboardingTextColor,
                          onChanged: (value) {
                            controller.isSelect.value = 1;
                            controller.errorParentsName.value = "";
                          },
                          isbordervisibal: controller.isSelect.value == 1 ? true : false,
                        );
                      }),
                      16.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          controller: controller.emailController,
                          labelText: AppMessage.email,
                          hintText: AppMessage.enter,
                          readOnly: true,
                          errorText: controller.errorEmail.value,
                          onTap: () {
                            controller.isSelect.value = 2;
                          },
                          textColor: controller.flag == 'editSleepLogs' ? color.editTextColor : color.onboardingTextColor,
                          onChanged: (value) {
                            controller.isSelect.value = 2;
                            controller.errorEmail.value = "";
                          },
                          isbordervisibal: controller.isSelect.value == 2 ? true : false,
                        );
                      }),
                      16.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          controller: controller.timeToSleepingController,
                          labelText: AppMessage.timeToSleeping,
                          hintText: AppMessage.selectTime,
                          readOnly: true,
                          errorText: controller.errorTimeToSleeping.value,
                          onTap: () async {
                            controller.isSelect.value = 3;
                            controller.selectSleepingTime(context);
                          },
                          suffixIcon: Image.asset(
                            icons.timeIcon,
                            color: controller.timeToSleepingController.text.trim().isEmpty ? color.onboardingTextColor : color.black,
                            height: MySize.getScaledSizeHeight(24),
                            width: MySize.getScaledSizeWidth(24),
                          ).paddingSymmetric(vertical: MySize.getScaledSizeHeight(12)),
                          contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(10), left: MySize.getScaledSizeWidth(10)),
                          onChanged: (value) {
                            controller.isSelect.value = 3;
                            controller.errorTimeToSleeping.value = "";
                          },
                          isbordervisibal: controller.isSelect.value == 3 ? true : false,
                        );
                      }),
                      16.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          controller: controller.timeToWakeUpController,
                          labelText: AppMessage.timeToWakeUp,
                          hintText: AppMessage.selectTime,
                          errorText: controller.errorTimeToWakeUp.value,
                          readOnly: true,
                          onTap: () async {
                            controller.isSelect.value = 4;
                            controller.selectToWakeUpTime(context);
                          },
                          suffixIcon: Image.asset(
                            icons.timeIcon,
                            color: controller.timeToWakeUpController.text.trim().isEmpty ? color.onboardingTextColor : color.black,
                            height: MySize.getScaledSizeHeight(24),
                            width: MySize.getScaledSizeWidth(24),
                          ).paddingSymmetric(vertical: MySize.getScaledSizeHeight(12)),
                          contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(10), left: MySize.getScaledSizeWidth(10)),
                          onChanged: (value) {
                            controller.isSelect.value = 4;
                            controller.errorTimeToWakeUp.value = "";
                          },
                          isbordervisibal: controller.isSelect.value == 4 ? true : false,
                        );
                      }),
                      16.0.hSpace(),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                color: color.white,
                child: commonWidget
                    .customButton(
                      isLoading: controller.isLoading.value,
                      text: AppMessage.save,
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        if (controller.isValidation()) {
                          if (controller.flag == 'editSleepLogs') {
                            controller.editSleepLogsApi();
                          } else {
                            controller.addSleepLogsApi();
                          }
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
