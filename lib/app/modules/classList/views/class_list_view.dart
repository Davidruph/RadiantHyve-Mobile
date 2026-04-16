import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../utils/common_color.dart';
import '../../attendanceStatus/views/attendance_status_view.dart';
import '../controllers/class_list_controller.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/messages.dart';

class ClassListView extends GetView<ClassListController> {
  const ClassListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassListController>(
      init: ClassListController(),
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
            ),
            body: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: Column(
                children: [
                  controller.isLoading.value ? diagonalShimmer(
                    height: MySize.getScaledSizeHeight(76),
                    width: Get.width,
                    borderRadius: BorderRadius.circular(8),
                  ) : Container(
                    decoration: BoxDecoration(
                      color: color.white,
                      borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(MySize.getScaledSizeHeight(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonText.regular(
                                text: AppMessage.dayDate,
                                textColor: color.textFieldTextColor,
                                fontSize: MySize.getScaledSizeHeight(14),
                              ),
                              10.0.hSpace(),
                              commonText.medium(
                                text: 'Friday, 25 October, 2024',
                                textColor: color.black,
                                fontSize: MySize.getScaledSizeHeight(14),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonText.regular(
                                text: AppMessage.time,
                                textColor: color.textFieldTextColor,
                                fontSize: MySize.getScaledSizeHeight(14),
                              ),
                              10.0.hSpace(),
                              commonText.medium(
                                text: '07:24 AM',
                                textColor: color.black,
                                fontSize: MySize.getScaledSizeHeight(14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  16.0.hSpace(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)),
                      color: color.onboardingBorderColor,
                    ),
                    child: TextField(
                      cursorColor: color.black,
                      controller: controller.searchController,
                      onTap: () {},
                      onChanged: (value) {
                        controller.filterSearchResults(value);
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: MySize.getScaledSizeWidth(16),
                          vertical: MySize.getScaledSizeHeight(14),
                        ),
                        hintText: AppMessage.search,
                        border: InputBorder.none,
                        prefixIcon: Image.asset(
                          icons.searchIcon,
                          scale: 4.0,
                        ),
                        suffixIcon: controller.searchController.text != ''
                            ? GestureDetector(
                          onTap: () {
                            controller.searchController.clear();
                            controller.filteredAttendanceList = List.from(controller.attendanceList);
                            controller.update();
                          },
                          child: Icon(Icons.close_rounded,size: 24,color: color.black),
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
                  16.0.hSpace(),
                  Expanded(
                    child: controller.filteredAttendanceList.isEmpty
                        ? Center(
                      child: commonText.medium(
                        text: "No Data Found",
                        fontSize: MySize.getScaledSizeHeight(16),
                        textColor: color.black,
                      ),
                    )
                        : controller.isLoading.value ? ListView.separated(
                      itemCount: controller.filteredAttendanceList.length,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var user = controller.filteredAttendanceList[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              diagonalShimmer(
                                height: MySize.getScaledSizeHeight(20),
                                width: MySize.getScaledSizeHeight(124),
                                borderRadius: BorderRadius.circular(4),
                              )
                                  .paddingOnly(top: MySize.getScaledSizeHeight(14), left: MySize.getScaledSizeHeight(12)),
                              13.0.hSpace(),
                              commonWidget.commonDivider(color: color.dividerColor),
                              10.0.hSpace(),
                              SizedBox(
                                height: MySize.getScaledSizeHeight(50),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.options.length,
                                  itemBuilder: (context, optionIndex) {
                                    String option = controller.options[optionIndex];
                                    return GestureDetector(
                                      onTap: () {
                                        controller.updateStatus(index, option);
                                      },
                                      child: Row(
                                        children: [
                                          Obx(
                                                () {
                                              bool isSelected = (user["status"] as RxString).value == option;
                                              String iconPath = isSelected
                                                  ? (option == "Present"
                                                  ? icons.presentIcon
                                                  : option == "Absent"
                                                  ? icons.absentIcon
                                                  : icons.outIcon)
                                                  : icons.unCheckIcon;
                                              return Image.asset(
                                                iconPath,
                                                height: MySize.getScaledSizeHeight(24),
                                                width: MySize.getScaledSizeWidth(24),
                                              );
                                            },
                                          ),
                                          8.0.wSpace(),
                                          diagonalShimmer(
                                            height: MySize.getScaledSizeHeight(18),
                                            width: MySize.getScaledSizeHeight(60),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          10.0.wSpace(),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ).paddingOnly(left: MySize.getScaledSizeHeight(12), bottom: MySize.getScaledSizeHeight(10)),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16);
                      },
                    ) : ListView.separated(
                      itemCount: controller.filteredAttendanceList.length,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var user = controller.filteredAttendanceList[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonText
                                  .medium(
                                text: user["name"].toString(),
                                textColor: color.black,
                                fontSize: MySize.getScaledSizeHeight(16),
                              )
                                  .paddingOnly(top: MySize.getScaledSizeHeight(14), left: MySize.getScaledSizeHeight(12)),
                              13.0.hSpace(),
                              commonWidget.commonDivider(color: color.dividerColor),
                              10.0.hSpace(),
                              SizedBox(
                                height: MySize.getScaledSizeHeight(50),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.options.length,
                                  itemBuilder: (context, optionIndex) {
                                    String option = controller.options[optionIndex];
                                    return GestureDetector(
                                      onTap: () {
                                        controller.updateStatus(index, option);
                                      },
                                      child: Row(
                                        children: [
                                          Obx(
                                                () {
                                              bool isSelected = (user["status"] as RxString).value == option;
                                              String iconPath = isSelected
                                                  ? (option == "Present"
                                                  ? icons.presentIcon
                                                  : option == "Absent"
                                                  ? icons.absentIcon
                                                  : icons.outIcon)
                                                  : icons.unCheckIcon;
                                              return Image.asset(
                                                iconPath,
                                                height: MySize.getScaledSizeHeight(24),
                                                width: MySize.getScaledSizeWidth(24),
                                              );
                                            },
                                          ),
                                          8.0.wSpace(),
                                          commonText.regular(
                                            text: option,
                                            textColor: color.textFieldTextColor,
                                            fontSize: MySize.getScaledSizeHeight(16),
                                          ),
                                          10.0.wSpace(),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ).paddingOnly(left: MySize.getScaledSizeHeight(12), bottom: MySize.getScaledSizeHeight(10)),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16);
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Obx(
              () {
                return controller.isAttendanceComplete
                    ? Container(
                        decoration: BoxDecoration(
                          color: color.white,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            commonWidget.commonDivider(color: color.notificationContainerColor),
                            commonWidget
                                .customButton(
                                  text: AppMessage.viewAttendance,
                                  onTap: () {
                                    Get.to(() => AttendanceStatusView());
                                  },
                                )
                                .paddingAll(MySize.getScaledSizeHeight(16)),
                          ],
                        ),
                      )
                    : SizedBox(); // Hide if all statuses are not selected
              },
            ),
          ),
        );
      },
    );
  }
}
