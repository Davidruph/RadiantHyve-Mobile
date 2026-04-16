import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:radianthyve_unified/app/modules/AddSleepInformation/views/add_sleep_information_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../controllers/sleep_logs_details_controller.dart';

class SleepLogsDetailsView extends GetView<SleepLogsDetailsController> {
  const SleepLogsDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SleepLogsDetailsController>(
      init: SleepLogsDetailsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: AppMessage.sleepLogsDetails,
            backgroundColor: color.transparentColor,
            actions: [Button().paddingOnly(right: MySize.getScaledSizeHeight(12), top: MySize.getScaledSizeHeight(12))],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: Column(
                children: [
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(16),
                            width: MySize.getScaledSizeWidth(102),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(124),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.studentName,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          20.0.wSpace(),
                          commonText.regular(
                            text: controller.listSleepLogsStudentData?.sleepLoag?.studentName ?? '',
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
                            maxLines: 2,
                          ),
                        ],
                      ),
                  18.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(16),
                            width: MySize.getScaledSizeWidth(74),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(62),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.studentId,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: "${controller.listSleepLogsStudentData?.sleepLoag?.studentId}",
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
                          ),
                        ],
                      ),
                  18.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(16),
                            width: MySize.getScaledSizeWidth(101),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(117),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.parentsName,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: controller.listSleepLogsStudentData?.parentName,
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
                          ),
                        ],
                      ),
                  18.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(16),
                            width: MySize.getScaledSizeWidth(40),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(218),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.email,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: '${controller.listSleepLogsStudentData?.email ?? ''}',
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
                          ),
                        ],
                      ),
                  18.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(16),
                            width: MySize.getScaledSizeWidth(118),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(64),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.timeToSleeping,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: controller.formatTimeTo12Hour(controller.listSleepLogsStudentData?.sleepLoag?.startTime),
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
                          ),
                        ],
                      ),
                  18.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(16),
                            width: MySize.getScaledSizeWidth(120),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(74),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.timeToWakeUp,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: controller.formatTimeTo12Hour(controller.listSleepLogsStudentData?.sleepLoag?.endTime),
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Button extends StatelessWidget {
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 20,
      child: GestureDetector(
        child: Icon(Icons.more_vert_outlined),
        onTap: () {
          showPopover(
            context: context,
            bodyBuilder: (context) => ListItems(),
            onPop: () => print('Popover was popped!'),
            direction: PopoverDirection.bottom,
            backgroundColor: Colors.white,
            width: MySize.getScaledSizeWidth(247),
            height: MySize.getScaledSizeHeight(54),
            // arrowHeight: 16,
            // arrowWidth: 28,
          );
        },
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  ListItems({Key? key}) : super(key: key);
  SleepLogsDetailsController controller = Get.put(SleepLogsDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: EdgeInsets.all(8),
        children: [
          _commonRowImageWithText(
            image: icons.editIcon,
            text: AppMessage.edit,
            onTap: () {
              Get.back();
              Get.to(() => AddSleepInformationView(), arguments: {'flag': 'editSleepLogs', 'sleepLogsData': controller.listSleepLogsStudentData});
            },
          ),
        ],
      ),
    );
  }

  Widget _commonRowImageWithText({image, text, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(image, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
          10.0.wSpace(),
          commonText.regular(textAlign: TextAlign.center, text: text ?? "", fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
        ],
      ),
    );
  }
}
