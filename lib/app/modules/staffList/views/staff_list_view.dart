import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/common.dart';
import 'package:radianthyve_unified/app/modules/addStaff/views/add_staff_view.dart';
import 'package:radianthyve_unified/app/modules/staffDetails/views/staff_details_view.dart';
import 'package:radianthyve_unified/commonWidgets/NoData.dart';
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
import '../../../../commonWidgets/constant.dart';
import '../controllers/staff_list_controller.dart';

class StaffListView extends GetView<StaffListController> {
  const StaffListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StaffListController>(
      init: StaffListController(),
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
                text: AppMessage.staffList,
                fontSize: MySize.getScaledSizeHeight(18),
                textColor: color.white,
              ),
              centerTitle: false,
              backgroundColor: color.appColor,
            ),
            drawer: drawer(),
            floatingActionButton: InkWell(
              onTap: () {
                Get.to(() => AddStaffView(), arguments: {"is_edit": 0})!.then((value) {
                  if (value == 1) {
                    controller.listStaffAPI();
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
                            onChanged: (value) {
                              if (value == '') {
                                controller.listStaffAPI();
                              }
                            },
                            onSubmitted: (value) {
                              controller.listStaffAPI();
                            },
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
                    ],
                  ),
                  15.0.hSpace(),
                  Expanded(
                    child: Obx(() {
                      return controller.isLoading.value
                          ? ListView.separated(
                              itemCount: 3,
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return diagonalShimmer(
                                  height: MySize.getScaledSizeHeight(245),
                                  width: Get.width,
                                  borderRadius: BorderRadius.circular(8),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return 16.0.hSpace();
                              },
                            )
                          : controller.staffList.isEmpty
                              ? RefreshIndicator(
                                  onRefresh: () async {
                                    controller.listStaffAPI();
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
                                    controller.listStaffAPI();
                                  },
                                  backgroundColor: color.white,
                                  color: color.appColor,
                                  child: ListView.separated(
                                    itemCount: controller.staffList.length,
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
                                                  commonText.medium(
                                                    text: controller.staffList[index].fullName ?? "",
                                                    fontSize: MySize.getScaledSizeHeight(16),
                                                    textColor: color.black,
                                                    maxLines: 1,
                                                  ),
                                                  commonText.regular(
                                                    text: "${controller.staffList[index].id ?? "0"}",
                                                    fontSize: MySize.getScaledSizeHeight(14),
                                                    textColor: color.black,
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
                                                        text: AppMessage.clockInTime,
                                                        fontSize: MySize.getScaledSizeHeight(14),
                                                        textColor: color.textFieldTextColor,
                                                      ),
                                                      commonText.medium(
                                                        text: controller.staffList[index].clockInTime == null
                                                            ? "-"
                                                            : commonMethod.convertToTime(controller.staffList[index].clockInTime.toString()),
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
                                                        text: AppMessage.clockOutTime,
                                                        fontSize: MySize.getScaledSizeHeight(14),
                                                        textColor: color.textFieldTextColor,
                                                      ),
                                                      commonText.medium(
                                                        text: controller.staffList[index].clockOutTime == null
                                                            ? "-"
                                                            : commonMethod.convertToTime(controller.staffList[index].clockOutTime.toString()),
                                                        fontSize: MySize.getScaledSizeHeight(14),
                                                        textColor: color.black,
                                                      ),
                                                    ],
                                                  ),
                                                  20.0.hSpace(),
                                                  commonWidget
                                                      .customButton(
                                                        text: AppMessage.viewProfile,
                                                        onTap: () {
                                                          Get.to(() => StaffDetailsView(), arguments: {
                                                            "staff_id": controller.staffList[index].id,
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
                                  ),
                                );
                    }),
                  ),
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
}
