import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../utils/common.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/attendance_status_controller.dart';

class AttendanceStatusView extends GetView<AttendanceStatusController> {
  const AttendanceStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceStatusController>(
      init: AttendanceStatusController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: color.backgroundColor,
            appBar: commonWidget.appBar(
              titleText: AppMessage.attendance,
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
                children: [
                  Center(
                    child: Obx(
                      () => IntrinsicHeight(
                        child: Container(
                          decoration: BoxDecoration(color: color.appColor, borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(50))),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [tabItem(AppMessage.present, 0), tabItem(AppMessage.absent, 1), tabItem(AppMessage.out, 2)],
                          ),
                        ),
                      ),
                    ),
                  ),
                  16.0.hSpace(),
                  controller.flag == 'calendarRoute'
                      ? controller.isLoading.value
                          ? diagonalShimmer(
                            height: MySize.getScaledSizeHeight(45),
                            width: Get.width,
                            borderRadius: BorderRadius.circular(8),
                          ).paddingOnly(bottom: MySize.getScaledSizeHeight(12))
                          : Container(
                            decoration: BoxDecoration(
                              color: color.white,
                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(MySize.getScaledSizeHeight(12)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  commonText.regular(
                                    text: AppMessage.dayDate,
                                    fontSize: MySize.getScaledSizeHeight(14),
                                    textColor: color.textFieldTextColor,
                                  ),
                                  commonText.medium(
                                    text: controller.selectedDate,
                                    fontSize: MySize.getScaledSizeHeight(14),
                                    textColor: color.black,
                                  ),
                                ],
                              ),
                            ),
                          ).paddingOnly(bottom: MySize.getScaledSizeHeight(12))
                      : SizedBox(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)),
                      color: color.onboardingBorderColor,
                    ),
                    child: TextField(
                      cursorColor: color.black,
                      controller: controller.searchController,
                      onChanged: (value) {
                        if (controller.searchController.text.isEmpty) {
                          controller.debounceSearch(value);
                        }
                      },
                      onSubmitted: (value) {
                        controller.page = 1;
                        controller.listStudentAttedanceApi();
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(
                          RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                        ),
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(16), vertical: MySize.getScaledSizeHeight(14)),
                        hintText: AppMessage.search,
                        border: InputBorder.none,
                        prefixIcon: Image.asset(icons.searchIcon, scale: 4.0),
                        suffixIcon:
                            controller.searchController.text != ''
                                ? GestureDetector(
                                  onTap: () {
                                    controller.searchController.clear();
                                    controller.listStudentAttedanceApi();
                                    controller.update();
                                  },
                                  child: Icon(Icons.close_rounded, size: 24, color: color.black),
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
                  ).paddingOnly(bottom: MySize.getScaledSizeHeight(12)),

                  Obx(() {
                    return Expanded(
                      child: RefreshIndicator(
                        displacement: 30,
                        backgroundColor: color.white,
                        color: color.appColor,
                        strokeWidth: 3,
                        onRefresh: () async {
                          controller.page = 1;
                          controller.listStudentAttedanceApi();
                        },
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                          child: Column(
                            children: [
                              !controller.isLoading.value
                                  ? controller.listStudentAttedanceDataList.isEmpty
                                      ? buildNoDataWidget(height: MySize.getScaledSizeHeight(500))
                                      : ListView.separated(
                                        itemCount: controller.listStudentAttedanceDataList.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    commonText.medium(
                                                      text: controller.listStudentAttedanceDataList[index].studentName,
                                                      textColor: color.black,
                                                      fontSize: MySize.getScaledSizeHeight(16),
                                                    ),
                                                    06.0.hSpace(),
                                                    // controller.selectedIndex.value == 2
                                                    //     ? commonText.medium(
                                                    //       text: '${controller.listStudentAttedanceDataList[index].parentName ?? ''}',
                                                    //       textColor: color.black,
                                                    //       fontSize: MySize.getScaledSizeHeight(16),
                                                    //     )
                                                    //     : SizedBox(),
                                                    // controller.selectedIndex.value == 2 ? 06.0.hSpace() : SizedBox(),
                                                    // controller.selectedIndex.value == 2
                                                    //     ?commonText.medium(
                                                    //   text: '${controller.listStudentAttedanceDataList[index].relationToChild ?? ''}',
                                                    //   textColor: color.black,
                                                    //   fontSize: MySize.getScaledSizeHeight(16),
                                                    // )
                                                    //     : SizedBox(),
                                                    // controller.selectedIndex.value == 2 ? 06.0.hSpace() : SizedBox(),
                                                    controller.selectedIndex.value == 2
                                                        ? Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            // 🔹 Parent Name with title
                                                            Row(
                                                              children: [
                                                                commonText.medium(
                                                                  text: "Picked up by:",
                                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                                  textColor: Color(0xff4B5563),
                                                                ),
                                                                commonText.medium(
                                                                  text: controller.listStudentAttedanceDataList[index].parentName ?? '',
                                                                  textColor: color.black,
                                                                  fontSize: MySize.getScaledSizeHeight(16),
                                                                ),
                                                              ],
                                                            ),

                                                            06.0.hSpace(),

                                                            Row(
                                                              children: [
                                                                commonText.medium(
                                                                  text: "Relation to Child:",
                                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                                  textColor: Color(0xff4B5563),
                                                                ),

                                                                commonText.medium(
                                                                  text: controller.listStudentAttedanceDataList[index].relationToChild ?? '',
                                                                  textColor: color.black,
                                                                  fontSize: MySize.getScaledSizeHeight(16),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                        : const SizedBox(),
                                                    controller.selectedIndex.value == 2 ? 06.0.hSpace() : SizedBox(),

                                                    Row(
                                                      children: [
                                                        commonText.regular(
                                                          text: '${convertDateFormat(controller.listStudentAttedanceDataList[index].date)}, ',
                                                          textColor: color.textFieldTextColor,
                                                          fontSize: MySize.getScaledSizeHeight(14),
                                                        ),
                                                        commonText.regular(
                                                          text: controller.formatUtcTimeToLocal(
                                                            controller.listStudentAttedanceDataList[index].presentTime,
                                                          ),
                                                          textColor: color.textFieldTextColor,
                                                          fontSize: MySize.getScaledSizeHeight(14),
                                                        ),
                                                      ],
                                                    ),

                                                    controller.selectedIndex.value == 2
                                                        ? Row(
                                                          children: [
                                                            commonText.regular(
                                                              text: '${convertDateFormat(controller.listStudentAttedanceDataList[index].date)}, ',
                                                              textColor: color.textFieldTextColor,
                                                              fontSize: MySize.getScaledSizeHeight(14),
                                                            ),
                                                            commonText.regular(
                                                              text: controller.formatUtcTimeToLocal(
                                                                controller.listStudentAttedanceDataList[index].outTime ?? '',
                                                              ),
                                                              textColor: color.textFieldTextColor,
                                                              fontSize: MySize.getScaledSizeHeight(14),
                                                            ),
                                                          ],
                                                        )
                                                        : SizedBox(),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: MySize.getScaledSizeHeight(30),
                                                width: MySize.getScaledSizeHeight(30),
                                                decoration: BoxDecoration(
                                                  color: color.presentBackgroundColor,
                                                  borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(50))),
                                                ),
                                                child: Center(
                                                  child: commonText.regular(
                                                    // text:
                                                    //     controller.listStudentAttedanceDataList[index].studentName.isNotEmpty
                                                    //         ? controller.listStudentAttedanceDataList[index].studentName[0].toLowerCase()
                                                    //         : '',
                                                    text:
                                                        controller.selectedIndex.value == 0
                                                            ? 'P'
                                                            : controller.selectedIndex.value == 1
                                                            ? 'A'
                                                            : 'O',
                                                    textColor: color.textFieldFocusColor,
                                                    fontSize: MySize.getScaledSizeHeight(14),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return commonWidget
                                              .commonDivider(color: color.onboardingBorderColor)
                                              .paddingSymmetric(vertical: MySize.getScaledSizeHeight(20));
                                        },
                                      )
                                  : ListView.separated(
                                    itemCount: 5,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                diagonalShimmer(
                                                  height: MySize.getScaledSizeHeight(18),
                                                  width: MySize.getScaledSizeHeight(118),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                06.0.hSpace(),
                                                diagonalShimmer(
                                                  height: MySize.getScaledSizeHeight(16),
                                                  width: MySize.getScaledSizeHeight(190),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                              ],
                                            ),
                                          ),
                                          diagonalShimmer(
                                            height: MySize.getScaledSizeHeight(30),
                                            width: MySize.getScaledSizeHeight(30),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return commonWidget
                                          .commonDivider(color: color.onboardingBorderColor)
                                          .paddingSymmetric(vertical: MySize.getScaledSizeHeight(20));
                                    },
                                  ),

                              Obx(() {
                                return controller.isLoadMoreRunning.value == true ? Center(child: CommonLoader()) : Container();
                              }),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            bottomNavigationBar: Obx(
              () =>
                  controller.isLoading.value
                      ? SizedBox()
                      : controller.isSubmitted.value == false && controller.isClockOutAllStudent.value == true
                      ? Container(
                        decoration: BoxDecoration(color: color.white),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            commonWidget.commonDivider(color: color.notificationContainerColor),
                            commonWidget
                                .customButton(
                                  isLoading: controller.isSubmittedLoading.value,
                                  text: AppMessage.confirmSubmitAttendance,
                                  onTap: () {
                                    controller.submittedAttedanceApi();
                                  },
                                )
                                .paddingAll(MySize.getScaledSizeHeight(16)),
                          ],
                        ),
                      ).paddingOnly(bottom: Platform.isIOS ? MySize.getScaledSizeHeight(10) : 0)
                      : SizedBox(),
            ),
          ),
        );
      },
    );
  }

  Widget tabItem(String title, int index) {
    return GestureDetector(
      onTap: () {
        controller.changeTab(index);
        controller.update();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(10), vertical: MySize.getScaledSizeHeight(8)),
        margin: EdgeInsets.all(MySize.getScaledSizeHeight(4)),
        decoration: BoxDecoration(
          color: controller.selectedIndex.value == index ? color.buttonColor : color.appColor,
          borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(50)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(20), vertical: MySize.getScaledSizeHeight(0)),
          child: Center(child: commonText.medium(text: title, textColor: color.white, fontSize: MySize.getScaledSizeHeight(16))),
        ),
      ),
    );
  }
}
