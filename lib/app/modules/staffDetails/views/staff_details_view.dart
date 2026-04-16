import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../utils/common.dart';
import 'package:popover/popover.dart';
import 'package:radianthyve_unified/app/modules/StaffDailyAttendance/views/staff_daily_attendance_view.dart';
import 'package:radianthyve_unified/app/modules/addStaff/views/add_staff_view.dart';
import 'package:radianthyve_unified/app/modules/assignedStudent/views/assigned_student_view.dart';
import 'package:radianthyve_unified/app/modules/editAccountInformation/views/edit_account_information_view.dart';
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
import '../controllers/staff_details_controller.dart';

class StaffDetailsView extends GetView<StaffDetailsController> {
  const StaffDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StaffDetailsController>(
      init: StaffDetailsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: AppMessage.staffDetails,
            backgroundColor: color.transparentColor,
            actions: [
              controller.flag == 'birthdayDetails'
                  ? SizedBox()
                  : Button().paddingOnly(right: MySize.getScaledSizeHeight(12), top: MySize.getScaledSizeHeight(12)),
            ],
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
                      : Center(
                        child:
                            controller.image.value != ''
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    File(controller.image.value),
                                    height: MySize.getScaledSizeHeight(80),
                                    width: MySize.getScaledSizeHeight(80),
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : controller.staffDetailsData?.profilePic != null
                                ? CachedImageContainer(
                                  image: controller.staffDetailsData?.profilePic,
                                  fit: BoxFit.cover,
                                  width: MySize.getScaledSizeHeight(86),
                                  height: MySize.getScaledSizeHeight(86),
                                  placeHolder: icons.appIcon,
                                  topCorner: 86,
                                  bottomCorner: 86,
                                )
                                : ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    icons.profileCircle,
                                    height: MySize.getScaledSizeHeight(86),
                                    width: MySize.getScaledSizeWidth(86),
                                  ),
                                ),
                      ),
                  12.0.hSpace(),
                  controller.flag == 'birthdayDetails'
                      ? SizedBox()
                      : GestureDetector(
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
                  controller.flag == 'birthdayDetails'
                      ? SizedBox()
                      : Row(
                        children: [
                          commonText.medium(text: AppMessage.staffInformation, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                          Spacer(),
                          Obx(() {
                            return controller.isChatLoading.value
                                ? SpinKitThreeBounce(color: color.appColor, size: MySize.getScaledSizeHeight(20))
                                : InkWell(
                                  onTap: () {
                                    if (controller.staffDetailsData?.chatId == 0 ||
                                        controller.staffDetailsData?.chatId == "0" ||
                                        controller.staffDetailsData?.chatId == null ||
                                        controller.staffDetailsData?.chatId == "NULL" ||
                                        controller.staffDetailsData?.chatId == 'null') {
                                      controller.createChatApi();
                                    } else {
                                      Get.to(
                                        () => ChatView(),
                                        arguments: {
                                          'flag': ChatType.CreateChat,
                                          'chatId': controller.staffDetailsData?.chatId,
                                          'profilePic': controller.staffDetailsData?.profilePic ?? '',
                                          'fullName': controller.staffDetailsData?.fullName ?? '',
                                          'otherID': controller.staffDetailsData?.id,
                                        },
                                      );
                                    }
                                    // Get.to(() => ChatView(), arguments: {});
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        icons.message,
                                        height: MySize.getScaledSizeHeight(20),
                                        width: MySize.getScaledSizeWidth(20),
                                        color: color.appColor,
                                      ),
                                      06.0.wSpace(),
                                      commonText.medium(text: AppMessage.chat, fontSize: MySize.getScaledSizeHeight(12), textColor: color.appColor),
                                    ],
                                  ),
                                );
                          }),
                        ],
                      ),
                  16.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(70),
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
                            text: AppMessage.fullName,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: commonText.regular(
                                text: "${controller.staffDetailsData?.fullName}",
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
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(50),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(70),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(text: AppMessage.staffId, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                          commonText.regular(
                            text: "${controller.staffDetailsData?.id}",
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
                            width: MySize.getScaledSizeWidth(104),
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
                            text: '${controller.staffDetailsData?.countryCode} ${controller.staffDetailsData?.mobileNo}',
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
                            width: MySize.getScaledSizeWidth(45),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(text: AppMessage.gender, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                          commonText.regular(
                            text: controller.staffDetailsData?.gender == "male" ? 'Male' : 'Female',
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
                            text: commonMethod.convertDateFormat(controller.staffDetailsData!.dob.toString()),
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
                            width: MySize.getScaledSizeWidth(90),
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
                            text: AppMessage.joiningDate,
                            fontSize: MySize.getScaledSizeHeight(14),
                            textColor: color.textFieldTextColor,
                          ),
                          commonText.regular(
                            text: commonMethod.convertDateFormat(controller.staffDetailsData!.joiningDate.toString()),
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
                            width: MySize.getScaledSizeWidth(78),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(60),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
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
                                text: controller.staffDetailsData!.experience,
                                fontSize: MySize.getScaledSizeHeight(16),
                                textColor: color.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                  18.0.hSpace(),
                  controller.isLoading.value
                      ? diagonalShimmer(
                        height: MySize.getScaledSizeHeight(18),
                        width: MySize.getScaledSizeWidth(80),
                        borderRadius: BorderRadius.circular(4),
                      )
                      : commonText.regular(
                        text: AppMessage.aboutStaff,
                        fontSize: MySize.getScaledSizeHeight(14),
                        textColor: color.textFieldTextColor,
                      ),
                  12.0.hSpace(),
                  controller.isLoading.value
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: Get.width, borderRadius: BorderRadius.circular(4)),
                          06.0.hSpace(),
                          diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: Get.width, borderRadius: BorderRadius.circular(4)),
                          06.0.hSpace(),
                          diagonalShimmer(
                            height: MySize.getScaledSizeHeight(18),
                            width: MySize.getScaledSizeWidth(100),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : commonText.regular(
                        text: controller.staffDetailsData!.aboutStaff,
                        fontSize: MySize.getScaledSizeHeight(14),
                        textColor: color.black,
                      ),
                  20.0.hSpace(),
                  controller.flag == 'birthdayDetails'
                      ? SizedBox()
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          controller.isLoading.value
                              ? diagonalShimmer(
                                height: MySize.getScaledSizeHeight(18),
                                width: MySize.getScaledSizeWidth(210),
                                borderRadius: BorderRadius.circular(4),
                              )
                              : commonText.medium(
                                text: AppMessage.staffAccountInformation,
                                fontSize: MySize.getScaledSizeHeight(16),
                                textColor: color.black,
                              ),
                          16.0.hSpace(),
                          controller.isLoading.value
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  diagonalShimmer(
                                    height: MySize.getScaledSizeHeight(18),
                                    width: MySize.getScaledSizeWidth(40),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  diagonalShimmer(
                                    height: MySize.getScaledSizeHeight(18),
                                    width: MySize.getScaledSizeWidth(215),
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
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: commonText.regular(
                                        text: controller.staffDetailsData!.email,
                                        fontSize: MySize.getScaledSizeHeight(16),
                                        textColor: color.black,
                                      ),
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
                                    width: MySize.getScaledSizeWidth(70),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  diagonalShimmer(
                                    height: MySize.getScaledSizeHeight(18),
                                    width: MySize.getScaledSizeWidth(104),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              )
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  commonText.regular(
                                    text: AppMessage.password,
                                    fontSize: MySize.getScaledSizeHeight(14),
                                    textColor: color.textFieldTextColor,
                                  ),
                                  commonText.regular(text: '*************', fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                                ],
                              ),
                          20.0.hSpace(),
                          Container(
                            decoration: BoxDecoration(
                              color: color.white,
                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: MySize.getScaledSizeHeight(16), horizontal: MySize.getScaledSizeHeight(12)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      commonText.medium(
                                        text: AppMessage.assignedStudent,
                                        fontSize: MySize.getScaledSizeHeight(16),
                                        textColor: color.black,
                                      ),
                                      Obx(() {
                                        return controller.isLoading.value == false
                                            ? commonText.medium(
                                              text: '${controller.staffDetailsData!.totalStudent} Student',
                                              fontSize: MySize.getScaledSizeHeight(18),
                                              textColor: color.appColor,
                                            )
                                            : SizedBox();
                                      }),
                                    ],
                                  ),
                                  21.0.hSpace(),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => AssignedStudentView(), arguments: {'staffId': controller.staffDetailsData!.id});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                                        color: color.viewStudentsColor,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: MySize.getScaledSizeHeight(10),
                                          vertical: MySize.getScaledSizeHeight(8),
                                        ),
                                        child: commonText.regular(
                                          text: AppMessage.viewStudentsDetails,
                                          fontSize: MySize.getScaledSizeHeight(14),
                                          textColor: color.textFieldTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ),
          bottomNavigationBar:
              controller.flag == 'birthdayDetails'
                  ? SizedBox()
                  : Container(
                    decoration: BoxDecoration(
                      color: color.white,
                      border: Border(top: BorderSide(color: color.notificationContainerColor, width: 1.0)),
                    ),
                    child: commonWidget
                        .customButton(
                          text: AppMessage.viewDailyAttendance,
                          onTap: () {
                            // Get.to(() => DailyAttendanceView());
                            Get.to(() => StaffDailyAttendanceView(), arguments: {"user_id": controller.staffId.value});
                          },
                        )
                        .paddingAll(MySize.getScaledSizeHeight(16)),
                  ),
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
            width: MySize.getScaledSizeWidth(247),
            height: MySize.getScaledSizeHeight(220),
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
    StaffDetailsController controller = Get.put(StaffDetailsController());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _commonRowImageWithText(
            image: icons.editIcon,
            text: AppMessage.editProfileInformation,
            onTap: () {
              Get.back();
              Get.to(() => AddStaffView(), arguments: {'flag': 'editStaff', "staff_details": controller.staffDetailsData})!.then((value) {
                if (value == 1) {
                  controller.getStaffDetailsApi();
                }
              });
            },
          ),
          14.0.hSpace(),
          commonWidget.commonDivider(color: color.divider2Color),
          14.0.hSpace(),
          _commonRowImageWithText(
            image: icons.editIcon,
            text: AppMessage.editAccountInformation,
            onTap: () {
              Get.back();
              Get.to(
                () => EditAccountInformationView(),
                arguments: {"staff_id": controller.staffId.value, "email": controller.staffDetailsData!.email, "type": "staff"},
              );
            },
          ),
          14.0.hSpace(),
          commonWidget.commonDivider(color: color.divider2Color),
          14.0.hSpace(),
          _commonRowImageWithText(
            image: icons.blockIcon,
            text: controller.staffDetailsData!.isBlocked == true ? "Un block" : AppMessage.block,
            onTap: () {
              Get.back();
              if (controller.staffDetailsData!.isBlocked == true) {
                controller.blockStaffApi(status: "unBlock");
              } else {
                blockDialog(context: context);
              }
            },
          ),
          14.0.hSpace(),
          commonWidget.commonDivider(color: color.divider2Color),
          14.0.hSpace(),
          _commonRowImageWithText(
            image: icons.deleteIcon,
            text: AppMessage.delete,
            onTap: () {
              Get.back();
              deleteAccountDialog(context: context);
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

  void deleteAccountDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(20)),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(20))),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
                  child: GetBuilder<StaffDetailsController>(
                    assignId: false,
                    builder: (controller) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Container(
                            padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                commonText.medium(
                                  text: AppMessage.deleteTeacherProfiles,
                                  fontSize: MySize.getScaledSizeHeight(18),
                                  textColor: color.black,
                                  textAlign: TextAlign.center,
                                ),
                                30.0.hSpace(),
                                ZoomIn(
                                  duration: Duration(seconds: 3),
                                  child: Image.asset(
                                    images.deleteImage,
                                    height: MySize.getScaledSizeHeight(104),
                                    width: MySize.getScaledSizeWidth(104),
                                  ),
                                ),
                                30.0.hSpace(),
                                commonText
                                    .medium(
                                      text: AppMessage.areYouSureYouWantToDeleteAnAccount,
                                      fontSize: MySize.getScaledSizeHeight(16),
                                      textColor: color.black,
                                      textAlign: TextAlign.center,
                                    )
                                    .paddingSymmetric(horizontal: MySize.getScaledSizeHeight(14)),
                                16.0.hSpace(),
                                commonText.regular(
                                  text: AppMessage.thisDecisionIsFinalAnd,
                                  fontSize: MySize.getScaledSizeHeight(16),
                                  textColor: color.black,
                                  textAlign: TextAlign.center,
                                ),
                                20.0.hSpace(),
                                Obx(() {
                                  return commonWidget.commonTextField(
                                    keyboardType: TextInputType.text,
                                    controller: controller.deleteReason,
                                    labelText: "Reason",
                                    hintText: 'Enter',
                                    height: MySize.getScaledSizeHeight(110),
                                    maxLines: 6,
                                    minLines: 6,
                                    errorText: controller.errorDelete.value,
                                    onTap: () {
                                      controller.isSelect.value = 1;
                                    },
                                    onChanged: (value) {
                                      controller.isSelect.value = 1;
                                      controller.errorDelete.value = "";
                                      controller.update();
                                    },
                                    isbordervisibal: controller.isSelect.value == 61 ? true : false,
                                  );
                                }),
                                20.0.hSpace(),
                                Obx(() {
                                  return commonWidget.customButton(
                                    buttonColor:
                                        controller.deleteReason.text.isNotEmpty
                                            ? color.textFieldErrorColor
                                            : color.textFieldErrorColor.withOpacity(0.5),
                                    text: AppMessage.yesDeleteAccount,
                                    isLoading: controller.isBlockLoading.value,
                                    onTap: () {
                                      if (controller.deleteReason.text.isNotEmpty) {
                                        controller.deleteStaffApi();
                                      }
                                    },
                                  );
                                }),
                                16.0.hSpace(),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    height: MySize.getScaledSizeHeight(52),
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: color.homeTextColor,
                                      borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                                    ),
                                    child: Center(
                                      child: commonText.medium(
                                        text: AppMessage.cancel,
                                        textColor: color.cancelColor,
                                        fontSize: MySize.getScaledSizeHeight(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void blockDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(20)),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(20))),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GetBuilder<StaffDetailsController>(
                  assignId: false,
                  builder: (controller) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              commonText.medium(
                                text: AppMessage.restrictAccessForStaff,
                                fontSize: MySize.getScaledSizeHeight(18),
                                textColor: color.black,
                                textAlign: TextAlign.center,
                              ),
                              30.0.hSpace(),
                              ZoomIn(
                                duration: Duration(seconds: 3),
                                child: Image.asset(images.blockImage, height: MySize.getScaledSizeHeight(104), width: MySize.getScaledSizeWidth(104)),
                              ),
                              20.0.hSpace(),
                              commonText.medium(
                                text: AppMessage.areYouSureYouWantToBlock,
                                fontSize: MySize.getScaledSizeHeight(18),
                                textColor: color.black,
                                textAlign: TextAlign.center,
                              ),
                              16.0.hSpace(),
                              commonText.regular(
                                text: AppMessage.thisActionWillRestrictTheStaff,
                                fontSize: MySize.getScaledSizeHeight(14),
                                textColor: color.black,
                                textAlign: TextAlign.center,
                              ),
                              20.0.hSpace(),
                              Obx(() {
                                return commonWidget.commonTextField(
                                  keyboardType: TextInputType.text,
                                  controller: controller.blockReason,
                                  labelText: "Reason",
                                  hintText: 'Enter',
                                  height: MySize.getScaledSizeHeight(110),
                                  maxLines: 6,
                                  minLines: 6,
                                  errorText: controller.errorDelete.value,
                                  onTap: () {
                                    controller.isSelect.value = 1;
                                  },
                                  onChanged: (value) {
                                    controller.isSelect.value = 1;
                                    controller.errorDelete.value = "";
                                    controller.update();
                                  },
                                  isbordervisibal: controller.isSelect.value == 61 ? true : false,
                                );
                              }),
                              20.0.hSpace(),
                              Obx(() {
                                return commonWidget.customButton(
                                  buttonColor:
                                      controller.blockReason.text.isNotEmpty ? color.textFieldErrorColor : color.textFieldErrorColor.withOpacity(0.5),
                                  text: AppMessage.yesBlock,
                                  isLoading: controller.isBlockLoading.value,
                                  onTap: () {
                                    if (controller.blockReason.text.isNotEmpty) {
                                      controller.blockStaffApi(status: "Block");
                                    }
                                  },
                                );
                              }),
                              16.0.hSpace(),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  height: MySize.getScaledSizeHeight(52),
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    color: color.homeTextColor,
                                    borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                                  ),
                                  child: Center(
                                    child: commonText.medium(
                                      text: AppMessage.cancel,
                                      textColor: color.cancelColor,
                                      fontSize: MySize.getScaledSizeHeight(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
