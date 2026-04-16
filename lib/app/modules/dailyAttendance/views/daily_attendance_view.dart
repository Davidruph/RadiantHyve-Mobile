import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/common.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../attendanceDetails/views/attendance_details_view.dart';
import '../controllers/daily_attendance_controller.dart';

class DailyAttendanceView extends GetView<DailyAttendanceController> {
  const DailyAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DailyAttendanceController>(
      init: DailyAttendanceController(),
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
            padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(16)),
            child: Column(
              children: [
                Container(
                  height: MySize.getScaledSizeHeight(60),
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(10)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)),
                    color: color.notificationContainerColor,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: commonText.medium(text: AppMessage.date, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: commonText.medium(text: AppMessage.clockIn, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: commonText.medium(text: AppMessage.clockOut, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                        ),
                      ),
                    ],
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
                                    ? buildNoDataWidget(height: Get.height / 1.5)
                                    : ListView.separated(
                                      itemCount: controller.attendanceList.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Get.to(() => AttendanceDetailsView(), arguments: {"attendanceId": controller.attendanceList[index].id});
                                          },
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: commonText.regular(
                                                    text: convertDateFormat(controller.attendanceList[index].date.toString()),
                                                    fontSize: MySize.getScaledSizeHeight(15),
                                                    textColor: color.textFieldTextColor,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: commonText.regular(
                                                    text: convertToTime(controller.attendanceList[index].clockInTime.toString()),
                                                    fontSize: MySize.getScaledSizeHeight(14),
                                                    textColor: color.textFieldTextColor,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child:
                                                    controller.attendanceList[index].clockOutTime == null
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
                                                            text: convertToTime(controller.attendanceList[index].clockOutTime.toString()),
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
                              return controller.isLoadMoreRunning.value == true
                                  ? Center(child: CommonLoader(color: color.appColor))
                                  : SizedBox(height: 0);
                            }),
                            Obx(() => controller.isLoadMoreRunning.value == true ? 20.0.hSpace() : 00.0.hSpace()),
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
