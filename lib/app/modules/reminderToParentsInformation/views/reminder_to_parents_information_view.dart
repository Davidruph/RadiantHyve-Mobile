import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import '../controllers/reminder_to_parents_information_controller.dart';

class ReminderToParentsInformationView extends GetView<ReminderToParentsInformationController> {
  const ReminderToParentsInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReminderToParentsInformationController>(
      init: ReminderToParentsInformationController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Obx(
            () => IgnorePointer(
              ignoring: controller.isLoading.value,
              child: Scaffold(
                backgroundColor: color.white,
                appBar: commonWidget.appBar(
                  titleText: AppMessage.reminderToParentsInformation,
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
                            textColor: color.onboardingTextColor,
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
                            controller: controller.reminderTitleController,
                            labelText: AppMessage.reminderTitle,
                            hintText: AppMessage.enter,
                            errorText: controller.errorReminderTitle.value,
                            onTap: () {
                              controller.isSelect.value = 1;
                            },
                            onChanged: (value) {
                              controller.isSelect.value = 1;
                              controller.errorReminderTitle.value = "";
                            },
                            isbordervisibal: controller.isSelect.value == 1 ? true : false,
                          );
                        }),
                        16.0.hSpace(),
                        Obx(() {
                          return commonWidget.commonTextField(
                            controller: controller.descriptionController,
                            labelText: AppMessage.description,
                            hintText: AppMessage.enter,
                            errorText: controller.errorDescription.value,
                            height: MySize.getScaledSizeHeight(130),
                            maxLines: 6,
                            minLines: 6,
                            onTap: () {
                              controller.isSelect.value = 2;
                            },
                            onChanged: (value) {
                              controller.isSelect.value = 2;
                              controller.errorDescription.value = "";
                            },
                            isbordervisibal: controller.isSelect.value == 2 ? true : false,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: Obx(
                  () => Container(
                    color: color.white,
                    child: commonWidget
                        .customButton(
                          isLoading: controller.isLoading.value,
                          text: AppMessage.submit,
                          onTap: () {
                            FocusManager.instance.primaryFocus!.unfocus();
                            if (controller.isValidation()) {
                              controller.remainingFeesApi();
                            }
                          },
                        )
                        .paddingAll(MySize.getScaledSizeHeight(16)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
