import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/add_menu_controller.dart';
import '../model/TeacherAllStudentModel.dart';

class AddMenuView extends GetView<AddMenuController> {
  const AddMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddMenuController>(
      init: AddMenuController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Obx(() {
            return IgnorePointer(
              ignoring: controller.isLoading.value,
              child: Scaffold(
                backgroundColor: color.white,
                appBar: commonWidget.appBar(
                  titleText: controller.flag == 'editMenu' ? AppMessage.editMenu : AppMessage.addMenu,
                  backgroundColor: color.transparentColor,
                ),
                body: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        controller.flag == 'editMenu'
                            ? SizedBox()
                            : commonText
                                .regular(
                                  text: AppMessage.addTheMenuInformationAndEnsureAllDetailsAreAccurate,
                                  textColor: color.addMenuColor,
                                  fontSize: MySize.getScaledSizeHeight(16),
                                )
                                .paddingOnly(bottom: MySize.getScaledSizeHeight(16)),
                        GetBuilder<AddMenuController>(
                          builder: (controller) {
                            return TypeAheadField<String>(
                              suggestionsCallback: controller.getSuggestions,
                              builder: (context, textEditingController, focusNode) {
                                textEditingController.text = controller.mealController.text;
                                return Obx(() {
                                  return commonWidget.commonTextField(
                                    controller: textEditingController,
                                    labelText: AppMessage.thisMenuIsMeantForWhichMeal,
                                    hintText: AppMessage.selectMeal,
                                    focusNode: focusNode,
                                    errorText: controller.errorMeal.value,
                                    suffixIcon: Image.asset(icons.arrowDownIcon2, scale: 4),
                                    contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(12), left: MySize.getScaledSizeWidth(10)),
                                    onTap: () {
                                      controller.isSelect.value = 0;
                                    },
                                    onChanged: (value) {
                                      controller.isSelect.value = 0;
                                      controller.errorMeal.value = "";
                                    },
                                    isbordervisibal: controller.isSelect.value == 0 ? true : false,
                                  );
                                });
                              },
                              itemBuilder: (context, String meal) {
                                return ListTile(
                                  tileColor: color.backgroundColor,
                                  title: commonText.medium(text: meal, fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                                );
                              },
                              onSelected: (String meal) {
                                controller.selectMeal(meal);
                                controller.update();
                              },
                            );
                          },
                        ),
                        16.0.hSpace(),
                        commonText.regular(
                          text: AppMessage.whenWouldYouLikeToServeTheMenu,
                          textColor: color.textFieldTextColor,
                          fontSize: MySize.getScaledSizeHeight(14),
                        ),
                        08.0.hSpace(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Obx(() {
                                return commonWidget.commonTextField(
                                  readOnly: true,
                                  controller: controller.dateController,
                                  hintText: AppMessage.selectDate,
                                  errorText: controller.errorDate.value,
                                  suffixIcon: Image.asset(icons.calendarIcon, scale: 4),
                                  contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(12), left: MySize.getScaledSizeWidth(10)),
                                  onTap: () {
                                    controller.isSelect.value = 1;
                                    FocusScope.of(context).unfocus();
                                    controller.dateOfBirthCalendar(context);
                                    controller.update();
                                  },
                                  onChanged: (value) {
                                    controller.isSelect.value = 1;
                                    if (controller.dateController.text.isEmpty) {
                                      controller.errorDate.value = AppMessage.pleaseSelectYourDate;
                                    } else {
                                      controller.errorDate.value = "";
                                    }
                                    controller.update();
                                  },
                                  isbordervisibal: controller.isSelect.value == 1 ? true : false,
                                );
                              }),
                            ),
                            09.0.wSpace(),
                            Expanded(
                              child: Obx(() {
                                return commonWidget.commonTextField(
                                  readOnly: true,
                                  controller: controller.timeController,
                                  hintText: AppMessage.selectTime,
                                  errorText: controller.errorTime.value,
                                  onTap: () async {
                                    controller.isSelect.value = 2;
                                    controller.selectTime(context);
                                  },
                                  suffixIcon: Image.asset(icons.timeIcon, scale: 4),
                                  contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(12), left: MySize.getScaledSizeWidth(10)),
                                  onChanged: (value) {
                                    controller.isSelect.value = 2;
                                    controller.errorTime.value = '';
                                    controller.update();
                                  },
                                  isbordervisibal: controller.isSelect.value == 2 ? true : false,
                                );
                              }),
                            ),
                          ],
                        ),
                        16.0.hSpace(),
                        Obx(() {
                          return commonWidget.commonTextField(
                            controller: controller.aboutMealController,
                            labelText: AppMessage.WhatWouldYouLikeToAdd,
                            hintText: AppMessage.aboutMeal,
                            errorText: controller.errorAboutMeal.value,
                            height: MySize.getScaledSizeHeight(130),
                            maxLines: 6,
                            minLines: 6,
                            onTap: () {
                              controller.isSelect.value = 3;
                            },
                            onChanged: (value) {
                              controller.isSelect.value = 3;
                              controller.errorAboutMeal.value = "";
                            },
                            isbordervisibal: controller.isSelect.value == 3 ? true : false,
                          );
                        }),
                        16.0.hSpace(),
                        commonText.regular(
                          text: AppMessage.selectYourWeeklySchedule,
                          textColor: color.textFieldTextColor,
                          fontSize: MySize.getScaledSizeHeight(14),
                        ),
                        12.0.hSpace(),
                        Obx(
                              () =>
                          controller.errorDay.value == ''
                              ? SizedBox()
                              : commonText
                              .medium(
                            text: controller.errorDay.value,
                            fontSize: MySize.getScaledSizeHeight(10),
                            textColor: color.textFieldErrorColor,
                            textAlign: TextAlign.center,
                          )
                              .paddingOnly(top: MySize.getScaledSizeHeight(4)),
                        ),
                        16.0.hSpace(),
                        commonText.regular(
                          text: AppMessage.whichStudentIsThisMenuFor,
                          textColor: color.textFieldTextColor,
                          fontSize: MySize.getScaledSizeHeight(14),
                        ),
                        12.0.hSpace(),
                        controller.isChecked
                            ? Container(
                          height: MySize.getScaledSizeHeight(48),
                          decoration: BoxDecoration(
                            border: Border.all(color: color.onboardingBorderColor),
                            borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                          ),
                          child: Row(
                            children: [
                              commonText
                                  .medium(text: AppMessage.allStudent, textColor: color.black, fontSize: MySize.getScaledSizeHeight(14))
                                  .paddingOnly(left: MySize.getScaledSizeHeight(16)),
                            ],
                          ),
                        )
                            : GetBuilder<AddMenuController>(
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
                                    contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(12), left: MySize.getScaledSizeWidth(10)),
                                    onTap: () {
                                      controller.isSelect.value = 4;
                                    },
                                    onChanged: (value) {
                                      controller.isSelect.value = 4;
                                      controller.errorStudent.value = "";
                                    },
                                    isbordervisibal: controller.isSelect.value == 4 ? true : false,
                                  );
                                });
                              },
                              itemBuilder: (context, TeacherAllStudentData student) {
                                return ListTile(tileColor: color.backgroundColor, title: Text(student.fullName));
                              },
                              onSelected: (TeacherAllStudentData student) {
                                controller.selectStudent(student.fullName);
                                controller.selectStudentId = student.id;
                              },
                            );
                          },
                        ),

                        16.0.hSpace(),
                        GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            controller.isChecked = !controller.isChecked;
                            controller.update();
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                controller.isChecked ? icons.checkIcon : icons.unCheckIcon,
                                height: MySize.getScaledSizeHeight(24),
                                width: MySize.getScaledSizeWidth(24),
                              ),
                              08.0.wSpace(),
                              commonText.regular(
                                text: AppMessage.allStudent,
                                fontSize: MySize.getScaledSizeHeight(14),
                                textColor: color.textFieldTextColor,
                              ),
                            ],
                          ),
                        ),
                        12.0.hSpace(),
                        GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            mainAxisExtent: MySize.getScaledSizeHeight(38),
                          ),
                          itemCount: controller.weeklyScheduleList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                controller.weeklyScheduleList[index]['isSelect'] = !controller.weeklyScheduleList[index]['isSelect'];
                                controller.errorDay.value = '';
                                controller.update(); // Update UI
                              },
                              child: Container(
                                height: MySize.getScaledSizeHeight(38),
                                width: MySize.getScaledSizeHeight(80),
                                decoration: BoxDecoration(
                                  color: controller.weeklyScheduleList[index]['isSelect'] ? color.appColor : color.backgroundColor,
                                  border: Border.all(
                                    color: controller.weeklyScheduleList[index]['isSelect'] ? color.appColor : color.onboardingBorderColor,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                                ),
                                child: Center(
                                  child: commonText.regular(
                                    text: controller.weeklyScheduleList[index]['day'],
                                    fontSize: MySize.getScaledSizeHeight(14),
                                    textColor: controller.weeklyScheduleList[index]['isSelect'] ? color.white : color.onboardingTextColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

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
                        gradient: color.buttonGradient,
                        onTap: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          if (controller.isValidation()) {
                            if (controller.flag == 'editMenu') {
                              controller.editMenuApi();
                            } else {
                              controller.addMenuApi();
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
          }),
        );
      },
    );
  }
}
