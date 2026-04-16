import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/studentDetails/views/student_details_view.dart';
import 'package:radianthyve_unified/commonWidgets/NoData.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../../../../commonWidgets/constant.dart';
import '../controllers/assigned_student_controller.dart';

class AssignedStudentView extends GetView<AssignedStudentController> {
  const AssignedStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssignedStudentController>(
      init: AssignedStudentController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: color.backgroundColor,
            appBar: commonWidget.appBar(
              titleText: AppMessage.assignedStudent,
              backgroundColor: color.transparentColor,
            ),
            body: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)),
                            color: color.onboardingBorderColor,
                          ),
                          child: TextField(
                            cursorColor: color.black,
                            controller: controller.searchController0,
                            onChanged: (value) {
                              if (controller.searchController0.text.isEmpty) {
                                controller.debounceSearch(value);
                              }
                            },
                            onSubmitted: (value) {
                              controller.page = 1;
                              controller.getAssignStudentApi();
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.deny(
                                RegExp(
                                  r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
                                ),
                              ),
                            ],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: MySize.getScaledSizeWidth(16),
                                vertical: MySize.getScaledSizeHeight(14),
                              ),
                              hintText: AppMessage.search,
                              border: InputBorder.none,
                              prefixIcon: Image.asset(icons.searchIcon, scale: 4.0),
                              suffixIcon: controller.searchController0.text != ''
                                  ? GestureDetector(
                                      onTap: () {
                                        controller.searchController0.clear();
                                        controller.getAssignStudentApi();
                                        controller.update();
                                      },
                                      child:
                                          Icon(Icons.close_rounded, size: 24, color: color.black),
                                    )
                                  : SizedBox(),
                              hintStyle: TextStyle(
                                fontSize: MySize.getScaledSizeHeight(14),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Regular',
                                color: color.onboardingTextColor,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: MySize.getScaledSizeHeight(14),
                              color: color.black,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      12.0.wSpace(),
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          filterBottomSheet(context: context);
                        },
                        child: Container(
                          height: MySize.getScaledSizeHeight(48),
                          width: MySize.getScaledSizeWidth(48),
                          decoration: BoxDecoration(
                            color: color.onboardingBorderColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(MySize.getScaledSizeHeight(12)),
                            child: Image.asset(icons.filterIcon),
                          ),
                        ),
                      ),
                    ],
                  ),
                  15.0.hSpace(),
                  Obx(() {
                    return Expanded(
                      child: RefreshIndicator(
                        displacement: 50,
                        backgroundColor: color.white,
                        color: color.appColor,
                        strokeWidth: 3,
                        onRefresh: () async {
                          controller.page = 1;
                          controller.hasNextPage.value = true;
                          controller.getAssignStudentApi();
                        },
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                          child: Column(
                            children: [
                              controller.isLoading.value
                                  ? ListView.separated(
                                      itemCount: 5,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      separatorBuilder: (_, __) => 16.0.hSpace(),
                                      itemBuilder: (context, index) => diagonalShimmer(
                                        height: MySize.getScaledSizeHeight(205),
                                        width: Get.width,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    )
                                  : controller.getAssignStudentDataList.isEmpty
                                      ? NoData(height: Get.height / 1.5)
                                      : ListView.separated(
                                          itemCount: controller.getAssignStudentDataList.length,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          separatorBuilder: (_, __) => 16.0.hSpace(),
                                          itemBuilder: (context, index) {
                                            final student =
                                                controller.getAssignStudentDataList[index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: color.white,
                                                borderRadius: BorderRadius.circular(
                                                    MySize.getScaledSizeHeight(8)),
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: MySize.getScaledSizeHeight(12),
                                                      vertical: MySize.getScaledSizeHeight(15),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        commonText.medium(
                                                          text: student.fullName,
                                                          fontSize: MySize.getScaledSizeHeight(16),
                                                          textColor: color.black,
                                                        ),
                                                        commonText.medium(
                                                          text: student.id.toString(),
                                                          fontSize: MySize.getScaledSizeHeight(16),
                                                          textColor: color.black,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  commonWidget.commonDivider(
                                                      color: color.dividerColor),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: MySize.getScaledSizeHeight(12),
                                                      vertical: MySize.getScaledSizeHeight(14),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            commonText.regular(
                                                              text: AppMessage.parentsName,
                                                              fontSize:
                                                                  MySize.getScaledSizeHeight(14),
                                                              textColor: color.textFieldTextColor,
                                                            ),
                                                            commonText.medium(
                                                              text: student.parentName,
                                                              fontSize:
                                                                  MySize.getScaledSizeHeight(14),
                                                              textColor: color.black,
                                                            ),
                                                          ],
                                                        ),
                                                        16.0.hSpace(),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            commonText.regular(
                                                              text: AppMessage.frequencyAttendance,
                                                              fontSize:
                                                                  MySize.getScaledSizeHeight(14),
                                                              textColor: color.textFieldTextColor,
                                                            ),
                                                            SizedBox(width: 10),
                                                            Expanded(
                                                              child: Align(
                                                                alignment: Alignment.centerRight,
                                                                child: commonText.medium(
                                                                  text: student.fullName,
                                                                  fontSize:
                                                                      MySize.getScaledSizeHeight(
                                                                          14),
                                                                  textColor: color.black,
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        20.0.hSpace(),
                                                        commonWidget
                                                            .customButton(
                                                              text: AppMessage.viewProfile,
                                                              onTap: () {
                                                                Get.to(() => StudentDetailsView(),
                                                                    arguments: {
                                                                      'flag': 'assignedStudent',
                                                                      'studentList': controller
                                                                              .getAssignStudentDataList[
                                                                          index]
                                                                    });
                                                              },
                                                            )
                                                            .paddingSymmetric(
                                                                horizontal:
                                                                    MySize.getScaledSizeHeight(3)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                              if (controller.isLoadMoreRunning.value) Center(child: CommonLoader()),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  filterBottomSheet({required context}) {
    return showModalBottomSheet(
      context: Get.context!,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(
            height: Get.height - 100,
            width: Get.width,
            decoration: BoxDecoration(
              color: color.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      04.0.hSpace(),
                      Row(
                        children: [
                          Expanded(child: SizedBox()),
                          Expanded(
                            child: Center(
                              child: commonText.semiBold(
                                text: AppMessage.filter,
                                fontSize: MySize.getScaledSizeHeight(20),
                                textColor: color.black,
                              ),
                            ),
                          ),
                          controller.selectedIndex1 == -1
                              ? Expanded(child: SizedBox())
                              : Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        controller.removeFilter();
                                        setState(() {}); // Add this if needed
                                      },
                                      child: Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      20.0.hSpace(),
                      commonWidget.commonDivider(color: color.notificationContainerColor),
                      16.0.hSpace(),

                      /// Make this scrollable if needed
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.getShiftDataList.length,
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                controller.selectedIndex1 = index;
                                controller.shiftId = "${controller.getShiftDataList[index].id}";
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  commonText.regular(
                                    text: controller.getShiftDataList[index].shiftName,
                                    fontSize: MySize.getScaledSizeHeight(16),
                                    textColor: color.textFieldTextColor,
                                  ),
                                  Image.asset(
                                    controller.selectedIndex1 == index
                                        ? icons.circleCheck
                                        : icons.circleUnCheck,
                                    height: MySize.getScaledSizeHeight(24),
                                    width: MySize.getScaledSizeWidth(24),
                                  ),
                                ],
                              ).paddingOnly(bottom: MySize.getScaledSizeHeight(26)),
                            );
                          },
                        ),
                      ),
                      10.0.hSpace(),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: MySize.getScaledSizeHeight(48),
                                decoration: BoxDecoration(
                                  color: color.homeTextColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(MySize.getScaledSizeHeight(8))),
                                ),
                                child: Center(
                                  child: commonText.medium(
                                    text: AppMessage.cancel,
                                    fontSize: MySize.getScaledSizeHeight(16),
                                    textColor: color.cancelColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          11.0.wSpace(),
                          Expanded(
                            child: commonWidget.customButton(
                              text: AppMessage.apply,
                              onTap: () {
                                if (controller.selectedIndex1 != -1) {
                                  Get.back();
                                  controller.getAssignStudentApi();
                                }
                              },
                              buttonColor: controller.selectedIndex1 != -1
                                  ? color.appColor
                                  : color.appColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ).paddingSymmetric(
                    horizontal: MySize.getScaledSizeWidth(16),
                    vertical: MySize.getScaledSizeHeight(16),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
