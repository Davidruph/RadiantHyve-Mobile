import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/common.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/birthday_details_controller.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import '../../../../commonWidgets/CachedImageContainer.dart';
import '../../../../commonWidgets/constant.dart';

class BirthdayDetailsView extends GetView<BirthdayDetailsController> {
  const BirthdayDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BirthdayDetailsController>(
      init: BirthdayDetailsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: controller.type == 0 ? AppMessage.staffDetails : AppMessage.studentDetails,
            backgroundColor: color.transparentColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: controller.type == 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CachedImageContainer(
                            image: controller.birthdayData?.profilePic,
                            fit: BoxFit.cover,
                            width: MySize.getScaledSizeHeight(86),
                            height: MySize.getScaledSizeHeight(86),
                            placeHolder: icons.appIcon,
                            topCorner: 86,
                            bottomCorner: 86,
                          ),
                        ),
                        20.0.hSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            commonText.regular(
                              text: AppMessage.fullName,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: commonText.regular(
                                  text: "${controller.birthdayData?.fullName}",
                                  fontSize: MySize.getScaledSizeHeight(16),
                                  textColor: color.black,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                              text: AppMessage.staffId,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                            commonText.regular(
                              text: "${controller.birthdayData?.id}",
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
                              text: AppMessage.phoneNumber,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                            commonText.regular(
                              text: controller.birthdayData!.countryCode.toString().contains("+")
                                  ? '${controller.birthdayData!.countryCode}  ${controller.birthdayData!.mobileNo}'
                                  : '+${controller.birthdayData!.countryCode}  ${controller.birthdayData!.mobileNo}',
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
                              text: AppMessage.gender,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                            commonText.regular(
                              text: controller.birthdayData?.gender == "male" ? 'Male' : 'Female',
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
                              text: AppMessage.dateOfBirth,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                            commonText.regular(
                              text: commonMethod.convertDateFormat(controller.birthdayData!.dob.toString()),
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
                              text: AppMessage.joiningDate,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                            commonText.regular(
                              text: commonMethod.convertDateFormat(controller.birthdayData!.joiningDate.toString()),
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
                              text: AppMessage.experience,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: commonText.regular(
                                  text: controller.birthdayData!.experience,
                                  fontSize: MySize.getScaledSizeHeight(16),
                                  textColor: color.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        18.0.hSpace(),
                        commonText.regular(
                          text: AppMessage.aboutStaff,
                          fontSize: MySize.getScaledSizeHeight(14),
                          textColor: color.textFieldTextColor,
                        ),
                        12.0.hSpace(),
                        commonText.regular(
                          text: controller.birthdayData!.aboutStaff,
                          fontSize: MySize.getScaledSizeHeight(14),
                          textColor: color.black,
                        ),
                        20.0.hSpace(),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CachedImageContainer(
                            image: controller.birthdayData?.profilePic,
                            fit: BoxFit.cover,
                            width: MySize.getScaledSizeHeight(86),
                            height: MySize.getScaledSizeHeight(86),
                            placeHolder: icons.appIcon,
                            topCorner: 86,
                            bottomCorner: 86,
                          ),
                        ),
                        20.0.hSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            commonText.regular(
                              text: AppMessage.fullName,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: commonText.regular(
                                  text: "${controller.birthdayData?.fullName}",
                                  fontSize: MySize.getScaledSizeHeight(16),
                                  textColor: color.black,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                              text: AppMessage.studentId,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                            commonText.regular(
                              text: "${controller.birthdayData?.id}",
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
                              text: AppMessage.phoneNumber,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                            commonText.regular(
                              text: controller.birthdayData!.countryCode.toString().contains("+")
                                  ? '${controller.birthdayData!.countryCode}  ${controller.birthdayData!.mobileNo}'
                                  : '+${controller.birthdayData!.countryCode}  ${controller.birthdayData!.mobileNo}',
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
                              text: AppMessage.gender,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                            commonText.regular(
                              text: controller.birthdayData?.gender == "male" ? 'Male' : 'Female',
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
                              text: AppMessage.dateOfBirth,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                            commonText.regular(
                              text: commonMethod.convertDateFormat(controller.birthdayData!.dob.toString()),
                              fontSize: MySize.getScaledSizeHeight(16),
                              textColor: color.black,
                            ),
                          ],
                        ),
                        20.0.hSpace(),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
