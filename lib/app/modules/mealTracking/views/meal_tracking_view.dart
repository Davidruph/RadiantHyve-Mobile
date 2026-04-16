import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/noDataFound.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../addMenu/views/add_menu_view.dart';
import '../../mealInformation/views/meal_information_view.dart';
import '../controllers/meal_tracking_controller.dart';

class MealTrackingView extends GetView<MealTrackingController> {
  const MealTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MealTrackingController>(
      init: MealTrackingController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: 'Meal', 
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
              Get.to(() => AddMenuView())?.then((value) {
                if (value == 1) {
                  controller.listMenuStudentApi();
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
          body: Obx(() {
            return Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: RefreshIndicator(
                displacement: 30,
                backgroundColor: color.white,
                color: color.appColor,
                strokeWidth: 3,
                onRefresh: () async {
                  controller.page = 1;
                  controller.hasNextPage.value = true;
                  controller.listMenuStudentApi();
                },
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: Get.height * 0.8),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !controller.isLoading.value
                              ? controller.menuStudentDataList.isEmpty && controller.isLoading.value == true
                                  ? buildNoDataWidget(height: Get.height / 1.5)
                                  : controller.menuStudentDataList.isEmpty
                                  ? buildNoDataWidget(height: Get.height / 1.5)
                                  : ListView.separated(
                                    itemCount: controller.menuStudentDataList.length,
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
                                                text: controller.menuStudentDataList[index].menuType,
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
                                                        text: AppMessage.student,
                                                        fontSize: MySize.getScaledSizeHeight(14),
                                                        textColor: color.textFieldTextColor,
                                                      ),
                                                      commonText.regular(
                                                        text:
                                                            controller.menuStudentDataList[index].isAll == true
                                                                ? "All Student"
                                                                : controller.menuStudentDataList[index].studentName ?? '',
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
                                                        text: AppMessage.date,
                                                        fontSize: MySize.getScaledSizeHeight(14),
                                                        textColor: color.textFieldTextColor,
                                                      ),
                                                      commonText.regular(
                                                        text: controller.formatDate(controller.menuStudentDataList[index].menuDate),
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
                                                        text: controller.formatTime(controller.menuStudentDataList[index].menuTime),
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
                                                          if (controller.menuStudentDataList[index].isAll == true) {
                                                            Get.to(
                                                              () => MealInformationView(),
                                                              arguments: {"menuId": controller.menuStudentDataList[index].id, 'allStudent': true},
                                                            )?.then((value) {
                                                              if (value != null) {
                                                                controller.listMenuStudentApi();
                                                              }
                                                            });
                                                          } else {
                                                            Get.to(
                                                              () => MealInformationView(),
                                                              arguments: {"menuId": controller.menuStudentDataList[index].id, 'allStudent': false},
                                                            );
                                                          }
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
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return diagonalShimmer(
                                    height: MySize.getScaledSizeHeight(242),
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
              ),
            );
          }),
        );
      },
    );
  }
}
