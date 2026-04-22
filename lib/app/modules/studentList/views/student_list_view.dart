import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/studentDetails/views/student_details_view.dart';
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
import '../controllers/student_list_controller.dart';

class StudentListView extends GetView<StudentListController> {
  const StudentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentListController>(
      init: StudentListController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
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
                  child: Image.asset(
                    icons.drawerIcon,
                    height: MySize.getScaledSizeHeight(30),
                    width: MySize.getScaledSizeWidth(30),
                  ),
                ),
              ),
              title: commonText.medium(
                text: AppMessage.studentList,
                fontSize: MySize.getScaledSizeHeight(18),
                textColor: color.white,
              ),
              centerTitle: false,
              backgroundColor: Colors.transparent,
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
                              tabItem(AppMessage.allStudent, 0),
                              tabItem(AppMessage.newStudent, 1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  16.0.hSpace(),
                  Obx(() {
                    return controller.selectedIndex.value == 0
                        ? Expanded(
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
                                          controller: controller.searchController0,
                                          onChanged: (value) {
                                            if (value == '') {
                                              controller.listStudentAPI(tab: 0);
                                            }
                                          },
                                          onSubmitted: (value) {
                                            controller.listStudentAPI(tab: 0);
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.deny(
                                              RegExp(
                                                r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
                                              ),
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
                                    if (controller.newStudentList.isNotEmpty) 12.0.wSpace(),
                                    if (controller.newStudentList.isNotEmpty)
                                      InkWell(
                                        onTap: () {
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          filterBottomSheet(context);
                                        },
                                        child: Container(
                                          height: MySize.getScaledSizeHeight(48),
                                          width: MySize.getScaledSizeWidth(48),
                                          decoration: BoxDecoration(
                                            color: color.onboardingBorderColor,
                                            borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(MySize.getScaledSizeHeight(12)),
                                            child: Image.asset(icons.filterIcon),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                15.0.hSpace(),
                                Expanded(
                                  child: controller.isLoading.value
                                      ? ListView.separated(
                                          controller: controller.scrollController,
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
                                      : controller.newStudentList.isEmpty
                                          ? RefreshIndicator(
                                              onRefresh: () async {
                                                controller.listStudentAPI(tab: 0);
                                              },
                                              backgroundColor: color.white,
                                              color: color.appColor,
                                              child: SingleChildScrollView(
                                                physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                                                child: NoData(height: Get.height / 1.4, width: Get.width),
                                              ),
                                            )
                                          : RefreshIndicator(
                                              displacement: 50,
                                              backgroundColor: color.white,
                                              color: color.appColor,
                                              strokeWidth: 2,
                                              onRefresh: () async {
                                                controller.page = 1;
                                                controller.hasNextPage.value = true;
                                                controller.listStudentAPI(tab: 0);
                                                controller.update();
                                              },
                                              child: ListView.separated(
                                                itemCount: controller.newStudentList.length,
                                                controller: controller.scrollController,
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
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: MySize.getScaledSizeHeight(12),
                                                            vertical: MySize.getScaledSizeHeight(15),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: commonText.medium(
                                                                  text: controller.newStudentList[index].fullName,
                                                                  fontSize: MySize.getScaledSizeHeight(16),
                                                                  textColor: color.black,
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                              commonText.medium(
                                                                text: "${controller.newStudentList[index].id}",
                                                                fontSize: MySize.getScaledSizeHeight(16),
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
                                                                    text: AppMessage.parentsName,
                                                                    fontSize: MySize.getScaledSizeHeight(14),
                                                                    textColor: color.textFieldTextColor,
                                                                  ),
                                                                  Expanded(
                                                                    child: Align(
                                                                      alignment: Alignment.centerRight,
                                                                      child: commonText.medium(
                                                                        text: controller.newStudentList[index].parentName,
                                                                        fontSize: MySize.getScaledSizeHeight(14),
                                                                        textColor: color.black,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              16.0.hSpace(),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  commonText.regular(
                                                                    text: AppMessage.frequencyAttendance,
                                                                    fontSize: MySize.getScaledSizeHeight(14),
                                                                    textColor: color.textFieldTextColor,
                                                                  ),
                                                                  10.0.wSpace(),
                                                                  Flexible(
                                                                    child: commonText.medium(
                                                                      text: controller.newStudentList[index].shiftName,
                                                                      fontSize: MySize.getScaledSizeHeight(14),
                                                                      textColor: color.black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              20.0.hSpace(),
                                                              commonWidget
                                                                  .customButton(
                                                                    text: AppMessage.viewProfile,
                                                                    onTap: () {
                                                                      Get.to(() => StudentDetailsView(), arguments: {
                                                                        'flag': 'allStudents',
                                                                        'studentList': controller.newStudentList[index],
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
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)),
                                    color: color.onboardingBorderColor,
                                  ),
                                  child: TextField(
                                    cursorColor: color.black,
                                    controller: controller.searchController1,
                                    onChanged: (value) {
                                      if (value == '') {
                                        controller.listStudentAPI(tab: 1);
                                      }
                                    },
                                    onSubmitted: (value) {
                                      controller.listStudentAPI(tab: 1);
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
                                15.0.hSpace(),
                                Expanded(
                                  child: Obx(() {
                                    return controller.isLoading.value
                                        ? ListView.separated(
                                            controller: controller.scrollController,
                                            itemCount: 5,
                                            shrinkWrap: true,
                                            physics: AlwaysScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return diagonalShimmer(
                                                height: MySize.getScaledSizeHeight(164),
                                                width: Get.width,
                                                borderRadius: BorderRadius.circular(8),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return 16.0.hSpace();
                                            },
                                          )
                                        : controller.newStudentList.isNotEmpty
                                            ? RefreshIndicator(
                                                displacement: 50,
                                                backgroundColor: color.white,
                                                color: color.appColor,
                                                strokeWidth: 2,
                                                onRefresh: () async {
                                                  controller.page = 1;
                                                  controller.hasNextPage.value = true;
                                                  controller.listStudentAPI(tab: 1);
                                                  controller.update();
                                                },
                                                child: ListView.separated(
                                                  controller: controller.scrollController,
                                                  itemCount: controller.newStudentList.length,
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
                                                            padding: EdgeInsets.symmetric(
                                                              horizontal: MySize.getScaledSizeHeight(12),
                                                              vertical: MySize.getScaledSizeHeight(15),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: commonText.medium(
                                                                    text: "${controller.newStudentList[index].fullName}",
                                                                    fontSize: MySize.getScaledSizeHeight(16),
                                                                    textColor: color.black,
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    color: color.waitingBackgroundColor,
                                                                    borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(50))),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                      vertical: MySize.getScaledSizeHeight(4),
                                                                      horizontal: MySize.getScaledSizeHeight(28),
                                                                    ),
                                                                    child: commonText.regular(
                                                                      text: controller.newStudentList[index].requestStatus,
                                                                      fontSize: MySize.getScaledSizeHeight(14),
                                                                      textColor: color.waitingColor,
                                                                    ),
                                                                  ),
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
                                                                      text: AppMessage.parentsName,
                                                                      fontSize: MySize.getScaledSizeHeight(14),
                                                                      textColor: color.textFieldTextColor,
                                                                    ),
                                                                    commonText.medium(
                                                                      text: controller.newStudentList[index].parentName,
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
                                                                        Get.to(() => StudentDetailsView(), arguments: {
                                                                          'flag': 'newStudents',
                                                                          'studentList': controller.newStudentList[index],
                                                                        })!
                                                                            .then((value) {
                                                                          if (value == 1) {
                                                                            controller.listStudentAPI(tab: 1);
                                                                          }
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
                                              )
                                            : RefreshIndicator(
                                                displacement: 50,
                                                backgroundColor: color.white,
                                                color: color.appColor,
                                                strokeWidth: 2,
                                                onRefresh: () async {
                                                  controller.page = 1;
                                                  controller.hasNextPage.value = true;
                                                  controller.listStudentAPI(tab: 1);
                                                  controller.update();
                                                },
                                                child: SingleChildScrollView(
                                                  physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                                                  child: NoData(height: Get.height / 1.4, width: Get.width),
                                                ),
                                              );
                                  }),
                                ),
                              ],
                            ),
                          );
                  }),
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

  Widget tabItem(String title, int index) {
    return InkWell(
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
              fontSize: MySize.getScaledSizeHeight(14),
            ),
          ),
        ),
      ),
    );
  }

  filterBottomSheet(context) {
    return showModalBottomSheet(
      context: Get.context!,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: Get.height - 100,
            width: Get.width,
            decoration: BoxDecoration(
              color: color.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    04.0.hSpace(),
                    Row(
                      children: [
                        Expanded(child: SizedBox()),
                        Expanded(
                          child: Center(
                            child: commonText.semiBold(
                              text: AppMessage.filter,
                              fontSize: MySize.getScaledSizeHeight(20),
                              textColor: color.black,
                            ),
                          ),
                        ),
                        controller.shiftId.value == 0
                            ? Expanded(child: SizedBox())
                            : Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      controller.removeFilter();
                                    },
                                    child: Icon(Icons.clear),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    20.0.hSpace(),
                    commonWidget.commonDivider(color: color.notificationContainerColor),
                    16.0.hSpace(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.getShiftDataList.length,
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              controller.shiftId.value = controller.getShiftDataList[index].id!;
                              setState(() {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                commonText.regular(
                                  text: controller.getShiftDataList[index].shiftName,
                                  fontSize: MySize.getScaledSizeHeight(16),
                                  textColor: color.textFieldTextColor,
                                ),
                                Image.asset(
                                  controller.shiftId.value == controller.getShiftDataList[index].id! ? icons.circleCheck : icons.circleUnCheck,
                                  height: MySize.getScaledSizeHeight(24),
                                  width: MySize.getScaledSizeWidth(24),
                                ),
                              ],
                            ).paddingOnly(bottom: MySize.getScaledSizeHeight(26)),
                          );
                        },
                      ),
                    ),
                    10.0.hSpace(),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
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
                              if (controller.shiftId.value != 0) {
                                Get.back();
                                controller.listStudentAPI(tab: 0);
                              }
                            },
                            buttonColor: controller.shiftId.value != 0 ? color.appColor : color.appColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ).paddingSymmetric(horizontal: MySize.getScaledSizeWidth(16), vertical: MySize.getScaledSizeHeight(16));
              },
            ),
          ),
        ),
      ),
    );
  }
}
