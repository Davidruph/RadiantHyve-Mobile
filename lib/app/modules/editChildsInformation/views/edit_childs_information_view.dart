import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/studentEditProfile/views/student_edit_profile_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../controllers/edit_childs_information_controller.dart';

class EditChildsInformationView
    extends GetView<EditChildsInformationController> {
  const EditChildsInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditChildsInformationController>(
      init: EditChildsInformationController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: "Edit Child's Information",
            backgroundColor: color.transparentColor,
          ),
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
            child: Obx(() {
              return RefreshIndicator(
                displacement: 30,
                backgroundColor: color.white,
                color: color.appColor,
                strokeWidth: 3,
                onRefresh: () async {
                  controller.page = 1;
                  controller.hasNextPage.value = true;
                  controller.studentsListAPI();
                },
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  physics: AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics()),
                  child: Column(
                    children: [
                      !controller.isLoading.value
                          ? controller.studentsListDataList.isEmpty
                              ? buildNoDataWidget(
                                  height: MySize.getScaledSizeHeight(500))
                              : ListView.separated(
                                  itemCount:
                                      controller.studentsListDataList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: color.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                MySize.getScaledSizeHeight(8))),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MySize.getScaledSizeHeight(
                                                        12),
                                                vertical:
                                                    MySize.getScaledSizeHeight(
                                                        15)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                commonText.medium(
                                                  text: controller
                                                      .studentsListDataList[
                                                          index]
                                                      .fullName,
                                                  fontSize: MySize
                                                      .getScaledSizeHeight(16),
                                                  textColor: color.black,
                                                ),
                                                commonText.regular(
                                                  text:
                                                      '${controller.studentsListDataList[index].id}',
                                                  fontSize: MySize
                                                      .getScaledSizeHeight(14),
                                                  textColor:
                                                      color.textFieldTextColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                          commonWidget.commonDivider(
                                              color: color.dividerColor),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MySize.getScaledSizeHeight(
                                                        12),
                                                vertical:
                                                    MySize.getScaledSizeHeight(
                                                        14)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    commonText.regular(
                                                      text: AppMessage.relation,
                                                      fontSize: MySize
                                                          .getScaledSizeHeight(
                                                              14),
                                                      textColor: color
                                                          .textFieldTextColor,
                                                    ),
                                                    commonText.regular(
                                                      text:
                                                          '${controller.studentsListDataList[index].relationToChild}',
                                                      fontSize: MySize
                                                          .getScaledSizeHeight(
                                                              14),
                                                      textColor: color.black,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    commonText.regular(
                                                      text: AppMessage
                                                          .frequencyAttendance,
                                                      fontSize: MySize
                                                          .getScaledSizeHeight(
                                                              14),
                                                      textColor: color
                                                          .textFieldTextColor,
                                                    ),
                                                    commonText.regular(
                                                      text: controller
                                                          .studentsListDataList[
                                                              index]
                                                          .shiftName,
                                                      fontSize: MySize
                                                          .getScaledSizeHeight(
                                                              14),
                                                      textColor: color.black,
                                                    ),
                                                  ],
                                                ).paddingOnly(
                                                    top: MySize
                                                        .getScaledSizeHeight(
                                                            16)),
                                                20.0.hSpace(),
                                                commonWidget
                                                    .customButton(
                                                      text: AppMessage
                                                          .editProfile,
                                                      onTap: () {
                                                        Get.to(() => StudentEditProfileView(), arguments: {
                                                          'flag': 'studentEdit',
                                                          'studentId': controller.studentsListDataList[index].id,
                                                          'studentDetailsData': controller.studentsListDataList[index]
                                                        });

                                                      },
                                                    )
                                                    .paddingSymmetric(
                                                        horizontal: MySize
                                                            .getScaledSizeHeight(
                                                                3)),
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
                              physics: NeverScrollableScrollPhysics(),
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
                            ),
                      Obx(() {
                        return controller.isLoadMoreRunning.value == true
                            ? Center(child: CommonLoader())
                            : Container();
                      }),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
