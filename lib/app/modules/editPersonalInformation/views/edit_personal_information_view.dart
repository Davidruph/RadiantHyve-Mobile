import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/edit_personal_information_controller.dart';

class EditPersonalInformationView extends GetView<EditPersonalInformationController> {
  const EditPersonalInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditPersonalInformationController>(
      init: EditPersonalInformationController(),
      assignId: true,
      builder: (controller) {
        return Obx(() {
          return IgnorePointer(
            ignoring: controller.isLoading.value,
            child: Scaffold(
              backgroundColor: color.white,
              appBar: commonWidget.appBar(
              titleText: AppMessage.editPersonalInformation,
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
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                          keyboardType: TextInputType.text,
                          controller: controller.fullNameController,
                          labelText: AppMessage.fullName,
                          hintText: AppMessage.enterFullName,
                          errorText: controller.errorFullName.value,
                          onTap: () {
                            controller.isSelect.value = 0;
                          },
                          onChanged: (value) {
                            controller.isSelect.value = 0;
                            controller.errorFullName.value = "";
                          },
                          isbordervisibal: controller.isSelect.value == 0 ? true : false,
                        );
                      }),
                      18.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                          ],
                          readOnly: true,
                          controller: controller.emailController,
                          labelText: AppMessage.email,
                          hintText: AppMessage.enterEmail,
                          errorText: controller.errorEmail.value,
                          onTap: () {
                            controller.isSelect.value = 1;
                          },
                          textColor: color.editTextColor,
                          onChanged: (value) {
                            controller.isSelect.value = 1;
                            if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(controller.emailController.text)) {
                              controller.errorEmail.value = AppMessage.pleaseEnterValidEmail;
                            } else {
                              controller.errorEmail.value = "";
                            }
                          },
                          isbordervisibal: controller.isSelect.value == 1 ? true : false,
                        );
                      }),
                      18.0.hSpace(),
                      Obx(() {
                        return commonWidget.customPhoneField(
                          text: AppMessage.phoneNumber,
                          controller: controller.phoneNumberController,
                          initialCountryCode: controller.isoCode,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(controller.maxLength.value),
                            FilteringTextInputFormatter.deny(
                              RegExp(
                                  r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                            ),
                          ],
                          onCountryChanged: (value) {
                            controller.maxLength.value = value.maxLength;
                            controller.isoCode = value.code;
                            controller.countryCode = value.dialCode;
                          },
                          onChanged: (value) {
                            controller.isSelect.value = 2;
                            if (controller.phoneNumberController.text.trim().isEmpty) {
                              controller.errorPhoneNumber.value =
                                  AppMessage.pleaseEnterYourMobileNumber;
                            } else if (controller.phoneNumberController.text.trim().isNotEmpty &&
                                controller.maxLength.value !=
                                    controller.phoneNumberController.text.length) {
                              controller.errorPhoneNumber.value =
                                  AppMessage.pleaseEnterValidMobileNumber;
                            } else {
                              controller.errorPhoneNumber.value = '';
                            }
                          },
                          onTap: () {
                            controller.isSelect.value = 2;
                          },
                          errorText: controller.errorPhoneNumber.value,
                          isbordervisibal: controller.isSelect.value == 2 ? true : false,
                        );
                      }),
                      08.0.hSpace(),
                      commonText.medium(text: AppMessage.gender, textColor: color.textFieldTextColor, fontSize: MySize.getScaledSizeHeight(14)),
                      08.0.hSpace(),
                      Obx(() {
                        return Container(
                          height: MySize.getScaledSizeHeight(48),
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                            border: Border.all(color: controller.errorGender.value == '' ? color.onboardingBorderColor : color.textFieldErrorColor),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: GetBuilder<EditPersonalInformationController>(
                              builder: (controller) {
                                return DropdownButton<String>(
                                  hint: commonText.regular(text: AppMessage.select, textColor: color.onboardingTextColor, fontSize: MySize.getScaledSizeHeight(14)),
                                  dropdownColor: color.white,
                                  value: controller.genderList.contains(controller.selectedGender) ? controller.selectedGender : null,
                                  icon: Icon(Icons.keyboard_arrow_down, color: color.black, size: 20),
                                  borderRadius: BorderRadius.circular(12),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      controller.selectedGender = newValue;
                                      controller.errorGender.value = '';
                                      controller.update();
                                    }
                                  },
                                  items:
                                      controller.genderList.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(value: value, child: commonText.medium(text: value, textColor: color.black, fontSize: MySize.getScaledSizeHeight(14)));
                                      }).toList(),
                                );
                              },
                            ),
                          ).paddingSymmetric(horizontal: MySize.getScaledSizeHeight(10)),
                        );
                      }),
                      Obx(
                        () =>
                            controller.errorGender.value == ''
                                ? SizedBox()
                                : commonText
                                    .medium(text: controller.errorGender.value, fontSize: MySize.getScaledSizeHeight(10), textColor: color.textFieldErrorColor, textAlign: TextAlign.center)
                                    .paddingOnly(top: MySize.getScaledSizeHeight(2)),
                      ),
                      18.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          readOnly: true,
                          controller: controller.dateOfBirthController,
                          labelText: AppMessage.dateOfBirth,
                          hintText: AppMessage.selectDateOfBirth,
                          errorText: controller.errorDateOfBirth.value,
                          suffixIcon: Image.asset(icons.calendarIcon, scale: 4),
                          contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(12), left: MySize.getScaledSizeWidth(10)),
                          onTap: () {
                            // FocusScope.of(context).requestFocus(FocusNode());
                            controller.isSelect.value = 3;
                            FocusScope.of(context).unfocus();
                            controller.dateOfBirthCalendar(context);
                            controller.update();
                          },
                          onChanged: (value) {
                            controller.isSelect.value = 3;
                            if (controller.dateOfBirthController.text.isEmpty) {
                              controller.errorDateOfBirth.value = "Please select your birth date.";
                            } else {
                              controller.errorDateOfBirth.value = "";
                            }
                            controller.update();
                          },
                          isbordervisibal: controller.isSelect.value == 3 ? true : false,
                        );
                      }),

                      // 18.0.hSpace(),
                      // commonText.medium(
                      //   text: AppMessage.subject,
                      //   textColor: color.textFieldTextColor,
                      //   fontSize: MySize.getScaledSizeHeight(14),
                      // ),
                      // 08.0.hSpace(),
                      // Obx(() {
                      //   return Container(
                      //     height: MySize.getScaledSizeHeight(48),
                      //     width: Get.width,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                      //       border: Border.all(color: controller.errorSubject.value == '' ? color.onboardingBorderColor : color.textFieldErrorColor),
                      //     ),
                      //     child: DropdownButtonHideUnderline(
                      //       child: GetBuilder<EditPersonalInformationController>(
                      //         builder: (controller) {
                      //           return DropdownButton<String>(
                      //             hint: commonText.regular(
                      //               text: AppMessage.select,
                      //               textColor: color.onboardingTextColor,
                      //               fontSize: MySize.getScaledSizeHeight(14),
                      //             ),
                      //             dropdownColor: color.white,
                      //             value: controller.selectedSubject,
                      //             icon: Icon(
                      //               Icons.keyboard_arrow_down,
                      //               color: color.black,
                      //               size: 20,
                      //             ),
                      //             borderRadius: BorderRadius.circular(12),
                      //             onChanged: (String? newValue) {
                      //               if (newValue != null) {
                      //                 controller.selectedSubject = newValue;
                      //                 controller.errorSubject.value = '';
                      //                 controller.update();
                      //               }
                      //             },
                      //             items: controller.subjectList.map<DropdownMenuItem<String>>((String value) {
                      //               return DropdownMenuItem<String>(
                      //                 value: value,
                      //                 child: commonText.medium(
                      //                   text: value,
                      //                   textColor: color.black,
                      //                   fontSize: MySize.getScaledSizeHeight(14),
                      //                 ),
                      //               );
                      //             }).toList(),
                      //           );
                      //         },
                      //       ),
                      //     ).paddingSymmetric(horizontal: MySize.getScaledSizeHeight(10)),
                      //   );
                      // }),
                      // Obx(
                      //       () => controller.errorSubject == ''
                      //       ? SizedBox()
                      //       : commonText
                      //       .medium(
                      //     text: controller.errorSubject.value,
                      //     fontSize: MySize.getScaledSizeHeight(10),
                      //     textColor: color.textFieldErrorColor,
                      //     textAlign: TextAlign.center,
                      //   )
                      //       .paddingOnly(
                      //     top: MySize.getScaledSizeHeight(2),
                      //   ),
                      // ),
                      18.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          readOnly: true,
                          controller: controller.joiningDateController,
                          labelText: AppMessage.joiningDate,
                          hintText: AppMessage.select,
                          errorText: controller.errorJoiningDate.value,
                          suffixIcon: Image.asset(icons.calendarIcon, scale: 4),
                          contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(12), left: MySize.getScaledSizeWidth(10)),
                          onTap: () {
                            // FocusScope.of(context).requestFocus(FocusNode());
                            controller.isSelect.value = 4;
                            FocusScope.of(context).unfocus();
                            controller.JoiningDateCalendar(context);
                            controller.update();
                          },
                          onChanged: (value) {
                            controller.isSelect.value = 4;
                            if (controller.joiningDateController.text.isNotEmpty) {
                              controller.errorJoiningDate.value = "";
                            }
                          },
                          isbordervisibal: controller.isSelect.value == 4 ? true : false,
                        );
                      }),
                      18.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'))],
                          keyboardType: TextInputType.text,
                          controller: controller.experienceController,
                          labelText: AppMessage.experience,
                          hintText: AppMessage.enterExperience,
                          errorText: controller.errorExperience.value,
                          onTap: () {
                            controller.isSelect.value = 6;
                          },
                          onChanged: (value) {
                            controller.isSelect.value = 6;
                            controller.errorExperience.value = "";
                          },
                          isbordervisibal: controller.isSelect.value == 6 ? true : false,
                        );
                      }),
                      // 18.0.hSpace(),
                      // commonText.medium(text: AppMessage.shiftSchedule, textColor: color.textFieldTextColor, fontSize: MySize.getScaledSizeHeight(14)),
                      // 08.0.hSpace(),
                      // Obx(() {
                      //   return Container(
                      //     height: MySize.getScaledSizeHeight(48),
                      //     width: Get.width,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                      //       border: Border.all(color: controller.errorShift.value == '' ? color.onboardingBorderColor : color.textFieldErrorColor),
                      //     ),
                      //     child: DropdownButtonHideUnderline(
                      //       child: GetBuilder<EditPersonalInformationController>(
                      //         builder: (controller) {
                      //           return DropdownButton<String>(
                      //             hint: commonText.regular(text: AppMessage.select, textColor: color.onboardingTextColor, fontSize: MySize.getScaledSizeHeight(14)),
                      //             dropdownColor: color.white,
                      //             value: controller.selectedShift,
                      //             icon: Icon(Icons.keyboard_arrow_down, color: color.black, size: 20),
                      //             borderRadius: BorderRadius.circular(12),
                      //             onChanged: (String? newValue) {
                      //               if (newValue != null) {
                      //                 controller.selectedShift = newValue;
                      //                 controller.errorShift.value = '';
                      //                 controller.update();
                      //               }
                      //             },
                      //             items:
                      //                 controller.shiftList.map<DropdownMenuItem<String>>((String value) {
                      //                   return DropdownMenuItem<String>(value: value, child: commonText.medium(text: value, textColor: color.black, fontSize: MySize.getScaledSizeHeight(14)));
                      //                 }).toList(),
                      //           );
                      //         },
                      //       ),
                      //     ).paddingSymmetric(horizontal: MySize.getScaledSizeHeight(10)),
                      //   );
                      // }),
                      // Obx(
                      //   () =>
                      //       controller.errorShift == ''
                      //           ? SizedBox()
                      //           : commonText
                      //               .medium(text: controller.errorShift.value, fontSize: MySize.getScaledSizeHeight(10), textColor: color.textFieldErrorColor, textAlign: TextAlign.center)
                      //               .paddingOnly(top: MySize.getScaledSizeHeight(2)),
                      // ),
                      18.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          keyboardType: TextInputType.text,
                          controller: controller.aboutStaffController,
                          labelText: AppMessage.aboutStaff,
                          hintText: 'Enter',
                          height: MySize.getScaledSizeHeight(110),
                          maxLines: 5,
                          minLines: 5,
                          errorText: controller.errorAboutStaff.value,
                          onTap: () {
                            controller.isSelect.value = 7;
                          },
                          onChanged: (value) {
                            controller.isSelect.value = 7;
                            controller.errorAboutStaff.value = "";
                          },
                          isbordervisibal: controller.isSelect.value == 7 ? true : false,
                        );
                      }),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                padding: EdgeInsets.only(bottom: Platform.isIOS ? MySize.getScaledSizeHeight(15) : 0),
                child: commonWidget
                    .customButton(
                      isLoading: controller.isLoading.value,
                      text: AppMessage.save,
                      gradient: color.buttonGradient,
                      onTap: () {
                        if (controller.isValidation()) {
                          controller.editAccountApi(context: context);
                        }
                      },
                    )
                    .paddingAll(MySize.getScaledSizeHeight(16)),
              ),
            ),
          );
        });
      },
    );
  }
}
