import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/messages.dart';

import '../../studentDetails/views/student_details_view.dart';
import '../controllers/classroom_details_controller.dart';

class ClassroomDetailsView extends GetView<ClassroomDetailsController> {
  const ClassroomDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassroomDetailsController>(
      init: ClassroomDetailsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: AppMessage.classroomDetails,
            backgroundColor: color.transparentColor,
          ),
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
            child: controller.isLoading.value ? ListView.separated(
              itemCount: controller.studentsList.length,
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
            ) : ListView.separated(
              itemCount: controller.studentsList.length,
              shrinkWrap: true,
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
                        padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(12), vertical: MySize.getScaledSizeHeight(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            commonText.medium(
                              text: controller.studentsList[index]['name'],
                              fontSize: MySize.getScaledSizeHeight(16),
                              textColor: color.black,
                            ),
                            commonText.medium(
                              text: controller.studentsList[index]['id'],
                              fontSize: MySize.getScaledSizeHeight(16),
                              textColor: color.black,
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
                                  text: AppMessage.parentsName,
                                  fontSize: MySize.getScaledSizeHeight(14),
                                  textColor: color.textFieldTextColor,
                                ),
                                commonText.medium(
                                  text: controller.studentsList[index]['parentsName'],
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
                                  text: AppMessage.Class,
                                  fontSize: MySize.getScaledSizeHeight(14),
                                  textColor: color.textFieldTextColor,
                                ),
                                commonText.medium(
                                  text: controller.studentsList[index]['class'],
                                  fontSize: MySize.getScaledSizeHeight(14),
                                  textColor: color.black,
                                ),
                              ],
                            ),
                            20.0.hSpace(),
                            commonWidget
                                .customButton(
                              text: AppMessage.studentProfile,
                              onTap: () {
                                Get.to(() => StudentDetailsView());
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
      },
    );
  }
}
