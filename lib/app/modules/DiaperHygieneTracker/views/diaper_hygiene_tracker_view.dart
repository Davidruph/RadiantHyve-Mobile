import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/AddDiaper/views/add_diaper_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/constant.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common.dart';
import 'package:readmore/readmore.dart';
import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/diaper_hygiene_tracker_controller.dart';

class DiaperHygieneTrackerView extends GetView<DiaperHygieneTrackerController> {
  const DiaperHygieneTrackerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiaperHygieneTrackerController>(
      init: DiaperHygieneTrackerController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: Color(0xffF9F9F9) ,
          appBar: commonWidget.appBar(
              titleText: 'Diaper & Hygiene Tracker',
              backgroundColor: color.transparentColor,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.black),
              ),
            ),
          floatingActionButton: InkWell(
            onTap: () {
              if (controller.selectedIndex.value == 0) {
                Get.to(() => AddDiaperView(), arguments: {'type': 'Diaper', 'selectedIndex': controller.selectedIndex.value})?.then((value) {
                  if (value != null) {
                    controller.selectedIndex.value = value['selectedIndex'];
                    controller.listDiaperAndBathApi();
                    controller.update();
                  }
                });
              } else {
                Get.to(() => AddDiaperView(), arguments: {'type': 'Give Bath', 'selectedIndex': controller.selectedIndex.value})?.then((value) {
                  if (value != null) {
                    controller.selectedIndex.value = value['selectedIndex'];
                    controller.listDiaperAndBathApi();
                    controller.update();
                  }
                },);
              }
            },
            child: Container(
              height: MySize.getScaledSizeHeight(50),
              width: MySize.getScaledSizeWidth(50),
              decoration: BoxDecoration(shape: BoxShape.circle, color: color.buttonColor),
              child: Icon(Icons.add_outlined, size: MySize.getScaledSizeHeight(30), color: color.white),
            ).paddingOnly(bottom: MySize.getScaledSizeHeight(28)),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Obx(
                    () => IntrinsicHeight(
                      child: Container(
                        decoration: BoxDecoration(color: color.appColor, borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8))),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [tabItem('Diaper Changed', 0), tabItem('Give Bath', 1)]),
                      ),
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
                                                              text: AppMessage.reason,
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
                                                                      fontFamily: 'Regular'
                                                                  ),
                                                                ),
                                                              ),
                                                            )
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
                                                              text: convertDateTimeFormat(controller.listDiaperAndBathData[index].createdAt ?? ''),
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
                                        return diagonalShimmer(
                                          height: MySize.getScaledSizeHeight(205),
                                          width: Get.width,
                                          borderRadius: BorderRadius.circular(8),
                                        );
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
                }),
              ],
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
          borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(25), vertical: MySize.getScaledSizeHeight(0)),
          child: Center(child: commonText.medium(text: title, textColor: color.white, fontSize: MySize.getScaledSizeHeight(16))),
        ),
      ),
    );
  }
}
