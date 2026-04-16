import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_drawer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../attendanceDetails/views/attendance_details_view.dart';
import '../../dailyAttendance/views/daily_attendance_view.dart';
import '../../notifications/views/notifications_view.dart';
import '../controllers/home_controller.dart';

class PrincipalHomeView extends GetView<HomeController> {
  const PrincipalHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return GetBuilder<HomeController>(
      init: HomeController(),
      assignId: true,
      builder: (controller) {
        return Obx(
          () => IgnorePointer(
            ignoring: controller.isClockInOutLoader.value,
            child: Scaffold(
              key: controller.scaffoldKey,
              backgroundColor: color.backgroundColor,
              appBar: commonWidget.appBar(
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
                leading: SizedBox(),
                toolbarHeight: 0.0,
                backgroundColor: color.appColor,
              ),
              drawer: drawer(),
              body: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: color.appColor),
                    child: Padding(
                      padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.scaffoldKey.currentState?.openDrawer();
                                },
                                child: Image.asset(icons.drawerIcon, height: MySize.getScaledSizeHeight(30), width: MySize.getScaledSizeWidth(30)),
                              ),
                              10.0.wSpace(),
                              Image.asset(
                                images.homeLogoImage,
                                height: MySize.getScaledSizeHeight(34),
                                width: MySize.getScaledSizeWidth(160),
                              ).paddingOnly(top: MySize.getScaledSizeHeight(4)),

                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => NotificationsView());
                                },
                                child: Container(
                                  height: MySize.getScaledSizeHeight(38),
                                  width: MySize.getScaledSizeWidth(38),
                                  decoration: BoxDecoration(color: color.containerBackgroundColor, shape: BoxShape.circle),
                                  child: Padding(
                                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(8)),
                                    child: Image.asset(
                                      icons.notificationIcon,
                                      height: MySize.getScaledSizeHeight(24),
                                      width: MySize.getScaledSizeWidth(24),
                                    ),
                                  ),
                                ),
                              ),
                              10.0.wSpace(),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: MySize.getScaledSizeHeight(38),
                                  width: MySize.getScaledSizeWidth(38),
                                  decoration: BoxDecoration(color: Color(0xffFB5555), shape: BoxShape.circle),
                                  child: Padding(
                                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(8)),
                                    child: Image.asset(
                                      icons.sosIcon,
                                      height: MySize.getScaledSizeHeight(24),
                                      width: MySize.getScaledSizeWidth(24),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          11.0.hSpace(),
                          commonText.medium(
                            text: 'Hello, ${box.read(PrefsKey.fullName) ?? ''}',
                            fontSize: MySize.getScaledSizeHeight(18),
                            textColor: color.white,
                            maxLines: 1,
                          ),
                          12.0.hSpace(),
                          commonText.regular(
                            text: AppMessage.whatIsTheStatusOf,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.homeTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: color.white,
                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(MySize.getScaledSizeHeight(15)),
                              child: Column(
                                children: [
                                  commonText.regular(
                                    text: DateFormat('EEEE, dd MMMM, yyyy').format(DateTime.now()),
                                    fontSize: MySize.getScaledSizeHeight(14),
                                    textColor: color.textFieldTextColor,
                                  ),
                                  12.0.hSpace(),
                                  Obx(() {
                                    return commonText.medium(
                                      text: controller.elapsedTime.value,
                                      fontSize: MySize.getScaledSizeHeight(20),
                                      textColor: color.black,
                                    );
                                  }),
                                  Obx(() {
                                    return controller.isLoading.value
                                        ? SizedBox()
                                        : controller.attendanceList.isEmpty
                                        ? SizedBox()
                                        : controller.attendanceList[0].clockOutTime == null
                                        ? 08.0.hSpace()
                                        : SizedBox();
                                  }),
                                  Obx(() {
                                    return controller.isLoading.value
                                        ? SizedBox()
                                        : controller.attendanceList.isEmpty
                                        ? SizedBox()
                                        : controller.attendanceList[0].clockOutTime == null
                                        ? commonText.regular(
                                          text: "Clock In: ${commonMethod.convertToTime(controller.attendanceList[0].clockInTime.toString())}",
                                          fontSize: MySize.getScaledSizeHeight(14),
                                          textColor: color.textFieldTextColor,
                                        )
                                        : SizedBox();
                                  }),
                                  12.0.hSpace(),
                                  Obx(() {
                                    return controller.isClockInOutLoader.value
                                        ? Center(
                                          child: Container(
                                            height: MySize.getScaledSizeHeight(48),
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              color: color.appColor,
                                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                                            ),
                                            child: SpinKitThreeBounce(color: color.white, size: MySize.getScaledSizeHeight(20)),
                                          ),
                                        )
                                        : InkWell(
                                          onTap: () async {
                                            if (controller.isButtonOnTap.value == false) {
                                              await controller.handleLocationPermissionAndInit();
                                            }
                                          },
                                          child: Container(
                                            height: MySize.getScaledSizeHeight(48),
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              color: controller.isClockIn.value == true ? color.appColor.withOpacity(0.5) : color.appColor,
                                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  icons.loginIcon,
                                                  height: MySize.getScaledSizeHeight(24),
                                                  width: MySize.getScaledSizeWidth(24),
                                                ),
                                                10.0.wSpace(),
                                                Obx(() {
                                                  return commonText.medium(
                                                    text: controller.isClockIn.value == true ? AppMessage.clockOut : AppMessage.clockIn,
                                                    fontSize: MySize.getScaledSizeHeight(16),
                                                    textColor: color.white,
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                        );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          16.0.hSpace(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              commonText.medium(
                                text: AppMessage.dailyAttendance,
                                fontSize: MySize.getScaledSizeHeight(16),
                                textColor: color.black,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => DailyAttendanceView());
                                },
                                child: commonText.medium(text: "See all", fontSize: MySize.getScaledSizeHeight(16), textColor: color.appColor),
                              ),
                            ],
                          ),
                          16.0.hSpace(),
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
                                    child: commonText.medium(
                                      text: AppMessage.date,
                                      fontSize: MySize.getScaledSizeHeight(16),
                                      textColor: color.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: commonText.medium(
                                      text: AppMessage.clockIn,
                                      fontSize: MySize.getScaledSizeHeight(16),
                                      textColor: color.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: commonText.medium(
                                      text: AppMessage.clockOut,
                                      fontSize: MySize.getScaledSizeHeight(16),
                                      textColor: color.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          20.0.hSpace(),
                          Expanded(
                            child: Obx(() {
                              return controller.isLoading.value
                                  ? ListView.separated(
                                    itemCount: 50,
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
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
                                  )
                                  : controller.attendanceList.isEmpty
                                  ? RefreshIndicator(
                                    onRefresh: () async {
                                      controller.attendanceListAPI();
                                    },
                                    backgroundColor: color.white,
                                    color: color.appColor,
                                    child: SingleChildScrollView(
                                      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                                      child: SizedBox(
                                        height: 300,
                                        width: Get.width,
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                images.noattendancerecords,
                                                height: MySize.getScaledSizeHeight(190),
                                                width: MySize.getScaledSizeHeight(190),
                                              ),
                                              commonText.medium(
                                                text: 'No attendance records',
                                                fontSize: MySize.getScaledSizeHeight(16),
                                                textColor: Color(0xff757D83),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  : ListView.separated(
                                    itemCount: controller.attendanceList.length,
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
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
                                                          text: commonMethod.convertToTime(controller.attendanceList[index].clockOutTime.toString()),
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
                                  );
                            }),
                          ),
                        ],
                      ),
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
