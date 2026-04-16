import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../controllers/student_daily_attendance_controller.dart';

class StudentDailyAttendanceView extends GetView<StudentDailyAttendanceController> {
  const StudentDailyAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentDailyAttendanceController>(
      init: StudentDailyAttendanceController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
              titleText: AppMessage.dailyAttendance,
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
                Container(
                  height: MySize.getScaledSizeHeight(66),
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                    color: color.notificationContainerColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(10)),
                    child: Row(
                      children: [
                        commonText.medium(text: AppMessage.date, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                        Spacer(),
                        commonText
                            .medium(text: AppMessage.status, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black)
                            .paddingOnly(right: MySize.getScaledSizeHeight(48)),
                      ],
                    ),
                  ),
                ),
                20.0.hSpace(),
                Obx(() {
                  return Expanded(
                    child: RefreshIndicator(
                      displacement: 30,
                      backgroundColor: color.white,
                      color: color.appColor,
                      strokeWidth: 3,
                      onRefresh: () async {
                        controller.page = 1;
                        controller.getStudentAttedanceApi();
                      },
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                        child: Column(
                          children: [
                            !controller.isLoading.value
                                ? controller.getStudentAttedanceDataList.isEmpty
                                    ? buildNoDataWidget(height: Get.height / 1.5)
                                    : ListView.separated(
                                      itemCount: controller.getStudentAttedanceDataList.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            commonText.regular(
                                              text: '${controller.getStudentAttedanceDataList[index].date}',
                                              fontSize: MySize.getScaledSizeHeight(16),
                                              textColor: color.textFieldTextColor,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    controller.getStudentAttedanceDataList[index].attendanceStatus == "present"
                                                        ? color.presentBackgroundColor
                                                        : color.absentBackgroundColor,
                                                borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(50))),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: MySize.getScaledSizeHeight(4),
                                                  horizontal: MySize.getScaledSizeHeight(24),
                                                ),
                                                child: commonText.regular(
                                                  text:
                                                      controller.getStudentAttedanceDataList[index].attendanceStatus == "present"
                                                          ? "Present"
                                                          : "Absent",
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                  textColor:
                                                      controller.getStudentAttedanceDataList[index].attendanceStatus == "present"
                                                          ? color.textFieldFocusColor
                                                          : color.textFieldErrorColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ).paddingSymmetric(horizontal: MySize.getScaledSizeHeight(10));
                                      },
                                      separatorBuilder: (context, index) {
                                        return commonWidget
                                            .commonDivider(color: color.onboardingBorderColor)
                                            .paddingSymmetric(vertical: MySize.getScaledSizeHeight(20));
                                      },
                                    )
                                : ListView.separated(
                                  itemCount: 10,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        diagonalShimmer(
                                          height: MySize.getScaledSizeHeight(26),
                                          width: MySize.getScaledSizeWidth(100),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        diagonalShimmer(
                                          height: MySize.getScaledSizeHeight(29),
                                          width: MySize.getScaledSizeWidth(100),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ],
                                    ).paddingSymmetric(horizontal: MySize.getScaledSizeHeight(10));
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
        );
      },
    );
  }
}
