import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../AddSleepInformation/views/add_sleep_information_view.dart';
import '../../addMedication/views/add_medication_view.dart';
import '../../addMenu/views/add_menu_view.dart';
import '../../mealInformation/views/meal_information_view.dart';
import '../../medicationInformation/views/medication_information_view.dart';
import '../../sleepLogsDetails/views/sleep_logs_details_view.dart';
import '../controllers/classroom_report_controller.dart';

class ClassroomReportView extends GetView<ClassroomReportController> {
  const ClassroomReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassroomReportController>(
      init: ClassroomReportController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: color.backgroundColor,
            appBar: commonWidget.appBar(
              titleText: 'Class 1',
              backgroundColor: color.transparentColor,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.black),
              ),
            ),
            floatingActionButton:
                controller.selectedIndex == 1
                    ? SizedBox()
                    : InkWell(
                      onTap: () {
                        if (controller.selectedIndex == 0) {
                          Get.to(() => AddMenuView());
                        } else {
                          Get.to(() => AddMedicationView());
                        }
                      },
                      child: Container(
                        height: MySize.getScaledSizeHeight(50),
                        width: MySize.getScaledSizeWidth(50),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: color.buttonColor),
                        child: Icon(Icons.add_outlined, size: MySize.getScaledSizeHeight(30), color: color.white),
                      ).paddingOnly(bottom: MySize.getScaledSizeHeight(28)),
                    ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            body: Column(
              children: [
                TabBar(
                  splashFactory: NoSplash.splashFactory,
                  // Removes splash effect
                  labelStyle: TextStyle(fontSize: MySize.getScaledSizeHeight(14), fontWeight: FontWeight.w500),
                  labelPadding: EdgeInsets.zero,
                  unselectedLabelStyle: TextStyle(fontSize: MySize.getScaledSizeHeight(14), fontWeight: FontWeight.w400),
                  controller: controller.tabController,
                  dividerColor: color.transparentColor,
                  labelColor: color.appColor,
                  unselectedLabelColor: color.onboardingTextColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: color.appColor,
                  splashBorderRadius: const BorderRadius.only(topRight: Radius.circular(100.0), topLeft: Radius.circular(100.0)),
                  tabs: [Tab(text: 'Meal'), Tab(text: 'Sleep Logs'), Tab(text: 'Medication')],
                  onTap: (index) {
                    controller.selectedIndex.value = index;
                    controller.update();
                  },
                ),
                2.0.hSpace(),
                Expanded(child: TabBarView(controller: controller.tabController, children: [meal(), sleepLogs(), medication()])),
              ],
            ),
          ),
        );
      },
    );
  }

  meal() {
    return Padding(
      padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
      child:
          controller.isLoading.value
              ? ListView.separated(
                itemCount: controller.mealTracking.length,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return diagonalShimmer(height: MySize.getScaledSizeHeight(242), width: Get.width, borderRadius: BorderRadius.circular(8));
                },
                separatorBuilder: (context, index) {
                  return 16.0.hSpace();
                },
              )
              : ListView.separated(
                itemCount: controller.mealTracking.length,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(color: color.white, borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8)))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(12), vertical: MySize.getScaledSizeHeight(15)),
                          child: commonText.medium(
                            text: controller.mealTracking[index]['mealType'],
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
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
                                    text: AppMessage.date,
                                    fontSize: MySize.getScaledSizeHeight(14),
                                    textColor: color.textFieldTextColor,
                                  ),
                                  commonText.regular(
                                    text: controller.mealTracking[index]['date'],
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
                                    text: AppMessage.time,
                                    fontSize: MySize.getScaledSizeHeight(14),
                                    textColor: color.textFieldTextColor,
                                  ),
                                  commonText.regular(
                                    text: controller.mealTracking[index]['time'],
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
                                      Get.to(() => MealInformationView());
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
  }

  sleepLogs() {
    return Padding(
      padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)), color: color.onboardingBorderColor),
            child: TextField(
              cursorColor: color.black,
              controller: controller.searchController,
              onTap: () {},
              onChanged: (value) {
                controller.filterSearchResults(value);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.deny(
                  RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                ),
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(16), vertical: MySize.getScaledSizeHeight(14)),
                hintText: AppMessage.search,
                border: InputBorder.none,
                prefixIcon: Image.asset(icons.searchIcon, scale: 4.0),
                suffixIcon:
                    controller.searchController.text != ''
                        ? GestureDetector(
                          onTap: () {
                            controller.searchController.clear();
                            controller.filteredSleepLogsList = List.from(controller.sleepLogsList);
                            controller.update();
                          },
                          child: Icon(Icons.close_rounded, size: 24, color: color.black),
                        )
                        : SizedBox(),
                hintStyle: TextStyle(
                  fontSize: MySize.getScaledSizeHeight(14),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Regular',
                  color: color.onboardingTextColor,
                ),
              ),
              style: TextStyle(fontSize: MySize.getScaledSizeHeight(14), color: color.black, fontFamily: 'Regular', fontWeight: FontWeight.w400),
            ),
          ),
          15.0.hSpace(),
          Expanded(
            child:
                controller.filteredSleepLogsList.isEmpty
                    ? Center(child: commonText.medium(text: "No Data Found", fontSize: MySize.getScaledSizeHeight(16), textColor: color.black))
                    : controller.isLoading.value
                    ? ListView.separated(
                      itemCount: controller.filteredSleepLogsList.length,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return diagonalShimmer(height: MySize.getScaledSizeHeight(205), width: Get.width, borderRadius: BorderRadius.circular(8));
                      },
                      separatorBuilder: (context, index) {
                        return 15.0.hSpace();
                      },
                    )
                    : ListView.separated(
                      itemCount: controller.filteredSleepLogsList.length,
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
                                      text: controller.filteredSleepLogsList[index]['studentName'],
                                      fontSize: MySize.getScaledSizeHeight(16),
                                      textColor: color.black,
                                    ),
                                    commonText.regular(
                                      text: controller.filteredSleepLogsList[index]['studentID'],
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
                                          text: AppMessage.parentsName,
                                          fontSize: MySize.getScaledSizeHeight(14),
                                          textColor: color.textFieldTextColor,
                                        ),
                                        commonText.regular(
                                          text: controller.filteredSleepLogsList[index]['parentsName'],
                                          fontSize: MySize.getScaledSizeHeight(14),
                                          textColor: color.black,
                                        ),
                                      ],
                                    ),
                                    controller.filteredSleepLogsList[index]['isAddInfo'] == true
                                        ? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            commonText.regular(
                                              text: AppMessage.sleepSummary,
                                              fontSize: MySize.getScaledSizeHeight(14),
                                              textColor: color.textFieldTextColor,
                                            ),
                                            commonText.regular(
                                              text: controller.filteredSleepLogsList[index]['sleepSummary'],
                                              fontSize: MySize.getScaledSizeHeight(14),
                                              textColor: color.black,
                                            ),
                                          ],
                                        ).paddingOnly(top: MySize.getScaledSizeHeight(16))
                                        : SizedBox(),
                                    20.0.hSpace(),
                                    controller.filteredSleepLogsList[index]['isAddInfo'] == true
                                        ? commonWidget
                                            .customButton(
                                              text: AppMessage.viewDetails,
                                              onTap: () {
                                                Get.to(() => SleepLogsDetailsView());
                                              },
                                            )
                                            .paddingSymmetric(horizontal: MySize.getScaledSizeHeight(3))
                                        : GestureDetector(
                                          onTap: () {
                                            Get.to(() => AddSleepInformationView());
                                          },
                                          child: Container(
                                            height: MySize.getScaledSizeHeight(48),
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(08))),
                                              border: Border.all(color: color.appColor),
                                            ),
                                            child: Center(
                                              child: commonText.medium(
                                                text: AppMessage.addInfo,
                                                fontSize: MySize.getScaledSizeHeight(16),
                                                textColor: color.appColor,
                                              ),
                                            ),
                                          ).paddingSymmetric(horizontal: MySize.getScaledSizeHeight(3)),
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return 15.0.hSpace();
                      },
                    ),
          ),
        ],
      ),
    );
  }

  medication() {
    return Padding(
      padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)), color: color.onboardingBorderColor),
            child: TextField(
              cursorColor: color.black,
              controller: controller.searchController1,
              onTap: () {},
              onChanged: (value) {
                controller.filterMedicationResults(value);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.deny(
                  RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                ),
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(16), vertical: MySize.getScaledSizeHeight(14)),
                hintText: AppMessage.search,
                border: InputBorder.none,
                prefixIcon: Image.asset(icons.searchIcon, scale: 4.0),
                suffixIcon:
                    controller.searchController1.text != ''
                        ? GestureDetector(
                          onTap: () {
                            controller.searchController1.clear();
                            controller.filteredMedicationList = List.from(controller.medicationList);
                            controller.update();
                          },
                          child: Icon(Icons.close_rounded, size: 24, color: color.black),
                        )
                        : SizedBox(),
                hintStyle: TextStyle(
                  fontSize: MySize.getScaledSizeHeight(14),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Regular',
                  color: color.onboardingTextColor,
                ),
              ),
              style: TextStyle(fontSize: MySize.getScaledSizeHeight(14), color: color.black, fontFamily: 'Regular', fontWeight: FontWeight.w400),
            ),
          ),
          15.0.hSpace(),
          Expanded(
            child:
                controller.filteredMedicationList.isEmpty
                    ? Center(child: commonText.medium(text: "No Data Found", fontSize: MySize.getScaledSizeHeight(16), textColor: color.black))
                    : controller.isLoading.value
                    ? ListView.separated(
                      itemCount: controller.filteredMedicationList.length,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return diagonalShimmer(height: MySize.getScaledSizeHeight(205), width: Get.width, borderRadius: BorderRadius.circular(8));
                      },
                      separatorBuilder: (context, index) {
                        return 15.0.hSpace();
                      },
                    )
                    : ListView.separated(
                      itemCount: controller.filteredMedicationList.length,
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
                                      text: controller.filteredMedicationList[index]['studentName'],
                                      fontSize: MySize.getScaledSizeHeight(16),
                                      textColor: color.black,
                                    ),
                                    commonText.regular(
                                      text: controller.filteredMedicationList[index]['studentID'],
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
                                          text: AppMessage.typeOfDisease,
                                          fontSize: MySize.getScaledSizeHeight(14),
                                          textColor: color.textFieldTextColor,
                                        ),
                                        commonText.regular(
                                          text: controller.filteredMedicationList[index]['typeOfDisease'],
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
                                          text: AppMessage.doctorsName,
                                          fontSize: MySize.getScaledSizeHeight(14),
                                          textColor: color.textFieldTextColor,
                                        ),
                                        commonText.regular(
                                          text: controller.filteredMedicationList[index]['doctorsName'],
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
                                            Get.to(() => MedicationInformationView());
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
                        return 15.0.hSpace();
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
