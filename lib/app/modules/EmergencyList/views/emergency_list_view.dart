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
import '../controllers/emergency_list_controller.dart';

class EmergencyListView extends GetView<EmergencyListController> {
  const EmergencyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmergencyListController>(
      init: EmergencyListController(),
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
              text: AppMessage.emergency,
              fontSize: MySize.getScaledSizeHeight(18),
              textColor: color.white,
            ),
            centerTitle: false,
            // toolbarHeight: 0.0,
            backgroundColor: color.appColor,
          ),
          drawer: drawer(),
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
            child: controller.isLoading.value ? ListView.separated(
              itemCount: controller.emergencyList.length,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return diagonalShimmer(
                  height: MySize.getScaledSizeHeight(138),
                  width: Get.width,
                  borderRadius: BorderRadius.circular(8),
                );
              },
              separatorBuilder: (context, index) {
                return 16.0.hSpace();
              },
            ) : ListView.separated(
              itemCount: controller.emergencyList.length,
              shrinkWrap: true,
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
                        padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(12), vertical: MySize.getScaledSizeHeight(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            commonText.medium(
                              text: controller.emergencyList[index]['emergency'],
                              fontSize: MySize.getScaledSizeHeight(16),
                              textColor: color.black,
                            ),
                            commonText.regular(
                              text: controller.emergencyList[index]['date'],
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
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
                                commonText.regular(
                                  text: AppMessage.Class,
                                  fontSize: MySize.getScaledSizeHeight(14),
                                  textColor: color.textFieldTextColor,
                                ),
                                commonText.regular(
                                  text: controller.emergencyList[index]['class'],
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
                                  text: AppMessage.emergencyId,
                                  fontSize: MySize.getScaledSizeHeight(14),
                                  textColor: color.textFieldTextColor,
                                ),
                                commonText.regular(
                                  text: controller.emergencyList[index]['emergencyId'],
                                  fontSize: MySize.getScaledSizeHeight(14),
                                  textColor: color.black,
                                ),
                              ],
                            ),
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
      },
    );
  }
}
