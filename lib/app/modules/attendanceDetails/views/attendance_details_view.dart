import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/attendance_details_controller.dart';

class AttendanceDetailsView extends GetView<AttendanceDetailsController> {
  const AttendanceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceDetailsController>(
      init: AttendanceDetailsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
              titleText: AppMessage.attendanceDetails,
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
            child: Container(
              decoration: BoxDecoration(color: color.white, borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(16)))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        controller.isLoading.value
                            ? diagonalShimmer(
                              height: MySize.getScaledSizeHeight(18),
                              width: MySize.getScaledSizeWidth(136),
                              borderRadius: BorderRadius.circular(4),
                            )
                            : commonText.medium(
                              text: controller.formatReadableDate(controller.getAttendanceData?.date),
                              fontSize: MySize.getScaledSizeHeight(16),
                              textColor: color.black,
                            ),
                        controller.isLoading.value
                            ? diagonalShimmer(
                              height: MySize.getScaledSizeHeight(16),
                              width: MySize.getScaledSizeWidth(60),
                              borderRadius: BorderRadius.circular(4),
                            )
                            : commonText.regular(
                              text:
                                  controller.getAttendanceData?.clockOutTime == null
                                      ? ""
                                      : controller.getDuration(controller.getAttendanceData?.clockInTime, controller.getAttendanceData?.clockOutTime),
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.black,
                            ),
                      ],
                    ),
                  ),
                  02.0.hSpace(),
                  commonWidget.commonDivider(color: color.dividerColor),
                  Padding(
                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        controller.isLoading.value
                            ? diagonalShimmer(
                              height: MySize.getScaledSizeHeight(16),
                              width: MySize.getScaledSizeWidth(136),
                              borderRadius: BorderRadius.circular(4),
                            )
                            : Row(
                              children: [
                                commonText.regular(text: '• Clock in ', fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                                commonText.medium(
                                  text: controller.formatClockInTime(controller.getAttendanceData?.clockInTime),
                                  fontSize: MySize.getScaledSizeHeight(14),
                                  textColor: color.black,
                                ),
                              ],
                            ),
                        04.0.hSpace(),
                        controller.isLoading.value
                            ? diagonalShimmer(height: MySize.getScaledSizeHeight(14), width: Get.width, borderRadius: BorderRadius.circular(4))
                            : commonText.regular(
                              text: controller.getAttendanceData?.clockInAddress,
                              fontSize: MySize.getScaledSizeHeight(12),
                              textColor: color.textFieldTextColor,
                            ),
                        16.0.hSpace(),
                        commonWidget.commonDivider(color: color.dividerColor),
                        16.0.hSpace(),
                        controller.isLoading.value
                            ? diagonalShimmer(
                              height: MySize.getScaledSizeHeight(16),
                              width: MySize.getScaledSizeWidth(136),
                              borderRadius: BorderRadius.circular(4),
                            )
                            : Row(
                              children: [
                                commonText.regular(text: '• Clock out ', fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                                commonText.medium(
                                  text:
                                      controller.getAttendanceData?.clockOutTime == null
                                          ? ""
                                          : controller.formatClockInTime(controller.getAttendanceData?.clockOutTime),
                                  fontSize: MySize.getScaledSizeHeight(14),
                                  textColor: color.black,
                                ),
                              ],
                            ),
                        04.0.hSpace(),
                        controller.isLoading.value
                            ? diagonalShimmer(height: MySize.getScaledSizeHeight(14), width: Get.width, borderRadius: BorderRadius.circular(4))
                            : commonText.regular(
                              text: controller.getAttendanceData?.clockOutTime == null ? "" : controller.getAttendanceData?.clockOutAddress,
                              fontSize: MySize.getScaledSizeHeight(12),
                              textColor: color.textFieldTextColor,
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
