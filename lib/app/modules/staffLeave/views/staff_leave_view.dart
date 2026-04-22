
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/staffLeaveCalendar/views/staff_leave_calendar_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_drawer.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/NoData.dart';
import '../controllers/staff_leave_controller.dart';

class StaffLeaveView extends GetView<StaffLeaveController> {
  const StaffLeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StaffLeaveController>(
      init: StaffLeaveController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          backgroundColor: color.backgroundColor,
          appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.light,
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: color.appGradient,
                  ),
                ),
            leading: Padding(
              padding: EdgeInsets.only(left: MySize.getScaledSizeHeight(15)),
              child: GestureDetector(
                onTap: () {
                  controller.scaffoldKey.currentState?.openDrawer();
                },
                child: Image.asset(
                  icons.drawerIcon,
                  height: MySize.getScaledSizeHeight(30),
                  width: MySize.getScaledSizeWidth(30),
                ),
              ),
            ),
            title: commonText.medium(
              text: AppMessage.staffLeave,
              fontSize: MySize.getScaledSizeHeight(18),
              textColor: color.white,
            ),
            centerTitle: false,
            backgroundColor: Colors.transparent,
          ),
          drawer: drawer(),
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeWidth(16)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    controller.isLoading.value
                        ? diagonalShimmer(
                            height: MySize.getScaledSizeHeight(25),
                            width: MySize.getScaledSizeWidth(135),
                            borderRadius: BorderRadius.circular(4),
                          )
                        : commonText.medium(
                            text: 'Total Leave (${controller.staffLeaveList.length})',
                            textColor: color.black,
                            fontSize: MySize.getScaledSizeHeight(18),
                          ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => StaffLeaveCalendarView());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: color.leaveCalenderColor),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(MySize.getScaledSizeWidth(7)),
                          child: Image.asset(
                            icons.calendarIcon,
                            height: MySize.getScaledSizeHeight(24),
                            width: MySize.getScaledSizeWidth(24),
                            color: color.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                24.0.hSpace(),
                Expanded(
                  child: controller.isLoading.value
                      ? ListView.separated(
                          itemCount: 2,
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return diagonalShimmer(
                              height: MySize.getScaledSizeHeight(389),
                              width: Get.width,
                              borderRadius: BorderRadius.circular(8),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return 16.0.hSpace();
                          },
                        )
                      : controller.staffLeaveList.isEmpty
                          ? RefreshIndicator(
                              onRefresh: () async {
                                controller.ListLeaveRequetsAPI();
                              },
                              backgroundColor: color.white,
                              color: color.appColor,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                                child: NoData(height: Get.height / 1.4, width: Get.width),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                controller.ListLeaveRequetsAPI();
                              },
                              backgroundColor: color.white,
                              color: color.appColor,
                              child: ListView.separated(
                                itemCount: controller.staffLeaveList.length,
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: color.white,
                                      borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeWidth(8))),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: MySize.getScaledSizeWidth(16)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          commonText
                                              .medium(
                                                text: controller.staffLeaveList[index].teacherName,
                                                textColor: color.black,
                                                fontSize: MySize.getScaledSizeHeight(16),
                                              )
                                              .paddingSymmetric(horizontal: MySize.getScaledSizeWidth(12)),
                                          10.0.hSpace(),
                                          commonWidget.commonDivider(color: color.dividerColor),
                                          12.0.hSpace(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(12)),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                commonText.regular(
                                                  text: AppMessage.dateOfLeave,
                                                  textColor: color.textFieldTextColor,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                08.0.hSpace(),
                                                commonText.regular(
                                                  text: controller.staffLeaveList[index].date,
                                                  textColor: color.black,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                16.0.hSpace(),
                                                commonText.regular(
                                                  text: AppMessage.leaveType,
                                                  textColor: color.textFieldTextColor,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                08.0.hSpace(),
                                                commonText.regular(
                                                  text: controller.staffLeaveList[index].leaveType,
                                                  textColor: color.black,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                16.0.hSpace(),
                                                commonText.regular(
                                                  text: AppMessage.reason,
                                                  textColor: color.textFieldTextColor,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                08.0.hSpace(),
                                                commonText.regular(
                                                  text: controller.staffLeaveList[index].reason,
                                                  textColor: color.black,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                20.0.hSpace(),
                                                controller.staffLeaveList[index].leaveRequestStatus == "pending"
                                                    ? Row(
                                                        children: [
                                                          Expanded(
                                                            child: commonWidget.customButton(
                                                              buttonColor: color.absentBackgroundColor,
                                                              text: AppMessage.reject,
                                                              textColor: color.textFieldErrorColor,
                                                              isLoading: controller.staffLeaveList[index].isRejectLoader,
                                                              onTap: () {
                                                                if (controller.staffLeaveList[index].isRejectLoader != true &&
                                                                    controller.staffLeaveList[index].isAcceptLoader != true) {
                                                                  controller.UpdateLeaveStatusAPI(
                                                                    status: "rejected",
                                                                    leaveId: controller.staffLeaveList[index].id,
                                                                    index: index,
                                                                  );
                                                                }
                                                                controller.update();
                                                              },
                                                            ),
                                                          ),
                                                          09.0.wSpace(),
                                                          Expanded(
                                                            child: commonWidget.customButton(
                                                              text: AppMessage.accept,
                                                              isLoading: controller.staffLeaveList[index].isAcceptLoader,
                                                              onTap: () {
                                                                if (controller.staffLeaveList[index].isRejectLoader != true &&
                                                                    controller.staffLeaveList[index].isAcceptLoader != true) {
                                                                  controller.UpdateLeaveStatusAPI(
                                                                    status: "accepted",
                                                                    leaveId: controller.staffLeaveList[index].id,
                                                                    index: index,
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : SizedBox()
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return 16.0.hSpace();
                                },
                              ),
                            ),
                ),
                Obx(() {
                  return controller.isLoadMoreRunning.value == true ? Center(child: CommonLoader()) : SizedBox(height: 0);
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
