import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/commonWidgets/popup.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import '../controllers/student_edit_profile_controller.dart';

class StudentEditProfileView extends GetView<StudentEditProfileController> {
  const StudentEditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentEditProfileController>(
      init: StudentEditProfileController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: color.white,
            appBar: commonWidget.appBar(
              titleText: controller.flag == 'studentEdit' ? AppMessage.editProfileInformation : AppMessage.addStudent,
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        profileBottomSheet(context: context);
                      },
                      child: Center(
                        child:
                            controller.image.value != ''
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    File(controller.image.value),
                                    height: MySize.getScaledSizeHeight(100),
                                    width: MySize.getScaledSizeHeight(100),
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : controller.studentDetailsData?.profilePic != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    controller.studentDetailsData!.profilePic!,
                                    height: MySize.getScaledSizeHeight(100),
                                    width: MySize.getScaledSizeWidth(100),
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : Image.asset(
                                  images.plashHolderImage,
                                  height: MySize.getScaledSizeHeight(100),
                                  width: MySize.getScaledSizeWidth(100),
                                ),
                      ),
                    ),
                    12.0.hSpace(),
                    GestureDetector(
                      onTap: () {
                        profileBottomSheet(context: context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(icons.editIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
                          06.0.wSpace(),
                          commonText.regular(
                            text: AppMessage.editProfilePicture,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.black,
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () =>
                          controller.errorImage.value != ''
                              ? Center(
                                child: commonText
                                    .medium(
                                      text: controller.errorImage.value,
                                      textColor: color.textFieldErrorColor,
                                      fontSize: MySize.getScaledSizeHeight(10),
                                    )
                                    .paddingOnly(top: MySize.getScaledSizeHeight(5)),
                              )
                              : const SizedBox(),
                    ),
                    20.0.hSpace(),
                    Obx(() {
                      return commonWidget.commonTextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                          FilteringTextInputFormatter.deny(
                            RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                          ),
                        ],
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
                      return commonWidget.customPhoneField(
                        text: AppMessage.phoneNumber,
                        controller: controller.homePhoneNumberController,
                        initialCountryCode: controller.isoCode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(controller.maxLength.value),
                          FilteringTextInputFormatter.deny(
                            RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                          ),
                        ],
                        onCountryChanged: (value) {
                          controller.maxLength.value = value.maxLength;
                          controller.isoCode = value.code;
                          controller.countryCode = value.dialCode;
                        },
                        onChanged: (value) {
                          controller.isSelect.value = 2;
                          if (controller.homePhoneNumberController.text.trim().isEmpty) {
                            controller.errorHomePhoneNumber.value = 'Please enter your mobile number.';
                          } else if (controller.homePhoneNumberController.text.trim().isNotEmpty &&
                              controller.maxLength.value != controller.homePhoneNumberController.text.length) {
                            controller.errorHomePhoneNumber.value = 'Please Enter Valid Mobile Number.';
                          } else {
                            controller.errorHomePhoneNumber.value = '';
                          }
                        },
                        onTap: () {
                          controller.isSelect.value = 2;
                        },
                        errorText: controller.errorHomePhoneNumber.value,
                        isbordervisibal: controller.isSelect.value == 2 ? true : false,
                      );
                    }),
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
                    18.0.hSpace(),
                    commonText.medium(text: AppMessage.gender, textColor: color.textFieldTextColor, fontSize: MySize.getScaledSizeHeight(14)),
                    08.0.hSpace(),
                    Obx(() {
                      return Container(
                        height: MySize.getScaledSizeHeight(48),
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                          border: Border.all(
                            color: controller.errorGender.value == '' ? color.onboardingBorderColor : color.textFieldErrorColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: GetBuilder<StudentEditProfileController>(
                            builder: (controller) {
                              return DropdownButton<String>(
                                hint: commonText.regular(
                                  text: AppMessage.select,
                                  textColor: color.onboardingTextColor,
                                  fontSize: MySize.getScaledSizeHeight(14),
                                ),
                                dropdownColor: color.white,
                                value: controller.selectedGender,
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
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: commonText.medium(text: value, textColor: color.black, fontSize: MySize.getScaledSizeHeight(14)),
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
                          controller.errorGender.value == ''
                              ? SizedBox()
                              : commonText
                                  .medium(
                                    text: controller.errorGender.value,
                                    fontSize: MySize.getScaledSizeHeight(10),
                                    textColor: color.textFieldErrorColor,
                                    textAlign: TextAlign.center,
                                  )
                                  .paddingOnly(top: MySize.getScaledSizeHeight(2)),
                    ),
                    18.0.hSpace(),
                    Obx(() {
                      return commonWidget.commonTextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                          FilteringTextInputFormatter.deny(
                            RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                          ),
                        ],
                        keyboardType: TextInputType.text,
                        controller: controller.relationToChildController,
                        labelText: AppMessage.relationToChild,
                        hintText: 'Enter',
                        errorText: controller.errorRelationToChild.value,
                        onTap: () {
                          controller.isSelect.value = 4;
                        },
                        onChanged: (value) {
                          controller.isSelect.value = 4;
                          controller.errorRelationToChild.value = "";
                        },
                        isbordervisibal: controller.isSelect.value == 4 ? true : false,
                      );
                    }),
                    18.0.hSpace(),
                    commonText.medium(
                      text: AppMessage.frequencyAttendance,
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
                            color: controller.errorFrequencyAttendance.value == '' ? color.onboardingBorderColor : color.textFieldErrorColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: GetBuilder<StudentEditProfileController>(
                            builder: (controller) {
                              return DropdownButton<String>(
                                hint: commonText.regular(
                                  text: AppMessage.select,
                                  textColor: color.onboardingTextColor,
                                  fontSize: MySize.getScaledSizeHeight(14),
                                ),
                                dropdownColor: color.white,
                                value: (controller.selectedShift != null && controller.selectedShift!.value.isNotEmpty)
                                    ? controller.selectedShift!.value
                                    : null,
                                icon: Icon(Icons.keyboard_arrow_down, color: color.black, size: 20),
                                borderRadius: BorderRadius.circular(12),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    controller.selectedShift!.value = newValue;
                                    final selected = controller.getShiftDataList.firstWhere(
                                      (s) => s.shiftName == newValue,
                                    );
                                    controller.shiftId.value = selected.id ?? 0;
                                    controller.errorFrequencyAttendance.value = '';
                                    controller.update();
                                  }
                                },
                                items:
                                    controller.getShiftDataList.map<DropdownMenuItem<String>>((shift) {
                                      return DropdownMenuItem<String>(
                                        value: shift.shiftName.toString(),
                                        child: commonText.medium(text: shift.shiftName.toString(), textColor: color.black, fontSize: MySize.getScaledSizeHeight(14)),
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
                          controller.errorFrequencyAttendance.value == ''
                              ? SizedBox()
                              : commonText
                                  .medium(
                                    text: controller.errorFrequencyAttendance.value,
                                    fontSize: MySize.getScaledSizeHeight(10),
                                    textColor: color.textFieldErrorColor,
                                    textAlign: TextAlign.center,
                                  )
                                  .paddingOnly(top: MySize.getScaledSizeHeight(2)),
                    ),
                    18.0.hSpace(),
                    Obx(() {
                      return commonWidget.commonTextField(
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9-]'))],
                        keyboardType: TextInputType.number,
                        controller: controller.medicalInsuranceNumberController,
                        labelText: AppMessage.medicalInsuranceNumber,
                        hintText: 'Enter',
                        errorText: controller.errorMedicalInsuranceNumber.value,
                        onTap: () {
                          controller.isSelect.value = 5;
                        },
                        onChanged: (value) {
                          controller.isSelect.value = 5;
                          controller.errorMedicalInsuranceNumber.value = "";
                        },
                        isbordervisibal: controller.isSelect.value == 5 ? true : false,
                      );
                    }),
                    18.0.hSpace(),
                    Obx(() {
                      return commonWidget.commonTextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                          ),
                        ],
                        keyboardType: TextInputType.text,
                        controller: controller.addressController,
                        labelText: AppMessage.address,
                        hintText: 'Enter',
                        height: MySize.getScaledSizeHeight(110),
                        maxLines: 4,
                        minLines: 4,
                        errorText: controller.errorAddress.value,
                        onTap: () {
                          controller.isSelect.value = 6;
                        },
                        onChanged: (value) {
                          controller.isSelect.value = 6;
                          controller.errorAddress.value = "";
                        },
                        isbordervisibal: controller.isSelect.value == 6 ? true : false,
                      );
                    }),
                    10.0.hSpace(),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Obx(
              () => commonWidget
                  .customButton(
                    isLoading: controller.isLoading.value,
                    text: AppMessage.save,
                    gradient: color.buttonGradient,
                    onTap: () {
                      if (controller.isValidation()) {
                        if (controller.flag == 'studentEdit') {
                          controller.editStudentApi();
                        } else {
                          controller.addStudentApi();
                        }
                      }
                    },
                  )
                  .paddingAll(MySize.getScaledSizeHeight(16))
                  .paddingOnly(bottom: Platform.isIOS ? MySize.getScaledSizeHeight(15) : 0),
            ),
          ),
        );
      },
    );
  }

  profileBottomSheet({required context}) {
    return commonWidget.bottomSheet(
      child: Column(
        children: [
          16.0.hSpace(),
          InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              Get.back();
              controller.pickMedia(argument: 1);
            },
            child: Row(
              children: [
                Image.asset(icons.cameraIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
                10.0.wSpace(),
                commonText.medium(text: AppMessage.takeAPicture, textColor: color.black, fontSize: MySize.getScaledSizeHeight(14)),
              ],
            ),
          ),
          20.0.hSpace(),
          commonWidget.commonDivider(),
          20.0.hSpace(),
          InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              Get.back();
              controller.pickMedia(argument: 2);
            },
            child: Row(
              children: [
                Image.asset(icons.galleryIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
                10.0.wSpace(),
                commonText.medium(text: AppMessage.selectFromGallery, textColor: color.black, fontSize: MySize.getScaledSizeHeight(14)),
              ],
            ),
          ),
          30.0.hSpace(),
        ],
      ).paddingSymmetric(horizontal: MySize.getScaledSizeWidth(16)),
    );
  }
}
