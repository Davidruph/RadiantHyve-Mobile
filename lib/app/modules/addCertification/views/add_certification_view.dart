import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import '../controllers/add_certification_controller.dart';

class AddCertificationView extends GetView<AddCertificationController> {
  const AddCertificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddCertificationController>(
      init: AddCertificationController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: color.white,
            appBar: commonWidget.appBar(
              titleText: controller.flag == 'editCertification' ? AppMessage.editCertification : AppMessage.addCertification,
              backgroundColor: color.transparentColor,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonText.medium(
                      text: AppMessage.staffName,
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
                            color: controller.errorSelectStaff.value == '' ? color.onboardingBorderColor : color.textFieldErrorColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            isDense: true,
                            hint: commonText.medium(
                              text: controller.selectedStaff!.value == "" ? "Select" : controller.selectedStaff!.value,
                              textColor: controller.selectedStaff!.value == "" ? color.onboardingTextColor : color.black,
                              fontSize: MySize.getScaledSizeHeight(14),
                            ),
                            items: controller.staffList
                                .map(
                                  (trainer) => DropdownMenuItem(
                                    value: trainer,
                                    child: commonText.medium(
                                      text: trainer.fullName ?? '',
                                      textColor: color.black,
                                      fontSize: MySize.getScaledSizeHeight(14),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              controller.selectedStaff!.value = "${value?.fullName}";
                              controller.staffId.value = value?.id ?? 0;
                              controller.update();
                            },
                            buttonStyleData: ButtonStyleData(height: 54, padding: EdgeInsets.only(left: 14, right: 14)),
                            iconStyleData: IconStyleData(
                              icon: Icon(Icons.keyboard_arrow_down),
                              iconSize: 30,
                              iconEnabledColor: color.black,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
                              elevation: 8,
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: null,
                                thumbVisibility: null,
                              ),
                            ),
                            menuItemStyleData: MenuItemStyleData(height: 40, padding: EdgeInsets.only(left: 10, top: 5, right: 10)),
                          ),
                        ),
                      );
                    }),
                    Obx(() => controller.errorSelectStaff == ''
                        ? SizedBox()
                        : commonText
                            .medium(
                              text: controller.errorSelectStaff.value,
                              fontSize: MySize.getScaledSizeHeight(10),
                              textColor: color.textFieldErrorColor,
                              textAlign: TextAlign.center,
                            )
                            .paddingOnly(top: MySize.getScaledSizeHeight(2))),
                    18.0.hSpace(),
                    // Obx(() {
                    //   return commonWidget.commonTextField(
                    //     inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                    //     keyboardType: TextInputType.text,
                    //     controller: controller.courseNameController,
                    //     labelText: AppMessage.courseName,
                    //     hintText: AppMessage.enterCourseName,
                    //     errorText: controller.errorCourseName.value,
                    //     onTap: () {
                    //       controller.isSelect.value = 0;
                    //     },
                    //     onChanged: (value) {
                    //       controller.isSelect.value = 0;
                    //       controller.errorCourseName.value = "";
                    //     },
                    //     isbordervisibal: controller.isSelect.value == 0 ? true : false,
                    //   );
                    // }),
                    // 18.0.hSpace(),
                    Obx(() {
                      return commonWidget.commonTextField(
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                        keyboardType: TextInputType.text,
                        controller: controller.institutionNameController,
                        labelText: AppMessage.institutionName,
                        hintText: AppMessage.enterInstitutionName,
                        errorText: controller.errorInstitutionName.value,
                        onTap: () {
                          controller.isSelect.value = 1;
                        },
                        onChanged: (value) {
                          controller.isSelect.value = 1;
                          controller.errorInstitutionName.value = "";
                        },
                        isbordervisibal: controller.isSelect.value == 1 ? true : false,
                      );
                    }),
                    18.0.hSpace(),
                    commonText.medium(
                      text: AppMessage.hireCheckList,
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
                            color: controller.errorChecklist == '' ? color.onboardingBorderColor : color.textFieldErrorColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: GetBuilder<AddCertificationController>(
                            builder: (controller) {
                              return DropdownButton<String>(
                                hint: commonText.regular(
                                  text: AppMessage.select,
                                  textColor: color.onboardingTextColor,
                                  fontSize: MySize.getScaledSizeHeight(14),
                                ),
                                dropdownColor: color.white,
                                value: controller.selectedChecklist,
                                icon: Icon(Icons.keyboard_arrow_down, color: color.black, size: 20),
                                borderRadius: BorderRadius.circular(12),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    controller.selectedChecklist = newValue;
                                    controller.errorChecklist.value = '';
                                    controller.update();
                                  }
                                },
                                items: controller.checklistList.map<DropdownMenuItem<String>>((String value) {
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
                    Obx(() => controller.errorChecklist == ''
                        ? SizedBox()
                        : commonText
                            .medium(
                              text: controller.errorChecklist.value,
                              fontSize: MySize.getScaledSizeHeight(10),
                              textColor: color.textFieldErrorColor,
                              textAlign: TextAlign.center,
                            )
                            .paddingOnly(top: MySize.getScaledSizeHeight(2))),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Obx(() {
              return Container(
                color: color.white,
                child: commonWidget
                    .customButton(
                      text: AppMessage.save,
                      isLoading: controller.isLoading.value,
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        if (controller.isValidation()) {
                          if (controller.flag == 'editCertification') {
                            controller.editCertificationApi();
                          } else {
                            controller.addCertificationApi();
                          }
                        }
                      },
                    )
                    .paddingAll(MySize.getScaledSizeHeight(16)),
              );
            }),
          ),
        );
      },
    );
  }
}
