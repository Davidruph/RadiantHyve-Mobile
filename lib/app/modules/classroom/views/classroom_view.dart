import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/addClassroom/views/add_classroom_view.dart';
import 'package:radianthyve_unified/app/modules/classroomDetails/views/classroom_details_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_drawer.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import '../controllers/classroom_controller.dart';

class ClassroomView extends GetView<ClassroomController> {
  const ClassroomView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassroomController>(
      init: ClassroomController(),
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
              text: AppMessage.classroom,
              fontSize: MySize.getScaledSizeHeight(18),
              textColor: color.white,
            ),
            centerTitle: false,
            backgroundColor: color.appColor,
          ),
          drawer: drawer(),
          floatingActionButton: InkWell(
            onTap: () {
              Get.to(() => AddClassroomView());
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
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
            child: controller.isLoading.value
                ? ListView.separated(
                    itemCount: controller.ClassRoomList.length,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return diagonalShimmer(
                        height: MySize.getScaledSizeHeight(84),
                        width: Get.width,
                        borderRadius: BorderRadius.circular(8),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return 16.0.hSpace();
                    },
                  )
                : ListView.separated(
                    itemCount: controller.ClassRoomList.length,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ClassroomDetailsView());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color.classContainerColor,
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
                                      text: controller.ClassRoomList[index]['className'],
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
                                08.0.hSpace(),
                                commonText.regular(
                                  text: 'Total Student ${controller.ClassRoomList[index]['totalStudent']}',
                                  textColor: color.black,
                                  fontSize: MySize.getScaledSizeHeight(14),
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
