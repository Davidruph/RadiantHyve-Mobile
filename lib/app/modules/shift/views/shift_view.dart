import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/addShiftInformation/views/add_shift_information_view.dart';
import 'package:radianthyve_unified/app/modules/shiftDetails/views/shift_details_view.dart';
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
import '../controllers/shift_controller.dart';

class ShiftView extends GetView<ShiftController> {
  const ShiftView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShiftController>(
      init: ShiftController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: controller.scaffoldKey,
            backgroundColor: color.backgroundColor,
            appBar: commonWidget.appBar(
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
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
                text: AppMessage.program,
                fontSize: MySize.getScaledSizeHeight(18),
                textColor: color.white,
              ),
              centerTitle: false,
              backgroundColor: color.appColor,
            ),
            drawer: drawer(),
            floatingActionButton: InkWell(
              onTap: () {
                Get.to(() => AddShiftInformationView())!.then((value) {
                  if (value != null) {
                    controller.listShiftAPI();
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
            body: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)),
                            color: color.onboardingBorderColor,
                          ),
                          child: TextField(
                            cursorColor: color.black,
                            controller: controller.searchController,
                            onSubmitted: (value) {
                              controller.listShiftAPI();
                            },
                            onChanged: (value) {
                              if (value == "") {
                                controller.listShiftAPI();
                              }
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.deny(
                                RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                              ),
                            ],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: MySize.getScaledSizeWidth(16),
                                vertical: MySize.getScaledSizeHeight(14),
                              ),
                              hintText: AppMessage.search,
                              border: InputBorder.none,
                              prefixIcon: Image.asset(icons.searchIcon, scale: 4.0),
                              hintStyle: TextStyle(
                                fontSize: MySize.getScaledSizeHeight(14),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Regular',
                                color: color.onboardingTextColor,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: MySize.getScaledSizeHeight(14),
                              color: color.black,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      // 12.0.wSpace(),
                      // GestureDetector(
                      //   onTap: () {
                      //     FocusManager.instance.primaryFocus?.unfocus();
                      //     filterBottomSheet(context: context);
                      //   },
                      //   child: Container(
                      //     height: MySize.getScaledSizeHeight(48),
                      //     width: MySize.getScaledSizeWidth(48),
                      //     decoration: BoxDecoration(
                      //       color: color.onboardingBorderColor,
                      //       borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                      //     ),
                      //     child: Padding(
                      //       padding: EdgeInsets.all(MySize.getScaledSizeHeight(12)),
                      //       child: Image.asset(icons.filterIcon),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  15.0.hSpace(),
                  Expanded(
                      child: Obx(
                    () => controller.isLoading.value
                        ? ListView.separated(
                            itemCount: 5,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return diagonalShimmer(
                                height: MySize.getScaledSizeHeight(168),
                                width: Get.width,
                                borderRadius: BorderRadius.circular(8),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return 16.0.hSpace();
                            },
                          )
                        : controller.shiftList.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  controller.listShiftAPI();
                                },
                                backgroundColor: color.white,
                                color: color.appColor,
                                child: ListView.separated(
                                  itemCount: controller.shiftList.length,
                                  shrinkWrap: true,
                                  controller: controller.scrollController,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: color.white,
                                        borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: MySize.getScaledSizeHeight(12),
                                              vertical: MySize.getScaledSizeHeight(15),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: commonText.medium(
                                                    text: controller.shiftList[index].shiftName,
                                                    fontSize: MySize.getScaledSizeHeight(16),
                                                    textColor: color.black,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                commonText.regular(
                                                  text: "${controller.shiftList[index].id}",
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
                                                      text: AppMessage.shiftFee,
                                                      fontSize: MySize.getScaledSizeHeight(14),
                                                      textColor: color.textFieldTextColor,
                                                    ),
                                                    commonText.medium(
                                                      text: "\$${controller.shiftList[index].shiftFee}",
                                                      fontSize: MySize.getScaledSizeHeight(14),
                                                      textColor: color.black,
                                                    ),
                                                  ],
                                                ),
                                                20.0.hSpace(),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    commonText.regular(
                                                      text: 'Late Fee',
                                                      fontSize: MySize.getScaledSizeHeight(14),
                                                      textColor: color.textFieldTextColor,
                                                    ),
                                                    commonText.medium(
                                                      text: "\$${controller.shiftList[index].penalty}",
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
                                                        Get.to(() => ShiftDetailsView(), arguments: {
                                                          "details": controller.shiftList[index],
                                                        })?.then(
                                                          (value) {
                                                            if (value != null) {
                                                              if (value == 2) {
                                                                controller.listShiftAPI();
                                                              } else {
                                                                if (controller.shiftList[index].id == value['shiftID']) {
                                                                  controller.shiftList.removeAt(index);
                                                                }
                                                                controller.shiftList[index].shiftFee = value['shift_fee'];
                                                              }
                                                            }
                                                            controller.update();
                                                          },
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
                                    return 16.0.hSpace();
                                  },
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () async {
                                  controller.listShiftAPI();
                                },
                                backgroundColor: color.white,
                                color: color.appColor,
                                child: SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                                  child: NoData(height: Get.height / 1.4, width: Get.width),
                                ),
                              ),
                  )),
                  Obx(() {
                    return controller.isLoadMoreRunning.value == true ? Center(child: CommonLoader()) : SizedBox(height: 0);
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

/*  filterBottomSheet({required context}) {
    return commonWidget.bottomSheet(
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              04.0.hSpace(),
              commonText.semiBold(
                text: AppMessage.filter,
                fontSize: MySize.getScaledSizeHeight(20),
                textColor: color.black,
              ),
              20.0.hSpace(),
              commonWidget.commonDivider(color: color.notificationContainerColor),
              16.0.hSpace(),
              ListView.builder(
                itemCount: controller.filterList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      controller.selectedIndex = index;
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText.regular(
                          text: controller.filterList[index]['shift'],
                          fontSize: MySize.getScaledSizeHeight(16),
                          textColor: color.textFieldTextColor,
                        ),
                        Image.asset(
                          controller.selectedIndex == index ? icons.circleCheck : icons.circleUnCheck,
                          height: MySize.getScaledSizeHeight(24),
                          width: MySize.getScaledSizeWidth(24),
                        ),
                      ],
                    ).paddingOnly(bottom: MySize.getScaledSizeHeight(26)),
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
                          borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
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
                      onTap: () {
                        Get.back();
                      },
                    ),
                  )
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: MySize.getScaledSizeWidth(16), vertical: MySize.getScaledSizeHeight(16));
        },
      ),
    );
  }*/
}
