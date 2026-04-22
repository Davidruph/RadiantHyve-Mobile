import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/DiaperHygieneTracker/views/diaper_hygiene_tracker_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_drawer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../mealTracking/views/meal_tracking_view.dart';
import '../../medication/views/medication_view.dart';
import '../../sleepLogs/views/sleep_logs_view.dart';
import '../controllers/child_reports_controller.dart';

class ChildReportsView extends GetView<ChildReportsController> {
  const ChildReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChildReportsController>(
      init: ChildReportsController(),
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
              child: InkWell(
                onTap: () {
                  controller.scaffoldKey.currentState?.openDrawer();
                },
                child: Image.asset(icons.drawerIcon, height: MySize.getScaledSizeHeight(30), width: MySize.getScaledSizeWidth(30)),
              ),
            ),
            title: commonText.medium(text: AppMessage.childReports, fontSize: MySize.getScaledSizeHeight(18), textColor: color.white),
            centerTitle: false,
            // backgroundColor: color.appColor,
             backgroundColor: Colors.transparent,
             
          ),
          drawer: drawer(),
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
            child:
                 ListView.separated(
                      itemCount: controller.ChildReportList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (index == 0) {
                              Get.to(() => MealTrackingView());
                            } else if (index == 1) {
                              Get.to(() => SleepLogsView());
                            } else if (index == 2) {
                              Get.to(() => MedicationView());
                            } else {
                              Get.to(() => DiaperHygieneTrackerView());
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: color.buttonColor,
                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      commonText.medium(
                                        text: controller.ChildReportList[index]['name'],
                                        textColor: color.black,
                                        fontSize: MySize.getScaledSizeHeight(18),
                                      ),
                                      Image.asset(
                                        icons.arrowRightIcon,
                                        height: MySize.getScaledSizeHeight(24),
                                        width: MySize.getScaledSizeWidth(24),
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
