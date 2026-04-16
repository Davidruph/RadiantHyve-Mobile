import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/noDataFound.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../addMedication/views/add_medication_view.dart';
import '../../medicationInformation/views/medication_information_view.dart';
import '../controllers/medication_controller.dart';

class MedicationView extends GetView<MedicationController> {
  const MedicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MedicationController>(
      init: MedicationController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: color.backgroundColor,
            appBar: commonWidget.appBar(
              titleText: 'Medication', 
              backgroundColor: color.transparentColor,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.black),
              ),
            ),
            floatingActionButton: InkWell(
              onTap: () {
                Get.to(() => AddMedicationView())?.then((value) {
                  if (value == 1) {
                    controller.listMedicationStudentApi();
                    controller.update();
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
                  Container(
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
                        controller.listMedicationStudentApi();
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
                                    controller.listMedicationStudentApi();
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
                      style: TextStyle(
                        fontSize: MySize.getScaledSizeHeight(14),
                        color: color.black,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
                          controller.listMedicationStudentApi();
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
                                      ? controller.listMedicationStudentDataList.isEmpty
                                          ? buildNoDataWidget(height: Get.height / 1.5)
                                          : ListView.separated(
                                            itemCount: controller.listMedicationStudentDataList.length,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
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
                                                          commonText.medium(
                                                            text: controller.listMedicationStudentDataList[index].studentName,
                                                            fontSize: MySize.getScaledSizeHeight(16),
                                                            textColor: color.black,
                                                          ),
                                                          commonText.regular(
                                                            text: '${controller.listMedicationStudentDataList[index].studentId ?? ''}',
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
                                                                text: 'Type of Disease',
                                                                fontSize: MySize.getScaledSizeHeight(14),
                                                                textColor: color.textFieldTextColor,
                                                              ),
                                                              commonText.regular(
                                                                text: controller.listMedicationStudentDataList[index].typeDisease ?? '',
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
                                                                text: 'Doctors  Name',
                                                                fontSize: MySize.getScaledSizeHeight(14),
                                                                textColor: color.textFieldTextColor,
                                                              ),
                                                              commonText.regular(
                                                                text: controller.listMedicationStudentDataList[index].doctorName ?? '',
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
                                                                  Get.to(
                                                                    () => MedicationInformationView(),
                                                                    arguments: {'medicationData': controller.listMedicationStudentDataList[index]},
                                                                  )?.then((value) {
                                                                    if (value == 1) {
                                                                      controller.listMedicationStudentApi();
                                                                      controller.update();
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
                                              return 15.0.hSpace();
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
                                          return 15.0.hSpace();
                                        },
                                      ),

                                  Obx(() {
                                    return controller.isLoadMoreRunning.value == true ? Center(child: CommonLoader()) : Container();
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
}
