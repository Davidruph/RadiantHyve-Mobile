import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/notifications/views/notifications_view.dart';
import 'package:radianthyve_unified/app/modules/parentsReminder/views/parents_reminder_view.dart';
import 'package:radianthyve_unified/app/modules/studentDetails/views/student_details_view.dart';
import 'package:radianthyve_unified/app/modules/studentEditProfile/views/student_edit_profile_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_drawer.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/commonWidgets/constant.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import 'package:radianthyve_unified/utils/prefsKey.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          backgroundColor: color.backgroundColor,
          // appBar: commonWidget.appBar(
          //   statusBarIconBrightness: Brightness.light,
          //   statusBarBrightness: Brightness.dark,
          //   leading: SizedBox(),
          //   toolbarHeight: 0.0,
          //   backgroundColor: color.appColor,
          // ),
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
              leading: SizedBox(),
              toolbarHeight: 0.0,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          drawer: drawer(),
          floatingActionButton: InkWell(
            onTap: () {
              Get.to(() => StudentEditProfileView())?.then((value) {
                if (value != null) {
                  controller.studentsListAPI();
                  controller.update();
                }
              });
            },
            child: Container(
              height: MySize.getScaledSizeHeight(50),
              width: MySize.getScaledSizeWidth(50),
              decoration: BoxDecoration(shape: BoxShape.circle, color: color.buttonColor),
              child: Icon(Icons.add_outlined, size: MySize.getScaledSizeHeight(30), color: color.white),
            ).paddingOnly(bottom: MySize.getScaledSizeHeight(28)),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // decoration: BoxDecoration(color: color.appColor),
                decoration: BoxDecoration(gradient: color.appGradient),
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
                        ],
                      ),
                      11.0.hSpace(),
                      controller.isLoading.value
                          ? diagonalShimmer(
                            height: MySize.getScaledSizeHeight(20),
                            width: MySize.getScaledSizeWidth(195),
                            borderRadius: BorderRadius.circular(4),
                          )
                          : commonText.medium(
                            text: 'Hello, ${box.read(PrefsKey.fullName)}',
                            fontSize: MySize.getScaledSizeHeight(18),
                            textColor: color.white,
                          ),
                      12.0.hSpace(),
                      commonText.regular(
                        text: AppMessage.whatIsTheSituation,
                        fontSize: MySize.getScaledSizeHeight(14),
                        textColor: color.homeTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                    child: RefreshIndicator(
                      displacement: 30,
                      backgroundColor: color.white,
                      color: color.appColor,
                      strokeWidth: 3,
                      onRefresh: () async {
                        controller.page = 1;
                        controller.hasNextPage.value = true;
                        controller.studentsListAPI();
                      },
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                        child: Column(
                          children: [
                            !controller.isLoading.value
                                ? controller.studentsListDataList.isEmpty
                                    ? buildNoDataWidget(height: Get.height / 1.4)
                                    : ListView.separated(
                                      itemCount: controller.studentsListDataList.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: color.white,
                                            borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: MySize.getScaledSizeHeight(12),
                                                  vertical: MySize.getScaledSizeHeight(15),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    commonText.medium(
                                                      text: controller.studentsListDataList[index].fullName,
                                                      fontSize: MySize.getScaledSizeHeight(16),
                                                      textColor: color.black,
                                                    ),
                                                    controller.studentsListDataList[index].requestStatus == 'pending'
                                                        ? Container(
                                                          decoration: BoxDecoration(
                                                            color: color.waitingBackgroundColor,
                                                            borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(50))),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                              vertical: MySize.getScaledSizeHeight(4),
                                                              horizontal: MySize.getScaledSizeHeight(29),
                                                            ),
                                                            child: commonText.regular(
                                                              text: AppMessage.waiting,
                                                              fontSize: MySize.getScaledSizeHeight(14),
                                                              textColor: color.waitingColor,
                                                            ),
                                                          ),
                                                        )
                                                        : controller.studentsListDataList[index].requestStatus == 'feesPending'
                                                        ? Container(
                                                          decoration: BoxDecoration(
                                                            color: color.absentBackgroundColor,
                                                            borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(50))),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                              vertical: MySize.getScaledSizeHeight(4),
                                                              horizontal: MySize.getScaledSizeHeight(29),
                                                            ),
                                                            child: commonText.regular(
                                                              text: 'Block Student',
                                                              fontSize: MySize.getScaledSizeHeight(14),
                                                              textColor: color.warnRedColor,
                                                            ),
                                                          ),
                                                        )
                                                        : commonText.regular(
                                                          text: '${controller.studentsListDataList[index].id}',
                                                          fontSize: MySize.getScaledSizeHeight(14),
                                                          textColor: color.textFieldTextColor,
                                                        ),
                                                  ],
                                                ),
                                              ),
                                              commonWidget.commonDivider(color: color.dividerColor),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: MySize.getScaledSizeHeight(12),
                                                  vertical: MySize.getScaledSizeHeight(14),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        commonText.regular(
                                                          text: AppMessage.relation,
                                                          fontSize: MySize.getScaledSizeHeight(14),
                                                          textColor: color.textFieldTextColor,
                                                        ),
                                                        commonText.regular(
                                                          text: '${controller.studentsListDataList[index].relationToChild}',
                                                          fontSize: MySize.getScaledSizeHeight(14),
                                                          textColor: color.black,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        commonText.regular(
                                                          text: AppMessage.frequencyAttendance,
                                                          fontSize: MySize.getScaledSizeHeight(14),
                                                          textColor: color.textFieldTextColor,
                                                        ),
                                                        10.0.wSpace(),
                                                        Flexible(
                                                          child: commonText.regular(
                                                            text: controller.studentsListDataList[index].shiftName,
                                                            fontSize: MySize.getScaledSizeHeight(14),
                                                            textColor: color.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ).paddingOnly(top: MySize.getScaledSizeHeight(16)),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        commonText.regular(
                                                          text: 'Reason',
                                                          fontSize: MySize.getScaledSizeHeight(14),
                                                          textColor: color.textFieldTextColor,
                                                        ),
                                                        10.0.wSpace(),
                                                        Flexible(
                                                          child: commonText.regular(
                                                            text: controller.studentsListDataList[index].rejectedReason ?? '',
                                                            fontSize: MySize.getScaledSizeHeight(14),
                                                            textColor: color.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ).paddingOnly(top: MySize.getScaledSizeHeight(16)),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        commonText.regular(
                                                          text: 'Status',
                                                          fontSize: MySize.getScaledSizeHeight(14),
                                                          textColor: color.textFieldTextColor,
                                                        ),
                                                        10.0.wSpace(),
                                                        Flexible(
                                                          child: commonText.regular(
                                                            text:
                                                                controller.studentsListDataList[index].requestStatus == 'accepted'
                                                                    ? "Accepted"
                                                                    : controller.studentsListDataList[index].requestStatus == 'pending'
                                                                    ? AppMessage.waiting
                                                                    : "Rejected",
                                                            fontSize: MySize.getScaledSizeHeight(14),
                                                            textColor:
                                                                controller.studentsListDataList[index].requestStatus == 'accepted'
                                                                    ? Colors.green
                                                                    : Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ).paddingOnly(top: MySize.getScaledSizeHeight(16)),
                                                    20.0.hSpace(),
                                                    commonWidget
                                                        .customButton(
                                                          text: AppMessage.viewDetails,
                                                          onTap: () {
                                                            Get.to(
                                                              () => StudentDetailsView(),
                                                              arguments: {'studentId': controller.studentsListDataList[index].id},
                                                            )?.then((value) {
                                                              if (value != null) {
                                                                controller.studentsListAPI();
                                                                controller.update();
                                                              }
                                                            });
                                                          },
                                                        )
                                                        .paddingSymmetric(horizontal: MySize.getScaledSizeHeight(3)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return 16.0.hSpace();
                                      },
                                    )
                                : ListView.separated(
                                  itemCount: 3,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return diagonalShimmer(
                                      height: MySize.getScaledSizeHeight(205),
                                      width: Get.width,
                                      borderRadius: BorderRadius.circular(8),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return 16.0.hSpace();
                                  },
                                ),
                            Obx(() {
                              return controller.isLoadMoreRunning.value == true ? Center(child: CommonLoader()) : Container();
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
