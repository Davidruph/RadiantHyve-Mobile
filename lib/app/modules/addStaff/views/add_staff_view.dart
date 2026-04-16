import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/commonWidgets/popup.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import '../../../../commonWidgets/CachedImageContainer.dart';
import '../controllers/add_staff_controller.dart';

class AddStaffView extends GetView<AddStaffController> {
  const AddStaffView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddStaffController>(
      init: AddStaffController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: color.white,
            appBar: commonWidget.appBar(
              titleText: controller.flag == 'editStaff' ? AppMessage.editProfileInformation : AppMessage.addStaff,
              backgroundColor: color.transparentColor,
            ),
            body: SingleChildScrollView(
              child: Obx(() {
                return IgnorePointer(
                  ignoring: controller.isLoading.value,
                  child: Padding(
                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*Center(
                          child: controller.image != ''
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    File(controller.image),
                                    height: MySize.getScaledSizeHeight(100),
                                    width: MySize.getScaledSizeHeight(100),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : controller.profile != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        controller.profile,
                                        height: MySize.getScaledSizeHeight(100),
                                        width: MySize.getScaledSizeWidth(100),
                                      ),
                                    )
                                  : Image.asset(
                                      images.plashHolderImage,
                                      height: MySize.getScaledSizeHeight(100),
                                      width: MySize.getScaledSizeWidth(100),
                                    ),
                        ),*/
                        Center(
                          child:
                              controller.image.value != ''
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      File(controller.image.value),
                                      height: MySize.getScaledSizeHeight(80),
                                      width: MySize.getScaledSizeHeight(80),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : controller.staffDetailsData?.profilePic != null
                                  ? CachedImageContainer(
                                    image: controller.staffDetailsData?.profilePic,
                                    fit: BoxFit.cover,
                                    width: MySize.getScaledSizeHeight(86),
                                    height: MySize.getScaledSizeHeight(86),
                                    placeHolder: icons.appIcon,
                                    topCorner: 86,
                                    bottomCorner: 86,
                                  )
                                  : Image.asset(
                                    images.plashHolderImage,
                                    height: MySize.getScaledSizeHeight(100),
                                    width: MySize.getScaledSizeWidth(100),
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
                              controller.image != '' || controller.flag == 'editStaff'
                                  ? Image.asset(icons.editIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24))
                                  : Icon(Icons.add_rounded, size: 24),
                              06.0.wSpace(),
                              commonText.regular(
                                text:
                                    controller.image != '' || controller.flag == 'editStaff'
                                        ? AppMessage.editProfilePicture
                                        : AppMessage.addProfilePicture,
                                fontSize: MySize.getScaledSizeHeight(14),
                                textColor: color.black,
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          return controller.errorImage.value != ''
                              ? Center(
                                child: commonText
                                    .medium(
                                      text: controller.errorImage.value,
                                      textColor: color.textFieldErrorColor,
                                      fontSize: MySize.getScaledSizeHeight(10),
                                    )
                                    .paddingOnly(top: MySize.getScaledSizeHeight(5)),
                              )
                              : const SizedBox();
                        }),
                        20.0.hSpace(),
                        commonText.medium(text: AppMessage.staffInformation, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                        16.0.hSpace(),
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
                              FilteringTextInputFormatter.deny(
                                RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                              ),
                            ],
                            readOnly: controller.flag == 'editStaff' ? true : false,
                            controller: controller.emailController,
                            labelText: AppMessage.email,
                            hintText: AppMessage.enterEmail,
                            errorText: controller.errorEmail.value,
                            onTap: () {
                              controller.isSelect.value = 1;
                            },
                            textColor: controller.flag == 'editStaff' ? color.editTextColor : color.black,
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
                              if (controller.phoneNumberController.text.trim().isEmpty) {
                                controller.errorPhoneNumber.value = AppMessage.pleaseEnterYourMobileNumber;
                              } else if (controller.phoneNumberController.text.trim().isNotEmpty &&
                                  controller.maxLength.value != controller.phoneNumberController.text.length) {
                                controller.errorPhoneNumber.value = AppMessage.pleaseEnterValidMobileNumber;
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
                        8.0.hSpace(),
                        commonText.medium(text: AppMessage.gender, textColor: color.textFieldTextColor, fontSize: MySize.getScaledSizeHeight(14)),
                        08.0.hSpace(),
                        Obx(() {
                          return Container(
                            height: MySize.getScaledSizeHeight(48),
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                              border: Border.all(color: controller.errorGender == '' ? color.onboardingBorderColor : color.textFieldErrorColor),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: GetBuilder<AddStaffController>(
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
                              controller.errorGender == ''
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
                                controller.errorDateOfBirth.value = AppMessage.pleaseSelectYourBirthDate;
                              } else {
                                controller.errorDateOfBirth.value = "";
                              }
                              controller.update();
                            },
                            isbordervisibal: controller.isSelect.value == 3 ? true : false,
                          );
                        }),
                        /*18.0.hSpace(),
                      commonText.medium(
                        text: AppMessage.subject,
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
                            border: Border.all(color: controller.errorSubject == '' ? color.onboardingBorderColor : color.textFieldErrorColor),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: GetBuilder<AddStaffController>(
                              builder: (controller) {
                                return DropdownButton<String>(
                                  hint: commonText.regular(
                                    text: AppMessage.select,
                                    textColor: color.onboardingTextColor,
                                    fontSize: MySize.getScaledSizeHeight(14),
                                  ),
                                  dropdownColor: color.white,
                                  value: controller.selectedSubject,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: color.black,
                                    size: 20,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      controller.selectedSubject = newValue;
                                      controller.errorSubject.value = '';
                                      controller.update();
                                    }
                                  },
                                  items: controller.subjectList.map<DropdownMenuItem<String>>((String value) {
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
                        () => controller.errorSubject == ''
                            ? SizedBox()
                            : commonText
                                .medium(
                                  text: controller.errorSubject.value,
                                  fontSize: MySize.getScaledSizeHeight(10),
                                  textColor: color.textFieldErrorColor,
                                  textAlign: TextAlign.center,
                                )
                                .paddingOnly(
                                  top: MySize.getScaledSizeHeight(2),
                                ),
                      ),*/
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
                              controller.isSelect.value = 5;
                            },
                            onChanged: (value) {
                              controller.isSelect.value = 5;
                              controller.errorExperience.value = "";
                            },
                            isbordervisibal: controller.isSelect.value == 5 ? true : false,
                          );
                        }),
                        18.0.hSpace(),
                        Obx(() {
                          return commonWidget.commonTextField(
                            keyboardType: TextInputType.text,
                            controller: controller.aboutStaffController,
                            labelText: AppMessage.aboutStaff,
                            hintText: 'Enter',
                            height: MySize.getScaledSizeHeight(110),
                            maxLines: 4,
                            minLines: 4,
                            errorText: controller.errorAboutStaff.value,
                            onTap: () {
                              controller.isSelect.value = 6;
                            },
                            onChanged: (value) {
                              controller.isSelect.value = 6;
                              controller.errorAboutStaff.value = "";
                            },
                            isbordervisibal: controller.isSelect.value == 6 ? true : false,
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),
            ),
            bottomNavigationBar: Obx(() {
              return commonWidget.customButton(
                text: AppMessage.save,
                isLoading: controller.isLoading,
                onTap: () {
                  if (controller.isValidation()) {
                    if (controller.flag == 'editStaff') {
                      controller.editProfileApi();
                    } else {
                      controller.addStaffApi();
                    }
                  }
                },
              );
            }).paddingAll(MySize.getScaledSizeHeight(16)),
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
