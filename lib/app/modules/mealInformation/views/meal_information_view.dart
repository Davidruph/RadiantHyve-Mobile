import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../addMenu/views/add_menu_view.dart';
import '../controllers/meal_information_controller.dart';

class MealInformationView extends GetView<MealInformationController> {
  const MealInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MealInformationController>(
      init: MealInformationController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: AppMessage.mealDetails,
            backgroundColor: color.transparentColor,
            actions: [Button().paddingOnly(right: MySize.getScaledSizeHeight(12), top: MySize.getScaledSizeHeight(12))],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonText.regular(text: AppMessage.thisMenuIsMeantForWhichMeal, fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                  12.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(height: MySize.getScaledSizeHeight(16), width: MySize.getScaledSizeWidth(71), borderRadius: BorderRadius.circular(4)),
                          diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: MySize.getScaledSizeWidth(118), borderRadius: BorderRadius.circular(4)),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(text: AppMessage.mealType, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                          commonText.regular(text: "${controller.getMenuData?.menuType ?? ''}", fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                        ],
                      ),
                  16.0.hSpace(),
                  commonText.regular(text: AppMessage.whenWouldYouLikeToServeTheMenu, fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                  12.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(height: MySize.getScaledSizeHeight(16), width: MySize.getScaledSizeWidth(34), borderRadius: BorderRadius.circular(4)),
                          diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: MySize.getScaledSizeWidth(88), borderRadius: BorderRadius.circular(4)),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(text: AppMessage.date, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                          commonText.regular(text: controller.formatDate(controller.getMenuData?.menuDate), fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                        ],
                      ),
                  12.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(height: MySize.getScaledSizeHeight(16), width: MySize.getScaledSizeWidth(36), borderRadius: BorderRadius.circular(4)),
                          diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: MySize.getScaledSizeWidth(74), borderRadius: BorderRadius.circular(4)),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(text: AppMessage.time, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                          commonText.regular(text: controller.formatTime(controller.getMenuData?.menuTime), fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                        ],
                      ),
                  16.0.hSpace(),
                  commonText.regular(text: AppMessage.WhatWouldYouLikeToAdd, fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                  12.0.hSpace(),
                  controller.isLoading.value
                      ? diagonalShimmer(height: MySize.getScaledSizeHeight(16), width: MySize.getScaledSizeWidth(80), borderRadius: BorderRadius.circular(4))
                      : commonText.regular(text: AppMessage.aboutMeal, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                  12.0.hSpace(),
                  controller.isLoading.value
                      ? Column(
                        children: [
                          diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: Get.width, borderRadius: BorderRadius.circular(4)),
                          06.0.hSpace(),
                          diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: Get.width, borderRadius: BorderRadius.circular(4)),
                          06.0.hSpace(),
                          diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: Get.width, borderRadius: BorderRadius.circular(4)),
                        ],
                      )
                      : commonText.regular(text: '${controller.getMenuData?.aboutMeal ?? ''}', fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                  16.0.hSpace(),
                  commonText.regular(text: AppMessage.selectYourWeeklySchedule, fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                  12.0.hSpace(),
                  controller.isLoading.value
                      ? GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, mainAxisExtent: MySize.getScaledSizeHeight(38)),
                        itemCount: controller.weeklyScheduleList.length,
                        itemBuilder: (context, index) {
                          return diagonalShimmer(height: MySize.getScaledSizeHeight(38), width: MySize.getScaledSizeHeight(80), borderRadius: BorderRadius.circular(8));
                        },
                      )
                      : GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, mainAxisExtent: MySize.getScaledSizeHeight(38)),
                        itemCount: controller.weeklyScheduleList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: MySize.getScaledSizeHeight(38),
                              width: MySize.getScaledSizeHeight(80),
                              decoration: BoxDecoration(
                                color: controller.weeklyScheduleList[index]['isSelect'] == true ? color.appColor : color.backgroundColor,
                                border: Border.all(color: controller.weeklyScheduleList[index]['isSelect'] == true ? color.appColor : color.onboardingBorderColor),
                                borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                              ),
                              child: Center(
                                child: commonText.regular(
                                  text: controller.weeklyScheduleList[index]['day'],
                                  fontSize: MySize.getScaledSizeHeight(14),
                                  textColor: controller.weeklyScheduleList[index]['isSelect'] == true ? color.white : color.onboardingTextColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  19.0.hSpace(),
                  commonText.regular(text: AppMessage.whenStudentYouLikeToServeTheMenu, fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                  12.0.hSpace(),
                  controller.allStudent == true
                      ? controller.isLoading.value
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: MySize.getScaledSizeWidth(41), borderRadius: BorderRadius.circular(4)),
                              diagonalShimmer(height: MySize.getScaledSizeHeight(20), width: MySize.getScaledSizeWidth(56), borderRadius: BorderRadius.circular(4)),
                            ],
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              commonText.regular(text: AppMessage.selected, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                              commonText.regular(text: 'All Students', fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                            ],
                          )
                      : controller.isLoading.value
                      ? diagonalShimmer(height: MySize.getScaledSizeHeight(137), width: Get.width, borderRadius: BorderRadius.circular(8))
                      : Container(
                        decoration: BoxDecoration(color: color.white, borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8)))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(12), vertical: MySize.getScaledSizeHeight(15)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  commonText.medium(text: controller.getMenuData?.student?.fullName ?? '', fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                                  commonText.regular(text: '${controller.getMenuData?.student?.id ?? ''}', fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                                ],
                              ),
                            ),
                            commonWidget.commonDivider(color: color.dividerColor),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(12), vertical: MySize.getScaledSizeHeight(14)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      commonText.regular(text: AppMessage.homePhoneNumber, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                                      commonText.regular(
                                        text: '${controller.getMenuData?.student?.countryCode ?? ''} ${controller.getMenuData?.student?.mobileNo ?? ''}',
                                        fontSize: MySize.getScaledSizeHeight(14),
                                        textColor: color.black,
                                      ),
                                    ],
                                  ),
                                  16.0.hSpace(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      commonText.regular(text: AppMessage.frequencyAttendance, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                                      commonText.regular(text: controller.getMenuData?.student?.shiftName ?? '', fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                                    ],
                                  ),
                                ],
                              ),
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

class Button extends StatelessWidget {
  const Button({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 20,
      child: GestureDetector(
        child: Icon(Icons.more_vert_outlined),
        onTap: () {
          showPopover(
            context: context,
            bodyBuilder: (context) => ListItems(),
            onPop: () => print('Popover was popped!'),
            direction: PopoverDirection.bottom,
            backgroundColor: Colors.white,
            width: MySize.getScaledSizeWidth(247),
            height: MySize.getScaledSizeHeight(108),
            // arrowHeight: 16,
            // arrowWidth: 28,
          );
        },
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  ListItems({super.key});

  MealInformationController controller = Get.put(MealInformationController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _commonRowImageWithText(
            image: icons.editIcon,
            text: AppMessage.edit,
            onTap: () {
              Get.back();
              Get.to(() => AddMenuView(), arguments: {'flag': 'editMenu', "getMenuData": controller.getMenuData, "menuId": controller.menuId});
            },
          ),
          14.0.hSpace(),
          commonWidget.commonDivider(color: color.divider2Color),
          14.0.hSpace(),
          _commonRowImageWithText(
            image: icons.deleteIcon,
            text: AppMessage.delete,
            onTap: () {
              Get.back();
              deleteCertificationDialog(context: context);
            },
          ),
        ],
      ),
    );
  }

  Widget _commonRowImageWithText({image, text, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(image, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
          10.0.wSpace(),
          commonText.regular(textAlign: TextAlign.center, text: text ?? "", fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
        ],
      ),
    );
  }

  void deleteCertificationDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(20))),
          child: Container(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                commonText.medium(text: AppMessage.deleteThisMenu, fontSize: MySize.getScaledSizeHeight(18), textColor: color.black, textAlign: TextAlign.center),
                30.0.hSpace(),
                ZoomIn(duration: Duration(seconds: 3), child: Image.asset(images.deleteImage, height: MySize.getScaledSizeHeight(80), width: MySize.getScaledSizeWidth(80))),
                30.0.hSpace(),
                commonText
                    .medium(text: AppMessage.areYouSureYouWantToDeleteTheseMenu, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black, textAlign: TextAlign.center)
                    .paddingSymmetric(horizontal: MySize.getScaledSizeHeight(14)),
                30.0.hSpace(),
                Obx(() {
                  return commonWidget.customButton(
                    isLoading: controller.isDeleteLoading.value,
                    buttonColor: color.textFieldErrorColor,
                    text: AppMessage.yesDelete,
                    onTap: () {
                      controller.deleteMenuApi();
                    },
                  );
                }),
                16.0.hSpace(),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: MySize.getScaledSizeHeight(52),
                    width: Get.width,
                    decoration: BoxDecoration(color: color.homeTextColor, borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8)))),
                    child: Center(child: commonText.medium(text: AppMessage.cancel, textColor: color.cancelColor, fontSize: MySize.getScaledSizeHeight(16))),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
