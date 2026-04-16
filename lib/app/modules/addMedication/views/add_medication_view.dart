import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';

import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../addMenu/model/TeacherAllStudentModel.dart';
import '../controllers/add_medication_controller.dart';

class AddMedicationView extends GetView<AddMedicationController> {
  const AddMedicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddMedicationController>(
      init: AddMedicationController(),
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
                  titleText:
                      controller.flag == 'editMedication'
                          ? AppMessage.editMedication
                          : AppMessage.addMedication,
                  backgroundColor: color.transparentColor,
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        GetBuilder<AddMedicationController>(
                          builder: (controller) {
                            return TypeAheadField<TeacherAllStudentData>(
                              suggestionsCallback: controller.getSuggestionsStudent,
                              builder: (context, textEditingController, focusNode) {
                                textEditingController.text = controller.studentListController.text;
                                return Obx(() {
                                  return commonWidget.commonTextField(
                                    controller: textEditingController,
                                    hintText: AppMessage.selectStudent,
                                    focusNode: focusNode,
                                    errorText: controller.errorStudent.value,
                                    suffixIcon: Image.asset(icons.arrowDownIcon2, scale: 4),
                                    contentPadding: EdgeInsets.only(
                                      top: MySize.getScaledSizeHeight(12),
                                      left: MySize.getScaledSizeWidth(10),
                                    ),
                                    onTap: () {
                                      controller.isSelect.value = 0;
                                    },
                                    onChanged: (value) {
                                      controller.isSelect.value = 0;
                                      controller.errorStudent.value = "";
                                    },
                                    isbordervisibal: controller.isSelect.value == 0 ? true : false,
                                  );
                                });
                              },
                              itemBuilder: (context, TeacherAllStudentData student) {
                                return ListTile(
                                  tileColor: color.backgroundColor,
                                  title: Text(student.fullName),
                                );
                              },
                              onSelected: (TeacherAllStudentData student) {
                                controller.selectStudent(student.fullName);
                                controller.selectStudentId = student.id;
                              },
                            );
                          },
                        ),
                        16.0.hSpace(),
                        Obx(() {
                          return commonWidget.commonTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\n\-]')),
                            ],
                            controller: controller.typeOfDiseaseController,
                            labelText: AppMessage.typeOfDisease,
                            hintText: AppMessage.enter,
                            errorText: controller.errorTypeOfDisease.value,
                            onTap: () async {
                              controller.isSelect.value = 1;
                            },
                            onChanged: (value) {
                              controller.isSelect.value = 1;
                              controller.errorTypeOfDisease.value = "";
                            },
                            onFieldSubmitted: (value) {
                              controller.isSelect.value = 2;
                            },
                            isbordervisibal: controller.isSelect.value == 1 ? true : false,
                          );
                        }),
                        16.0.hSpace(),
                        Obx(() {
                          return commonWidget.commonTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\n\-]')),
                            ],
                            controller: controller.medicationDetailsController,
                            labelText: AppMessage.medicationDetails,
                            hintText: AppMessage.enterMedication,
                            errorText: controller.errorMedicationDetails.value,
                            onTap: () async {
                              controller.isSelect.value = 2;
                            },
                            onFieldSubmitted: (value) {
                              controller.isSelect.value = 3;
                            },
                            onChanged: (value) {
                              controller.isSelect.value = 2;
                              controller.errorMedicationDetails.value = "";
                            },
                            isbordervisibal: controller.isSelect.value == 2 ? true : false,
                          );
                        }),
                        16.0.hSpace(),
                        Obx(() {
                          return commonWidget.commonTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z.\s]')),
                            ],
                            controller: controller.doctorsNameController,
                            labelText: AppMessage.doctorsName,
                            hintText: AppMessage.enterDoctorsName,
                            errorText: controller.errorDoctorsName.value,
                            onTap: () async {
                              controller.isSelect.value = 3;
                            },
                            onChanged: (value) {
                              controller.isSelect.value = 3;

                              controller.errorDoctorsName.value = "";
                            },
                            onFieldSubmitted: (value) {
                              controller.isSelect.value = 4;
                            },
                            isbordervisibal: controller.isSelect.value == 3 ? true : false,
                          );
                        }),
                        16.0.hSpace(),
                        Obx(() {
                          return commonWidget.customPhoneField(
                            text: AppMessage.phoneNumber,
                            controller: controller.doctorsPhoneNumberController,
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
                              controller.isSelect.value = 4;
                              if (controller.doctorsPhoneNumberController.text.trim().isEmpty) {
                                controller.errorPhoneNumber.value =
                                    AppMessage.pleaseEnterYourMobileNumber;
                              } else if (controller.doctorsPhoneNumberController.text.trim().isNotEmpty &&
                                  controller.maxLength.value !=
                                      controller.doctorsPhoneNumberController.text.length) {
                                controller.errorPhoneNumber.value =
                                    AppMessage.pleaseEnterValidMobileNumber;
                              } else {
                                controller.errorPhoneNumber.value = '';
                              }
                            },
                            onTap: () {
                              controller.isSelect.value = 4;
                            },
                            errorText: controller.errorPhoneNumber.value,
                            isbordervisibal: controller.isSelect.value == 4 ? true : false,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  padding: EdgeInsets.only(
                    bottom: Platform.isIOS ? MySize.getScaledSizeHeight(15) : 0,
                  ),
                  color: color.white,
                  child: commonWidget
                      .customButton(
                        isLoading: controller.isLoading.value,
                        text: AppMessage.save,
                        onTap: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          if (controller.isValidation()) {
                            if (controller.flag == 'editMedication') {
                              controller.editMedificationApi();
                            } else {
                              controller.addMedificationApi();
                            }
                          }
                        },
                      )
                      .paddingAll(MySize.getScaledSizeHeight(16)),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
