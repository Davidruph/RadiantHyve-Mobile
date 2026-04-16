import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:radianthyve_unified/app/modules/addShiftInformation/views/add_shift_information_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import '../controllers/shift_details_controller.dart';

class ShiftDetailsView extends GetView<ShiftDetailsController> {
  const ShiftDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShiftDetailsController>(
      init: ShiftDetailsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: AppMessage.shiftDetails,
            backgroundColor: color.transparentColor,
            onTap: () {
              Get.back(result: {'shift_fee': controller.shiftData?.shiftFee});
            },
            actions: [
              Button().paddingOnly(right: MySize.getScaledSizeHeight(12), top: MySize.getScaledSizeHeight(12)),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    commonText.regular(
                      text: AppMessage.shiftName,
                      fontSize: MySize.getScaledSizeHeight(14),
                      textColor: color.textFieldTextColor,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: commonText.regular(
                          text: controller.shiftData!.shiftName,
                          fontSize: MySize.getScaledSizeHeight(16),
                          textColor: color.black,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                18.0.hSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    commonText.regular(
                      text: AppMessage.shiftId,
                      fontSize: MySize.getScaledSizeHeight(14),
                      textColor: color.textFieldTextColor,
                    ),
                    commonText.regular(
                      text: "${controller.shiftData!.schoolId}",
                      fontSize: MySize.getScaledSizeHeight(16),
                      textColor: color.black,
                    ),
                  ],
                ),
                18.0.hSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    commonText.regular(
                      text: AppMessage.shiftFee,
                      fontSize: MySize.getScaledSizeHeight(14),
                      textColor: color.textFieldTextColor,
                    ),
                    commonText.regular(
                      text: '\$${controller.shiftData!.shiftFee}',
                      fontSize: MySize.getScaledSizeHeight(16),
                      textColor: color.black,
                    ),
                  ],
                ),
                18.0.hSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    commonText.regular(
                      text: 'Late Fee',
                      fontSize: MySize.getScaledSizeHeight(14),
                      textColor: color.textFieldTextColor,
                    ),
                    commonText.regular(
                      text: '\$${controller.shiftData!.penalty ?? 0}',
                      fontSize: MySize.getScaledSizeHeight(16),
                      textColor: color.black,
                    ),
                  ],
                ),
              ],
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
            bodyBuilder: (context) => const ListItems(),
            onPop: () => print('Popover was popped!'),
            direction: PopoverDirection.bottom,
            backgroundColor: Colors.white,
            width: MySize.getScaledSizeWidth(150),
            height: MySize.getScaledSizeHeight(106),
          );
        },
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShiftDetailsController>(
      assignId: false,
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              _commonRowImageWithText(
                image: icons.editIcon,
                text: 'Edit',
                onTap: () {
                  Get.back();
                  Get.to(() => AddShiftInformationView(), arguments: {
                    'flag': 'editShift',
                    'details': controller.shiftData,
                  })!
                      .then((value) {
                    if (value != null) {
                      controller.update();
                    }
                  });
                },
              ),
              05.00.hSpace(),
              Divider(
                color: Colors.grey.withOpacity(0.5),
              ),
              05.00.hSpace(),
              _commonRowImageWithText(
                image: icons.deleteIcon,
                text: 'Delete',
                onTap: () {
                  Get.back();
                  controller.deleteShiftApi();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _commonRowImageWithText({image, text, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            image,
            height: MySize.getScaledSizeHeight(24),
            width: MySize.getScaledSizeWidth(24),
          ),
          10.0.wSpace(),
          commonText.regular(
            textAlign: TextAlign.center,
            text: text ?? "",
            fontSize: MySize.getScaledSizeHeight(14),
            textColor: color.black,
          ),
        ],
      ),
    );
  }
}
