import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/mealInformation/views/meal_information_view.dart';
import 'package:radianthyve_unified/app/modules/medicationInformation/views/medication_information_view.dart';
import 'package:radianthyve_unified/app/modules/sleepLogsDetails/views/sleep_logs_details_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import 'package:readmore/readmore.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../controllers/child_report_details_controller.dart';

class ChildReportDetailsView extends GetView<ChildReportDetailsController> {
  const ChildReportDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChildReportDetailsController>(
      init: ChildReportDetailsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
              titleText: 'Dianne Howard',
              backgroundColor: color.transparentColor,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.black),
              ),
            ),
          body: Column(
            children: [
              TabBar(
                splashFactory: NoSplash.splashFactory,
                labelStyle: TextStyle(fontSize: MySize.getScaledSizeHeight(14), fontWeight: FontWeight.w500),
                unselectedLabelStyle: TextStyle(fontSize: MySize.getScaledSizeHeight(14), fontWeight: FontWeight.w400),
                controller: controller.tabController,
                dividerColor: color.transparentColor,
                labelColor: color.appColor,
                unselectedLabelColor: color.onboardingTextColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: color.appColor,
                indicator: UnderlineTabIndicator(borderSide: BorderSide(color: color.appColor, width: 2)),
                tabAlignment: TabAlignment.center,
                labelPadding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(20)),
                isScrollable: true,
                splashBorderRadius: const BorderRadius.only(topRight: Radius.circular(100.0), topLeft: Radius.circular(100.0)),
                tabs: [Tab(text: 'Meal'), Tab(text: 'Sleep Logs'), Tab(text: 'Medication'), Tab(text: 'Diaper'), Tab(text: 'Give Bath')],
                onTap: (index) {
                  controller.selectedIndex.value = index;
                  controller.tabIndex.value = index;
                  if (controller.tabIndex.value == 0) {
                    controller.mealTrackingAPI();
                  } else if (controller.tabIndex.value == 1) {
                    controller.sleepLogsAPI();
                  } else if (controller.tabIndex.value == 2) {
                    controller.medicationAPI();
                  } else if (controller.tabIndex.value == 3) {
                    controller.listDiaperAndBathApi();
                  } else {
                    controller.listDiaperAndBathApi();
                  }
                  controller.update();
                },
              ),
              2.0.hSpace(),
              Expanded(child: TabBarView(controller: controller.tabController, children: [meal(), sleepLogs(), medication(), diaper(), diaper()])),
            ],
          ),
        );
      },
    );
  }

  meal() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
        child: RefreshIndicator(
          displacement: 30,
          backgroundColor: color.white,
          color: color.appColor,
          strokeWidth: 3,
          onRefresh: () async {
            controller.mealTrackingPage = 1;
            controller.mealTrackingHasNextPage.value = true;
            controller.mealTrackingAPI();
          },
          child: SingleChildScrollView(
            controller: controller.mealScrollController,
            physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            child: Column(
              children: [
                !controller.isMealTrackingLoading.value
                    ? controller.mealTrackingDataList.isEmpty
                        ? buildNoDataWidget(height: Get.height / 1.4)
                        : ListView.separated(
                          itemCount: controller.mealTrackingDataList.length,
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
                                    child: commonText.medium(
                                      text: controller.mealTrackingDataList[index].menuType,
                                      fontSize: MySize.getScaledSizeHeight(16),
                                      textColor: color.black,
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
                                              text: AppMessage.date,
                                              fontSize: MySize.getScaledSizeHeight(14),
                                              textColor: color.textFieldTextColor,
                                            ),
                                            commonText.regular(
                                              text: controller.formatToDayMonthYear(controller.mealTrackingDataList[index].menuDate),
                                              fontSize: MySize.getScaledSizeHeight(14),
                                              textColor: color.black,
                                            ),
                                          ],
                                        ),
                                        16.0.hSpace(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            commonText.regular(
                                              text: AppMessage.time,
                                              fontSize: MySize.getScaledSizeHeight(14),
                                              textColor: color.textFieldTextColor,
                                            ),
                                            commonText.regular(
                                              text: controller.formatTo12HourTime(controller.mealTrackingDataList[index].menuTime),
                                              fontSize: MySize.getScaledSizeHeight(14),
                                              textColor: color.black,
                                            ),
                                          ],
                                        ),
                                        20.0.hSpace(),
                                        commonWidget
                                            .customButton(
                                              text: AppMessage.viewDetails,
                                              onTap: () {
                                                Get.to(() => MealInformationView(), arguments: {"menuId": controller.mealTrackingDataList[index].id});
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
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return diagonalShimmer(height: MySize.getScaledSizeHeight(242), width: Get.width, borderRadius: BorderRadius.circular(8));
                      },
                      separatorBuilder: (context, index) {
                        return 16.0.hSpace();
                      },
                    ),
                Obx(() {
                  return controller.isMealTrackingLoadMoreRunning.value == true ? Center(child: CommonLoader()) : Container();
                }),
              ],
            ),
          ),
        ),
      );
    });
  }

  sleepLogs() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
        child: RefreshIndicator(
          displacement: 30,
          backgroundColor: color.white,
          color: color.appColor,
          strokeWidth: 3,
          onRefresh: () async {
            controller.sleepLogsPage = 1;
            controller.sleepLogsHasNextPage.value = true;
            controller.sleepLogsAPI();
          },
          child: SingleChildScrollView(
            controller: controller.sleepScrollController,
            physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: Get.height * 0.8),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    !controller.isSleepLogsLoading.value
                        ? controller.sleepLogsData == null
                            ? buildNoDataWidget(height: Get.height / 1.4)
                            : Container(
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
                                          text: controller.sleepLogsData?.studentName,
                                          fontSize: MySize.getScaledSizeHeight(16),
                                          textColor: color.black,
                                        ),
                                        commonText.regular(
                                          text: '${controller.sleepLogsData?.studentId}',
                                          fontSize: MySize.getScaledSizeHeight(14),
                                          textColor: color.textFieldTextColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  commonWidget.commonDivider(color: color.dividerColor),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(12)),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            commonText.regular(
                                              text: AppMessage.sleepSummary,
                                              fontSize: MySize.getScaledSizeHeight(14),
                                              textColor: color.textFieldTextColor,
                                            ),
                                            commonText.regular(
                                              text:
                                                  '${controller.formatTo12HourTime(controller.sleepLogsData?.startTime ?? '')} to ${controller.formatTo12HourTime(controller.sleepLogsData?.endTime ?? '')}',
                                              fontSize: MySize.getScaledSizeHeight(14),
                                              textColor: color.black,
                                            ),
                                          ],
                                        ).paddingOnly(top: MySize.getScaledSizeHeight(16)),
                                        20.0.hSpace(),
                                        commonWidget
                                            .customButton(
                                              text: AppMessage.viewDetails,
                                              onTap: () {
                                                Get.to(() => SleepLogsDetailsView(), arguments: {'sleepLogsData': controller.sleepLogsData});
                                              },
                                            )
                                            .paddingSymmetric(horizontal: MySize.getScaledSizeHeight(3)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        : diagonalShimmer(height: MySize.getScaledSizeHeight(180), width: Get.width, borderRadius: BorderRadius.circular(8)),
                    Obx(() {
                      return controller.isSleepLogsLoadMoreRunning.value == true ? Center(child: CommonLoader()) : Container();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  medication() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
        child: RefreshIndicator(
          displacement: 30,
          backgroundColor: color.white,
          color: color.appColor,
          strokeWidth: 3,
          onRefresh: () async {
            controller.medicationPage = 1;
            controller.medicationHasNextPage.value = true;
            controller.medicationAPI();
          },
          child: SingleChildScrollView(
            controller: controller.medicationScrollController,
            physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: Get.height * 0.8),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    !controller.isMedicationLoading.value
                        ? controller.medicationDataList.isEmpty
                            ? buildNoDataWidget(height: Get.height / 1.4)
                            : ListView.separated(
                              itemCount: controller.medicationDataList.length,
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
                                              text: controller.medicationDataList[index].studentName,
                                              fontSize: MySize.getScaledSizeHeight(16),
                                              textColor: color.black,
                                            ),
                                            commonText.regular(
                                              text: '${controller.medicationDataList[index].studentId}',
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
                                                  text: AppMessage.typeOfDisease,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                  textColor: color.textFieldTextColor,
                                                ),
                                                commonText.regular(
                                                  text: controller.medicationDataList[index].typeDisease,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                  textColor: color.black,
                                                ),
                                              ],
                                            ),
                                            16.0.hSpace(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                commonText.regular(
                                                  text: AppMessage.doctorsName,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                  textColor: color.textFieldTextColor,
                                                ),
                                                commonText.regular(
                                                  text: controller.medicationDataList[index].doctorName,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                  textColor: color.black,
                                                ),
                                              ],
                                            ),
                                            20.0.hSpace(),
                                            commonWidget
                                                .customButton(
                                                  text: AppMessage.viewDetails,
                                                  onTap: () {
                                                    Get.to(
                                                      () => MedicationInformationView(),
                                                      arguments: {'medicationDataList': controller.medicationDataList[index]},
                                                    );
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
                                return 15.0.hSpace();
                              },
                            )
                        : ListView.separated(
                          itemCount: 5,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return diagonalShimmer(height: MySize.getScaledSizeHeight(205), width: Get.width, borderRadius: BorderRadius.circular(8));
                          },
                          separatorBuilder: (context, index) {
                            return 15.0.hSpace();
                          },
                        ),
                    Obx(() {
                      return controller.isMealTrackingLoadMoreRunning.value == true ? Center(child: CommonLoader()) : Container();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  diaper() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
        child: RefreshIndicator(
          displacement: 30,
          backgroundColor: color.white,
          color: color.appColor,
          strokeWidth: 3,
          onRefresh: () async {
            controller.page = 1;
            controller.listDiaperAndBathApi();
          },
          child: SingleChildScrollView(
            controller: controller.scrollController,
            physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: Get.height * 0.8),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    !controller.isLoading.value
                        ? controller.listDiaperAndBathData.isEmpty
                            ? buildNoDataWidget(height: Get.height / 1.5)
                            : ListView.separated(
                              itemCount: controller.listDiaperAndBathData.length,
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
                                          children: [
                                            Spacer(),
                                            commonText.regular(
                                              text: '${controller.listDiaperAndBathData[index].studentId ?? 0}',
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                commonText.regular(
                                                  text: 'Student Name',
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                  textColor: color.textFieldTextColor,
                                                ),
                                                commonText.regular(
                                                  text: controller.listDiaperAndBathData[index].studentName ?? '',
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                  textColor: color.black,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                commonText.regular(
                                                  text: 'Reason',
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                  textColor: color.textFieldTextColor,
                                                ),
                                                10.0.wSpace(),
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.topRight,
                                                    child: ReadMoreText(
                                                      controller.listDiaperAndBathData[index].reason ?? '',
                                                      trimLines: 2,
                                                      colorClickableText: Colors.blue,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText: 'Read more',
                                                      trimExpandedText: ' Read less',
                                                      style: TextStyle(
                                                        fontSize: MySize.getScaledSizeHeight(14),
                                                        color: color.black,
                                                        fontFamily: 'Regular',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ).paddingOnly(top: MySize.getScaledSizeHeight(16)),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                commonText.regular(
                                                  text: 'Date & Time',
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                  textColor: color.textFieldTextColor,
                                                ),
                                                commonText.regular(
                                                  text: controller.convertDateTimeFormat(controller.listDiaperAndBathData[index].createdAt ?? ''),
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                  textColor: color.black,
                                                ),
                                              ],
                                            ).paddingOnly(top: MySize.getScaledSizeHeight(16)),
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
                            return diagonalShimmer(height: MySize.getScaledSizeHeight(205), width: Get.width, borderRadius: BorderRadius.circular(8));
                          },
                          separatorBuilder: (context, index) {
                            return 15.0.hSpace();
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
        ),
      );
    });
  }
}
