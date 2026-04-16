
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import '../controllers/emergency_controller.dart';

class EmergencyView extends GetView<EmergencyController> {
  const EmergencyView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmergencyController>(
      init: EmergencyController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            controller.selectedEmergency.value = false;
          },
          child: Scaffold(
            backgroundColor: color.backgroundColor,
            appBar: commonWidget.appBar(
              titleText: AppMessage.emergency,
              backgroundColor: color.transparentColor,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.black),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonText.regular(
                    text: AppMessage.emergencySituation,
                    fontSize: MySize.getScaledSizeHeight(14),
                    textColor: color.textFieldTextColor,
                  ),
                  08.0.hSpace(),
                  Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.selectedEmergency.value = !controller.selectedEmergency.value;
                          },
                          child: Container(
                            height: MySize.getScaledSizeHeight(48),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: controller.errorEmergency.value == '' ? color.onboardingBorderColor : color.textFieldErrorColor,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(MySize.getScaledSizeHeight(8)),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                commonText.medium(
                                  text: controller.selectedEmergencyOptions.value,
                                  textColor: controller.selectedEmergencyOptions.value == 'Select' ? color.onboardingTextColor : color.black,
                                  fontSize: MySize.getScaledSizeHeight(14),
                                ),
                                Image.asset(
                                  controller.selectedEmergency.value ? icons.upArrowIcon : icons.downArrowIcon,
                                  scale: 4.0,
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// dropdown list show only if selectedEmergency = true
                        if (controller.selectedEmergency.value)
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: color.onboardingBorderColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: controller.GetSosModelDataList.map((item) {
                                return InkWell(
                                  onTap: () {
                                    controller.selectedEmergencyOptions.value = item.sosName ?? '';
                                    controller.sosId.value = item.id ?? 0;
                                    controller.selectedEmergency.value = false;
                                    log('controller.sosId.value===>${item.id}');
                                    log('controller.sosName.value===>${item.sosName}');
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: MySize.getScaledSizeWidth(15)),
                                    child: commonText.medium(
                                      text: item.sosName ?? '',
                                      textColor: color.black,
                                      fontSize: MySize.getScaledSizeHeight(14),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    );
                  }),

                  16.0.hSpace(),
                  Obx(() => controller.selectedEmergencyOptions.value == 'Select'
                      ? commonText.medium(
                          text: controller.errorEmergency.value,
                          textColor: color.textFieldErrorColor,
                          fontSize: MySize.getScaledSizeHeight(10),
                        )
                      : const SizedBox()),
                ],
              ),
            ),
            bottomNavigationBar: Obx(() => commonWidget
                .customButton(
                  isLoading: controller.isLoading.value,
                  text: AppMessage.submit,
                  onTap: () {
                    if (controller.isValidation()) {
                      controller.createSosApi();
                    }
                  },
                )
                .paddingAll(MySize.getScaledSizeHeight(16))),
          ),
        );
      },
    );
  }
}
