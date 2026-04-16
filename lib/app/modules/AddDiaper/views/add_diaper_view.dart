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
import '../../addMenu/model/TeacherAllStudentModel.dart';
import '../controllers/add_diaper_controller.dart';

class AddDiaperView extends GetView<AddDiaperController> {
  const AddDiaperView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddDiaperController>(
      init: AddDiaperController(),
      assignId: true,
      builder: (context) {
        return Scaffold(
          backgroundColor: color.white,
          appBar: commonWidget.appBar(
            titleText: controller.type.value == 'Diaper' ? 'Add Diaper' : 'Add Give Bath',
            backgroundColor: color.transparentColor,
          ),
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: MySize.getScaledSizeHeight(80),
                      width: MySize.getScaledSizeHeight(80),
                      decoration: BoxDecoration(color: color.appColor, shape: BoxShape.circle),
                      child: Icon(controller.type.value == 'Diaper' ? Icons.baby_changing_station : Icons.bathtub, size: 40, color: Colors.white),
                    ),
                  ),
                  12.0.hSpace(),
                  commonText.medium(text: "Student Name", textColor: color.textFieldTextColor, fontSize: MySize.getScaledSizeHeight(14)),
                  12.0.hSpace(),
                  GetBuilder<AddDiaperController>(
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
                          return ListTile(tileColor: color.backgroundColor, title: Text(student.fullName));
                        },
                        onSelected: (TeacherAllStudentData student) {
                          controller.selectStudent(student.fullName);
                          controller.selectStudentId = student.id!;
                        },
                      );
                    },
                  ),
                  12.0.hSpace(),
                  commonText.medium(text: "Categories", textColor: color.textFieldTextColor, fontSize: MySize.getScaledSizeHeight(14)),
                  12.0.hSpace(),
                  GetBuilder<AddDiaperController>(
                    builder: (controller) {
                      return Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonWidget.commonTextField(
                              controller: TextEditingController(text: controller.selectedCategory.value),
                              hintText: "Select Category",
                              errorText: controller.errorCategory.value,
                              suffixIcon: Image.asset(icons.arrowDownIcon2, scale: 4),
                              contentPadding: EdgeInsets.only(
                                  top: MySize.getScaledSizeHeight(12),
                                  left: MySize.getScaledSizeWidth(10)),
                              readOnly: true,
                              onTap: () {
                                controller.isCategoryDropdownOpen.value =
                                !controller.isCategoryDropdownOpen.value;
                                controller.errorCategory.value = "";
                              },
                              isbordervisibal: controller.isCategoryDropdownOpen.value,
                            ),

                            // Dropdown list
                            if (controller.isCategoryDropdownOpen.value)
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                  color: color.backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.categories.length,
                                  itemBuilder: (context, index) {
                                    String category = controller.categories[index];
                                    return ListTile(
                                      title: Text(category),
                                      onTap: () {
                                        controller.selectedCategory.value = category;
                                        controller.isCategoryDropdownOpen.value = false;
                                        controller.errorCategory.value = "";
                                        if (category != "Other") {
                                          controller.otherCategoryController.clear();
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            if (controller.selectedCategory.value == "Other")
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Obx(() {
                                  return commonWidget.commonTextField(
                                    controller: controller.otherCategoryController,
                                    hintText: "Enter reason",
                                    errorText: controller.errorOtherCategory.value,
                                    onTap: () {
                                      controller.isSelect.value = 1;
                                    },
                                    onChanged: (value) {
                                      controller.isSelect.value = 1;
                                      if (controller.otherCategoryController.text.trim().isEmpty) {
                                        controller.errorOtherCategory.value = "Please enter a note";
                                      } else if (controller.otherCategoryController.text.trim().length < 3) {
                                        controller.errorOtherCategory.value = "Note should be at least 3 characters";
                                      } else {
                                        controller.errorOtherCategory.value = "";
                                      }
                                    },
                                    isbordervisibal: controller.isSelect.value == 1,
                                  );
                                }),
                              ),
                          ],
                        );
                      });
                    },
                  ),
                  20.0.hSpace(),


                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(bottom: Platform.isIOS ? MySize.getScaledSizeHeight(15) : 0),
            color: color.white,
            child: Obx(
              () => commonWidget
                  .customButton(
                    isLoading: controller.isLoading.value,
                    text: 'Save',
                    onTap: () {
                      if (controller.isFormValid()) {
                        controller.addDiaperAndBathApi();
                      }
                    },
                  )
                  .paddingAll(MySize.getScaledSizeHeight(16)),
            ),
          ),
        );
      },
    );
  }
}
