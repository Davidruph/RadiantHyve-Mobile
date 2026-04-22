import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart' as AppColorAlias;
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/utils/common.dart';
import 'package:readmore/readmore.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_drawer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../addLeave/views/add_leave_view.dart';
import '../controllers/my_leave_controller.dart';

class MyLeaveView extends GetView<MyLeaveController> {
  const MyLeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyLeaveController>(
      init: MyLeaveController(),
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
              text: AppMessage.myLeave,
              fontSize: MySize.getScaledSizeHeight(18),
              textColor: color.white,
            ),
            centerTitle: false,
            backgroundColor: Colors.transparent,
          ),
          drawer: drawer(),
          floatingActionButton:
              controller.selectedMonths.isEmpty ||
                      controller.selectedMonths.contains("This Month")
                  ? InkWell(
                    onTap: () {
                      Get.to(() => AddLeaveView())?.then((value) {
                        if (value == 1) {
                          controller.listLeaveTeacherApi();
                          controller.update();
                        }
                      });
                    },
                    child: Container(
                      height: MySize.getScaledSizeHeight(50),
                      width: MySize.getScaledSizeWidth(50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.buttonColor,
                      ),
                      child: Icon(
                        Icons.add_outlined,
                        size: MySize.getScaledSizeHeight(30),
                        color: color.white,
                      ),
                    ).paddingOnly(bottom: MySize.getScaledSizeHeight(28)),
                  )
                  : SizedBox(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child:
                          controller.selectedMonths.isEmpty ||
                                  controller.selectedMonths.contains(
                                    "This Month",
                                  )
                              ? Align(
                                alignment: Alignment.centerLeft,
                                child: commonText.medium(
                                  text: 'This Month',
                                  textColor: color.black,
                                  fontSize: MySize.getScaledSizeHeight(18),
                                ),
                              )
                              : SizedBox(
                                height: MySize.getScaledSizeHeight(40),
                                // You can adjust height
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.selectedMonths.length,
                                  itemBuilder: (context, index) {
                                    final month =
                                        controller.selectedMonths[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              MySize.getScaledSizeHeight(10),
                                          vertical: MySize.getScaledSizeHeight(
                                            6,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              color
                                                  .notificationContainerColor,
                                          borderRadius: BorderRadius.circular(
                                            MySize.getScaledSizeHeight(8),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            commonText.medium(
                                              text: month,
                                              textColor: color.black,
                                              fontSize:
                                                  MySize.getScaledSizeHeight(
                                                    16,
                                                  ),
                                              maxLines: 1,
                                            ),
                                            6.0.wSpace(),
                                            GestureDetector(
                                              onTap: () {
                                                controller.selectedMonths
                                                    .remove(month);
                                                int removeIndex = controller
                                                    .getPastMonthsOfCurrentYearList()
                                                    .indexWhere(
                                                      (item) =>
                                                          item['month'] ==
                                                          month,
                                                    );
                                                controller.selectedIndexes
                                                    .remove(removeIndex);
                                                controller
                                                    .onApplyFilterButtonPressed();
                                                if (controller
                                                    .selectedIndexes
                                                    .isEmpty) {
                                                  controller
                                                      .selectedMonthIndexes
                                                      .clear();
                                                  controller
                                                      .listLeaveTeacherApi();
                                                }
                                                controller.update();
                                              },
                                              child: Icon(
                                                Icons.close,
                                                color:
                                                    color
                                                        .textFieldErrorColor,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                    ),
                    8.0.wSpace(),
                    GestureDetector(
                      onTap: () {
                        filterBottomSheet(context: context);
                      },
                      child: Container(
                        height: MySize.getScaledSizeHeight(38),
                        width: MySize.getScaledSizeHeight(38),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(MySize.getScaledSizeHeight(50)),
                          ),
                          border: Border.all(
                            color: color.leaveCalenderColor,
                          ),
                        ),
                        padding: EdgeInsets.all(MySize.getScaledSizeHeight(8)),
                        child: Image.asset(icons.filterIcon),
                      ),
                    ),
                  ],
                ),

                16.0.hSpace(),

                Obx(() {
                  return Expanded(
                    child: RefreshIndicator(
                      displacement: 30,
                      backgroundColor: color.white,
                      color: color.appColor,
                      strokeWidth: 3,
                      onRefresh: () async {
                        controller.page = 1;
                        controller.listLeaveTeacherApi();
                      },
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        physics: AlwaysScrollableScrollPhysics(
                          parent: ClampingScrollPhysics(),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: Get.height * 0.8,
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                !controller.isLoading.value
                                    ? controller
                                            .listLeaveTeacherDataList
                                            .isEmpty
                                        ? buildNoDataWidget(
                                          height: Get.height / 1.5,
                                        )
                                        : ListView.separated(
                                          itemCount:
                                              controller
                                                  .listLeaveTeacherDataList
                                                  .length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: color.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    MySize.getScaledSizeHeight(
                                                      8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                      MySize.getScaledSizeHeight(
                                                        12,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        commonText.medium(
                                                          text:
                                                              controller
                                                                  .listLeaveTeacherDataList[index]
                                                                  .leaveType,
                                                          textColor:
                                                              color.black,
                                                          fontSize:
                                                              MySize.getScaledSizeHeight(
                                                                16,
                                                              ),
                                                        ),
                                                        Spacer(),

                                                        controller
                                                                    .listLeaveTeacherDataList[index]
                                                                    .leaveRequestStatus ==
                                                                'pending'
                                                            ? 10.0.wSpace()
                                                            : 0.0.wSpace(),
                                                        controller
                                                                    .listLeaveTeacherDataList[index]
                                                                    .leaveRequestStatus ==
                                                                'pending'
                                                            ? buildPopupMenu(
                                                              context,
                                                              index,
                                                            )
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          controller
                                                                      .listLeaveTeacherDataList[index]
                                                                      .leaveRequestStatus ==
                                                                  'accepted'
                                                              ? color
                                                                  .presentBackgroundColor
                                                              : controller
                                                                      .listLeaveTeacherDataList[index]
                                                                      .leaveRequestStatus ==
                                                                  'pending'
                                                              ? color
                                                                  .viewStudentsColor
                                                              : color
                                                                  .absentBackgroundColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(
                                                              MySize.getScaledSizeHeight(
                                                                50,
                                                              ),
                                                            ),
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                        vertical:
                                                            MySize.getScaledSizeHeight(
                                                              4,
                                                            ),
                                                        horizontal:
                                                            MySize.getScaledSizeHeight(
                                                              20,
                                                            ),
                                                      ),
                                                      child: commonText.regular(
                                                        text:
                                                            controller
                                                                        .listLeaveTeacherDataList[index]
                                                                        .leaveRequestStatus ==
                                                                    'accepted'
                                                                ? "Accepted"
                                                                : controller
                                                                        .listLeaveTeacherDataList[index]
                                                                        .leaveRequestStatus ==
                                                                    'pending'
                                                                ? 'Pending'
                                                                : "rejected",
                                                        textColor:
                                                            controller
                                                                        .listLeaveTeacherDataList[index]
                                                                        .leaveRequestStatus ==
                                                                    'accepted'
                                                                ? Color(
                                                                  0xff1BA345,
                                                                )
                                                                : controller
                                                                        .listLeaveTeacherDataList[index]
                                                                        .leaveRequestStatus ==
                                                                    'pending'
                                                                ? Color(
                                                                  0xffBF8608,
                                                                )
                                                                : Color(
                                                                  0xffFF7373,
                                                                ),
                                                        fontSize:
                                                            MySize.getScaledSizeHeight(
                                                              14,
                                                            ),
                                                      ),
                                                    ),
                                                  ).paddingOnly(
                                                    left:
                                                        MySize.getScaledSizeHeight(
                                                          16,
                                                        ),
                                                    bottom:
                                                        MySize.getScaledSizeHeight(
                                                          16,
                                                        ),
                                                  ),
                                                  commonWidget.commonDivider(
                                                    color:
                                                        color.dividerColor,
                                                  ),
                                                  07.0.hSpace(),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left:
                                                          MySize.getScaledSizeHeight(
                                                            12,
                                                          ),
                                                      right:
                                                          MySize.getScaledSizeHeight(
                                                            12,
                                                          ),
                                                      bottom:
                                                          MySize.getScaledSizeHeight(
                                                            14,
                                                          ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        commonText.regular(
                                                          text:
                                                              AppMessage
                                                                  .dateOfLeave,
                                                          textColor:
                                                              color
                                                                  .textFieldTextColor,
                                                          fontSize:
                                                              MySize.getScaledSizeHeight(
                                                                14,
                                                              ),
                                                        ),
                                                        08.0.hSpace(),
                                                        commonText.regular(
                                                          text: convertDateFormat(
                                                            controller
                                                                .listLeaveTeacherDataList[index]
                                                                .date,
                                                          ),
                                                          textColor:
                                                              color.black,
                                                          fontSize:
                                                              MySize.getScaledSizeHeight(
                                                                14,
                                                              ),
                                                        ),
                                                        08.0.hSpace(),
                                                        commonText.regular(
                                                          text:
                                                              AppMessage.reason,
                                                          textColor:
                                                              color
                                                                  .textFieldTextColor,
                                                          fontSize:
                                                              MySize.getScaledSizeHeight(
                                                                14,
                                                              ),
                                                        ),
                                                        08.0.hSpace(),
                                                        ReadMoreText(
                                                          '${controller.listLeaveTeacherDataList[index].reason}',
                                                          trimLines: 3,
                                                          colorClickableText:
                                                              color
                                                                  .appColor,
                                                          trimMode:
                                                              TrimMode.Line,
                                                          trimCollapsedText:
                                                              ' Read more',
                                                          trimExpandedText:
                                                              ' Read less',
                                                          style: TextStyle(
                                                            fontSize:
                                                                MySize.getScaledSizeHeight(
                                                                  14,
                                                                ),
                                                            color: Color(
                                                              0xff1F1F1F,
                                                            ),
                                                            fontFamily:
                                                                'Regular',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return 15.0.hSpace();
                                          },
                                        )
                                    : ListView.separated(
                                      itemCount: 3,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return diagonalShimmer(
                                          height: MySize.getScaledSizeHeight(
                                            254
                                          ),
                                          width: Get.width,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return 15.0.hSpace();
                                      },
                                    ),

                                Obx(() {
                                  return controller.isLoadMoreRunning.value ==
                                          true
                                      ? Center(child: CommonLoader())
                                      : Container();
                                }),
                              ],
                            ),
                          ),
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

  filterBottomSheet({required BuildContext context}) {
    MyLeaveController controller =Get.put(MyLeaveController());
    return commonWidget.bottomSheet(
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              4.0.hSpace(),
              commonText.semiBold(
                text: AppMessage.filter,
                fontSize: MySize.getScaledSizeHeight(20),
                textColor: color.black,
              ),
              20.0.hSpace(),
              commonWidget.commonDivider(
                color: color.notificationContainerColor,
              ),
              16.0.hSpace(),
              ListView.builder(
                itemCount: controller.getPastMonthsOfCurrentYearList().length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String monthName =
                      controller
                          .getPastMonthsOfCurrentYearList()[index]['month']!;
                  bool isSelected = controller.selectedIndexes.contains(index);

                  return InkWell(
                    onTap: () {
                      if (isSelected) {
                        controller.selectedIndexes.remove(index);
                        controller.selectedMonths.remove(monthName);
                      } else {
                        controller.selectedIndexes.add(index);
                        controller.selectedMonths.add(monthName);
                      }
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText.regular(
                          text: monthName,
                          fontSize: MySize.getScaledSizeHeight(16),
                          textColor: color.textFieldTextColor,
                        ),
                        Image.asset(
                          isSelected ? icons.circleCheck : icons.circleUnCheck,
                          height: MySize.getScaledSizeHeight(24),
                          width: MySize.getScaledSizeWidth(24),
                        ),
                      ],
                    ).paddingOnly(bottom: MySize.getScaledSizeHeight(22)),
                  );
                },
              ),

              60.0.hSpace(),

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
                            Radius.circular(MySize.getScaledSizeHeight(8)),
                          ),
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
                      // buttonColor: color.appColor,
                      gradient: color.buttonGradient,
                      onTap: () async {
                        Get.back();
                        controller.applyMonthYearFilter(
                          selectedMonthNames: controller.selectedMonths,
                          selectedYearValue: controller.selectedYear,
                        );
                        await controller.listLeaveTeacherApi();
                        controller.onApplyFilterButtonPressed();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(
            horizontal: MySize.getScaledSizeWidth(16),
            vertical: MySize.getScaledSizeHeight(16),
          );
        },
      ),
    );
  }

  Widget buildPopupMenu(BuildContext context, int index) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        handleMenuItemSelected(value, context, index);
      },
      color: Colors.white,
      surfaceTintColor: Colors.white,
      position: PopupMenuPosition.under,
      shadowColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySize.getScaledSizeWidth(12)),
      ),
      offset: Offset(0, MySize.getScaledSizeHeight(8)),
      // Optional: extra vertical spacing from icon
      padding: EdgeInsets.zero,
      // Avoid extra space between icon and popup
      child: Container(
        height: MySize.getScaledSizeHeight(32),
        width: MySize.getScaledSizeHeight(32),
        decoration: BoxDecoration(shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(Icons.more_vert, size: 20, color: Colors.black),
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'Cancel Leave',
            padding: EdgeInsets.symmetric(
              horizontal: MySize.getScaledSizeWidth(12),
              vertical: MySize.getScaledSizeHeight(8),
            ),
            child: commonText.medium(
              text: 'Cancel Leave',
              fontSize: MySize.getScaledSizeHeight(14),
              textColor: Colors.red,
            ),
          ),
        ];
      },
    );
  }

  void handleMenuItemSelected(String value, BuildContext context, index) {
    switch (value) {
      case "Cancel Leave":
        controller.cancelLeaveApi(index: index);
        break;
    }
    controller.update();
  }
}
