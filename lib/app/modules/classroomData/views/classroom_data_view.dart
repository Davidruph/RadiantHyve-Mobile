import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_drawer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../studentDetails/views/student_details_view.dart';
import '../controllers/classroom_data_controller.dart';

class ClassroomDataView extends GetView<ClassroomDataController> {
  const ClassroomDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassroomDataController>(
      init: ClassroomDataController(),
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
                text: AppMessage.studentsData,
                fontSize: MySize.getScaledSizeHeight(18),
                textColor: color.white,
              ),
              centerTitle: false,
              // toolbarHeight: 0.0,
              backgroundColor: Colors.transparent,
            ),
            drawer: drawer(),
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
                            onTap: () {
                              controller.searchController.clear();
                              controller.page = 1;
                              controller.update();
                            },

                            onSubmitted: (value) {
                              controller.page = 1;
                              controller.listStudentTeacherApi();
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
                              suffixIcon:
                                  controller.searchController.text != ''
                                      ? GestureDetector(
                                        onTap: () {
                                          controller.searchController.clear();
                                          controller.listStudentTeacherApi();
                                          controller.update();
                                        },
                                        child: Icon(
                                          Icons.close_rounded,
                                          size: 24,
                                          color: color.black,
                                        ),
                                      )
                                      : SizedBox(),
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
                      12.0.wSpace(),
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          filterBottomSheet(context: context);
                        },
                        child: Container(
                          height: MySize.getScaledSizeHeight(48),
                          width: MySize.getScaledSizeWidth(48),
                          decoration: BoxDecoration(
                            color: color.onboardingBorderColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(MySize.getScaledSizeHeight(8)),
                            ),
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
                  Obx(() {
                    return Expanded(
                      child: RefreshIndicator(
                        displacement: 30,
                        backgroundColor: color.white,
                        color: color.appColor,
                        strokeWidth: 3,
                        onRefresh: () async {
                          controller.page = 1;
                          controller.hasNextPage.value = true;
                          controller.listStudentTeacherApi();
                        },
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: Get.height * 0.8),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  !controller.isLoading.value
                                      ? controller.listStudentTeacherDataList.isEmpty
                                          ? buildNoDataWidget(height: Get.height / 1.5)
                                          : ListView.separated(
                                            itemCount: controller.listStudentTeacherDataList.length,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: color.white,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(MySize.getScaledSizeHeight(8)),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: MySize.getScaledSizeHeight(12),
                                                        vertical: MySize.getScaledSizeHeight(15),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          commonText.medium(
                                                            text:
                                                                controller
                                                                    .listStudentTeacherDataList[index]
                                                                    .fullName,
                                                            fontSize: MySize.getScaledSizeHeight(
                                                              16,
                                                            ),
                                                            textColor: color.black,
                                                          ),
                                                          commonText.medium(
                                                            text:
                                                                '${controller.listStudentTeacherDataList[index].id}',
                                                            fontSize: MySize.getScaledSizeHeight(
                                                              16,
                                                            ),
                                                            textColor: color.black,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    commonWidget.commonDivider(
                                                      color: color.dividerColor,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: MySize.getScaledSizeHeight(12),
                                                        vertical: MySize.getScaledSizeHeight(14),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              commonText.regular(
                                                                text: AppMessage.parentsName,
                                                                fontSize:
                                                                    MySize.getScaledSizeHeight(14),
                                                                textColor:
                                                                    color.textFieldTextColor,
                                                              ),
                                                              commonText.medium(
                                                                text:
                                                                    controller
                                                                        .listStudentTeacherDataList[index]
                                                                        .parentName,
                                                                fontSize:
                                                                    MySize.getScaledSizeHeight(14),
                                                                textColor: color.black,
                                                              ),
                                                            ],
                                                          ),
                                                          16.0.hSpace(),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              commonText.regular(
                                                                text:
                                                                    AppMessage.frequencyAttendance,
                                                                fontSize:
                                                                    MySize.getScaledSizeHeight(14),
                                                                textColor:
                                                                    color.textFieldTextColor,
                                                              ),
                                                              10.0.wSpace(),
                                                              Flexible(
                                                                child: commonText.medium(
                                                                  text:
                                                                      controller
                                                                          .listStudentTeacherDataList[index]
                                                                          .shiftName,
                                                                  fontSize:
                                                                      MySize.getScaledSizeHeight(
                                                                        14,
                                                                      ),
                                                                  textColor: color.black,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          20.0.hSpace(),
                                                          commonWidget
                                                              .customButton(
                                                                text: AppMessage.viewProfile,
                                                                onTap: () {
                                                                  Get.to(
                                                                    () => StudentDetailsView(),
                                                                    arguments: {
                                                                      'studentId':
                                                                          controller
                                                                              .listStudentTeacherDataList[index]
                                                                              .id,
                                                                    },
                                                                  );
                                                                },
                                                              )
                                                              .paddingSymmetric(
                                                                horizontal:
                                                                    MySize.getScaledSizeHeight(3),
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
                                          )
                                      : ListView.separated(
                                        itemCount: 5,
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
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  filterBottomSheet({required context}) {
    return showModalBottomSheet(
      context: Get.context!,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
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
                            controller.selectedIndex1 == -1
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
                                  controller.selectedIndex1 = index;
                                  controller.shiftId = "${controller.getShiftDataList[index].id}";
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
                                      controller.selectedIndex1 == index
                                          ? icons.circleCheck
                                          : icons.circleUnCheck,
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
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  height: MySize.getScaledSizeHeight(48),
                                  decoration: BoxDecoration(
                                    color: color.homeTextColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(MySize.getScaledSizeHeight(8)),
                                    ),
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
                                  if (controller.selectedIndex1 != -1) {
                                    Get.back();
                                    controller.listStudentTeacherApi();
                                  }
                                },
                                buttonColor:
                                    controller.selectedIndex1 != -1
                                        ? color.appColor
                                        : color.appColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(
                      horizontal: MySize.getScaledSizeWidth(16),
                      vertical: MySize.getScaledSizeHeight(16),
                    );
                  },
                ),
              ),
            ),
          ),
    );
  }
}
