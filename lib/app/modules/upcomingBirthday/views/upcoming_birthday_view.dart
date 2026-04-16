import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import '../../birthdayDetails/views/birthday_details_view.dart';
import '../controllers/upcoming_birthday_controller.dart';

class UpcomingBirthdayView extends GetView<UpcomingBirthdayController> {
  const UpcomingBirthdayView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpcomingBirthdayController>(
      init: UpcomingBirthdayController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
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
              text: AppMessage.upcomingBirthday,
              fontSize: MySize.getScaledSizeHeight(18),
              textColor: color.white,
            ),
            centerTitle: false,
            backgroundColor: color.appColor,
          ),
          drawer: drawer(),
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
            child: Column(
              children: [
                Center(
                  child: Obx(
                    () => IntrinsicHeight(
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.appColor,
                          borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            tabItem(AppMessage.staffList, 0),
                            tabItem(AppMessage.studentList, 1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                16.0.hSpace(),
                Obx(() {
                  return Expanded(
                    child: controller.isLoading.value
                        ? ListView.separated(
                            itemCount: 5,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
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
                          )
                        : controller.upcomingBirthdayList.isEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  controller.listBirthdayAPI(tab: controller.selectedIndex.value);
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
                                  controller.listBirthdayAPI(tab: controller.selectedIndex.value);
                                },
                                backgroundColor: color.white,
                                color: color.appColor,
                                child: ListView.separated(
                                  itemCount: controller.upcomingBirthdayList.length,
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
                                                Expanded(
                                                  child: commonText.medium(
                                                    text: controller.upcomingBirthdayList[index].fullName,
                                                    fontSize: MySize.getScaledSizeHeight(16),
                                                    textColor: color.black,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                commonText.regular(
                                                  text: "${controller.upcomingBirthdayList[index].id}",
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
                                                      text: AppMessage.date,
                                                      fontSize: MySize.getScaledSizeHeight(14),
                                                      textColor: color.textFieldTextColor,
                                                    ),
                                                    commonText.regular(
                                                      text: controller.upcomingBirthdayList[index].dob,
                                                      fontSize: MySize.getScaledSizeHeight(14),
                                                      textColor: color.black,
                                                    ),
                                                  ],
                                                ),
                                                16.0.hSpace(),
                                                controller.selectedIndex.value == 0
                                                    ? Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          commonText.regular(
                                                            text: AppMessage.email,
                                                            fontSize: MySize.getScaledSizeHeight(14),
                                                            textColor: color.textFieldTextColor,
                                                          ),
                                                          commonText.regular(
                                                            text: controller.upcomingBirthdayList[index].email,
                                                            fontSize: MySize.getScaledSizeHeight(14),
                                                            textColor: color.black,
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          commonText.regular(
                                                            text: AppMessage.parentsName,
                                                            fontSize: MySize.getScaledSizeHeight(14),
                                                            textColor: color.textFieldTextColor,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: commonText.regular(
                                                                text: controller.upcomingBirthdayList[index].parentName,
                                                                fontSize: MySize.getScaledSizeHeight(14),
                                                                textColor: color.black,
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                20.0.hSpace(),
                                                commonWidget
                                                    .customButton(
                                                      text: AppMessage.viewDetails,
                                                      onTap: () {
                                                        Get.to(() => BirthdayDetailsView(), arguments: {
                                                          'type': controller.selectedIndex.value,
                                                          'details': controller.upcomingBirthdayList[index],
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
                              ),
                  );
                }),
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
          child: Center(
            child: commonText.medium(
              text: title,
              textColor: color.white,
              fontSize: MySize.getScaledSizeHeight(16),
            ),
          ),
        ),
      ),
    );
  }
}
