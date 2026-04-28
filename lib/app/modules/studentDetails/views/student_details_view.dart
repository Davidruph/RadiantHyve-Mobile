import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/studentDailyAttendance/views/student_daily_attendance_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/commonWidgets/popup.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../../../../commonWidgets/CachedImageContainer.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/enums.dart';
import '../../chat/views/chat_view.dart';
import '../controllers/student_details_controller.dart';

class StudentDetailsView extends GetView<StudentDetailsController> {
  const StudentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentDetailsController>(
      init: StudentDetailsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
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
              title: Text(AppMessage.studentDetails, style: TextStyle(color: color.white, fontSize: MySize.getScaledSizeHeight(18))),
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.white),
              ),
            ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.isLoading.value
                      ? Center(
                        child: diagonalShimmer(
                          height: MySize.getScaledSizeHeight(80),
                          width: MySize.getScaledSizeHeight(80),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      )
                      : GestureDetector(
                        onTap: () {
                          profileBottomSheet(context: context);
                        },
                        child: Center(
                          child:
                              controller.isLoading.value
                                  ? diagonalShimmer(
                                    height: MySize.getScaledSizeHeight(86),
                                    width: MySize.getScaledSizeHeight(86),
                                    borderRadius: BorderRadius.circular(50),
                                  )
                                  : controller.image != ''
                                  ? CachedImageContainer(
                                    image: '${controller.studentDetailsData?.profilePic}',
                                    fit: BoxFit.cover,
                                    width: MySize.getScaledSizeHeight(80),
                                    height: MySize.getScaledSizeHeight(80),
                                    placeHolder: images.appIcon,
                                    topCorner: 80,
                                    bottomCorner: 80,
                                  )
                                  : CachedImageContainer(
                                    image: '${controller.studentDetailsData?.profilePic}',
                                    fit: BoxFit.cover,
                                    width: MySize.getScaledSizeHeight(80),
                                    height: MySize.getScaledSizeHeight(80),
                                    placeHolder: images.appIcon,
                                    topCorner: 80,
                                    bottomCorner: 80,
                                  ),
                        ),
                      ),
                  12.0.hSpace(),
                  GestureDetector(
                    onTap: () {
                      profileBottomSheet(context: context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(icons.editIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
                        06.0.wSpace(),
                        commonText.regular(text: AppMessage.editProfilePicture, fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                      ],
                    ),
                  ),
                  20.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(72),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(125),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.fullName,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: controller.studentDetailsData?.fullName,
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
                            height: MySize.getScaledSizeHeight(18),
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
                            text: '${controller.studentDetailsData?.id}',
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
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(100),
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
                            text: controller.studentDetailsData?.parentName,
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
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(152),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(130),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.homePhoneNumber,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: '${controller.studentDetailsData?.countryCode} ${controller.studentDetailsData?.mobileNo}',
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
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(88),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(90),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.dateOfBirth,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: controller.formatDate(controller.studentDetailsData!.dob.toString()),
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
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(54),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(50),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.gender,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: controller.studentDetailsData?.gender,
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
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(58),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(40),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.relation,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: controller.studentDetailsData?.relationToChild,
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
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(162),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(152),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.frequencyAttendance,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),

                          Flexible(
                            child: commonText.medium(
                              text: controller.studentDetailsData?.shiftName,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.black,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                  18.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(190),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(110),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.medicalInsuranceNumber,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: '${controller.studentDetailsData?.madicalInsuaranceNo ?? ''}',
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
                          ),
                        ],
                      ),
                  18.0.hSpace(),
                  controller.isLoading.value
                      ? diagonalShimmer(
                        height: MySize.getScaledSizeHeight(18),
                        width: MySize.getScaledSizeWidth(60),
                        borderRadius: BorderRadius.circular(4),
                      )
                      : commonText.regular(
                        text: AppMessage.address,
                        fontSize: MySize.getScaledSizeHeight(14),
                        textColor: color.textFieldTextColor,
                      ),
                  12.0.hSpace(),
                  controller.isLoading.value
                      ? diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: Get.width, borderRadius: BorderRadius.circular(4))
                      : commonText.regular(
                        text: "${controller.studentDetailsData?.address ?? ''}",
                        fontSize: MySize.getScaledSizeHeight(14),
                        textColor: color.black,
                      ),
                  18.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(102),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(130),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(
                            text: AppMessage.assignedStaff,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: controller.studentDetailsData?.teacherName,
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
                          ),
                        ],
                      ),
                  30.0.hSpace(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonText.medium(text: AppMessage.parentsDetails, textColor: color.black, fontSize: MySize.getScaledSizeHeight(16)),
                      16.0.hSpace(),
                      controller.isLoading.value
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              diagonalShimmer(
                                height: MySize.getScaledSizeHeight(18),
                                width: MySize.getScaledSizeWidth(72),
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
                                text: AppMessage.fullName,
                                fontSize: MySize.getScaledSizeHeight(14),
                                textColor: color.textFieldTextColor,
                              ),
                              commonText.regular(
                                text: controller.studentDetailsData?.studentParent?.fullName ?? '',
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
                                height: MySize.getScaledSizeHeight(18),
                                width: MySize.getScaledSizeWidth(72),
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
                                text: AppMessage.parentsId,
                                fontSize: MySize.getScaledSizeHeight(14),
                                textColor: color.textFieldTextColor,
                              ),
                              commonText.regular(
                                text: '${controller.studentDetailsData?.studentParent?.id}',
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
                                height: MySize.getScaledSizeHeight(18),
                                width: MySize.getScaledSizeWidth(106),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              diagonalShimmer(
                                height: MySize.getScaledSizeHeight(18),
                                width: MySize.getScaledSizeWidth(130),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              commonText.regular(
                                text: AppMessage.phoneNumber,
                                fontSize: MySize.getScaledSizeHeight(14),
                                textColor: color.textFieldTextColor,
                              ),
                              commonText.regular(
                                text:
                                    '${controller.studentDetailsData?.studentParent?.countryCode} ${controller.studentDetailsData?.studentParent?.mobileNo}',
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
                                height: MySize.getScaledSizeHeight(18),
                                width: MySize.getScaledSizeWidth(54),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              diagonalShimmer(
                                height: MySize.getScaledSizeHeight(18),
                                width: MySize.getScaledSizeWidth(50),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              commonText.regular(
                                text: AppMessage.gender,
                                fontSize: MySize.getScaledSizeHeight(14),
                                textColor: color.textFieldTextColor,
                              ),
                              commonText.regular(
                                text: '${controller.studentDetailsData?.studentParent?.gender}',
                                fontSize: MySize.getScaledSizeHeight(16),
                                textColor: color.black,
                              ),
                            ],
                          ),
                      18.0.hSpace(),
                      controller.isLoading.value
                          ? diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(60),
                            borderRadius: BorderRadius.circular(4),
                          )
                          : commonText.regular(
                            text: AppMessage.address,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                      12.0.hSpace(),
                      controller.isLoading.value
                          ? diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: Get.width, borderRadius: BorderRadius.circular(4))
                          : commonText.regular(
                            text: '${controller.studentDetailsData?.studentParent?.address ?? ''}',
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.black,
                          ),
                      30.0.hSpace(),
                      Obx(
                        () => InkWell(
                          onTap: () {
                            if (controller.studentDetailsData?.studentParent?.chatId == null) {
                              controller.createChatApi();
                            } else {
                              Get.to(
                                () => ChatView(),
                                arguments: {
                                  'flag': ChatType.StudentDetails,
                                  'chatId': controller.studentDetailsData?.studentParent?.chatId,
                                  'profilePic': controller.studentDetailsData?.studentParent?.profilePic,
                                  'fullName': controller.studentDetailsData?.studentParent?.fullName,
                                  "otherID": controller.studentDetailsData?.studentParent?.id,
                                },
                              );
                            }
                          },
                          child: Container(
                            height: MySize.getScaledSizeHeight(48),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                              border: Border.all(color: color.appColor),
                            ),
                            child: Center(
                              child:
                                  controller.isChatLoading.value
                                      ? CommonLoader(color: color.appColor, size: MySize.getScaledSizeHeight(30))
                                      : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            icons.message,
                                            height: MySize.getScaledSizeHeight(24),
                                            width: MySize.getScaledSizeWidth(24),
                                            color: color.appColor,
                                            fit: BoxFit.fill,
                                          ),
                                          10.0.wSpace(),
                                          commonText.medium(
                                            text: AppMessage.chatWithParents,
                                            textColor: color.appColor,
                                            fontSize: MySize.getScaledSizeHeight(16),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: commonWidget
              .customButton(
                text: AppMessage.viewStudentAttendance,
                gradient: color.appGradient,
                onTap: () {
                  Get.to(() => StudentDailyAttendanceView(), arguments: {'studentId': controller.studentDetailsData?.id});
                },
              )
              .paddingAll(MySize.getScaledSizeHeight(16)),
        );
      },
    );
  }

  profileBottomSheet({required context}) {
    return commonWidget.bottomSheet(
      child: Column(
        children: [
          16.0.hSpace(),
          InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              Get.back();
              controller.pickMedia(argument: 1);
            },
            child: Row(
              children: [
                Image.asset(icons.cameraIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
                10.0.wSpace(),
                commonText.medium(text: AppMessage.takeAPicture, textColor: color.black, fontSize: MySize.getScaledSizeHeight(14)),
              ],
            ),
          ),
          20.0.hSpace(),
          commonWidget.commonDivider(),
          20.0.hSpace(),
          InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              Get.back();
              controller.pickMedia(argument: 2);
            },
            child: Row(
              children: [
                Image.asset(icons.galleryIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
                10.0.wSpace(),
                commonText.medium(text: AppMessage.selectFromGallery, textColor: color.black, fontSize: MySize.getScaledSizeHeight(14)),
              ],
            ),
          ),
          30.0.hSpace(),
        ],
      ).paddingSymmetric(horizontal: MySize.getScaledSizeWidth(16)),
    );
  }
}
