import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../commonWidgets/NoData.dart';
import '../controllers/staff_daily_attendance_controller.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import 'package:radianthyve_unified/utils/common.dart';
import '../../../../commonWidgets/constant.dart';
import '../../attendanceDetails/views/attendance_details_view.dart';

class StaffDailyAttendanceView extends GetView<StaffDailyAttendanceController> {
  const StaffDailyAttendanceView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StaffDailyAttendanceController>(
      init: StaffDailyAttendanceController(),
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
                        commonText.medium(
                          text: AppMessage.date,
                          fontSize: MySize.getScaledSizeHeight(16),
                          textColor: color.black,
                        ),
                        Spacer(),
                        commonText
                            .medium(
                              text: AppMessage.clockIn,
                              fontSize: MySize.getScaledSizeHeight(16),
                              textColor: color.black,
                            )
                            .paddingOnly(right: MySize.getScaledSizeHeight(48)),
                        commonText
                            .medium(
                              text: AppMessage.clockOut,
                              fontSize: MySize.getScaledSizeHeight(16),
                              textColor: color.black,
                            )
                            .paddingOnly(right: MySize.getScaledSizeHeight(3)),
                      ],
                    ),
                  ),
                ),
                20.0.hSpace(),
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
                        controller.listAttendanceApi();
                      },
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                        child: Column(
                          children: [
                            !controller.isLoading.value
                                ? controller.attendanceList.isEmpty
                                    ? Center(child: NoData(height: Get.height / 1.4, width: Get.width))
                                    : ListView.separated(
                                        itemCount: controller.attendanceList.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              // print('controller.attendanceList[index].id${controller.attendanceList[index].id}');
                                              Get.to(() => AttendanceDetailsView(), arguments: {
                                                "attendanceId": controller.attendanceList[index].id,
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: commonText.regular(
                                                      text: commonMethod.convertDateFormat(controller.attendanceList[index].date.toString()),
                                                      fontSize: MySize.getScaledSizeHeight(15),
                                                      textColor: color.textFieldTextColor,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: commonText.regular(
                                                      text: commonMethod.convertToTime(controller.attendanceList[index].clockInTime.toString()),
                                                      fontSize: MySize.getScaledSizeHeight(14),
                                                      textColor: color.textFieldTextColor,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: controller.attendanceList[index].clockOutTime == null
                                                      ? Center(
                                                          child: commonText
                                                              .regular(
                                                                text: "-",
                                                                fontSize: MySize.getScaledSizeHeight(14),
                                                                textColor: color.textFieldTextColor,
                                                              )
                                                              .paddingOnly(left: 30),
                                                        )
                                                      : Align(
                                                          alignment: Alignment.centerRight,
                                                          child: commonText.regular(
                                                            text:
                                                                commonMethod.convertToTime(controller.attendanceList[index].clockOutTime.toString()),
                                                            fontSize: MySize.getScaledSizeHeight(14),
                                                            textColor: color.textFieldTextColor,
                                                          ),
                                                        ),
                                                ),
                                              ],
                                            ).paddingSymmetric(horizontal: MySize.getScaledSizeHeight(10)),
                                          );
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
                                            height: MySize.getScaledSizeHeight(18),
                                            width: MySize.getScaledSizeWidth(100),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          diagonalShimmer(
                                            height: MySize.getScaledSizeHeight(16),
                                            width: MySize.getScaledSizeWidth(70),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          diagonalShimmer(
                                            height: MySize.getScaledSizeHeight(16),
                                            width: MySize.getScaledSizeWidth(80),
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
                              return controller.isLoadMoreRunning.value == true ? Center(child: CommonLoader()) : SizedBox(height: 0);
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
