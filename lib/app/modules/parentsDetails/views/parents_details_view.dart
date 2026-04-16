import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:radianthyve_unified/app/modules/addParents/views/add_parents_view.dart';
import 'package:radianthyve_unified/app/modules/chat/views/chat_view.dart';
import 'package:radianthyve_unified/app/modules/editAccountInformation/views/edit_account_information_view.dart';
import 'package:radianthyve_unified/app/modules/studentDetails/views/student_details_view.dart';
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
import '../../../../commonWidgets/enums.dart';
import '../controllers/parents_details_controller.dart';

class ParentsDetailsView extends GetView<ParentsDetailsController> {
  const ParentsDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParentsDetailsController>(
      init: ParentsDetailsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: AppMessage.parentsDetails,
            backgroundColor: color.transparentColor,
            actions: [Button().paddingOnly(right: MySize.getScaledSizeHeight(12), top: MySize.getScaledSizeHeight(12))],
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
                                : controller.parentData?.profilePic != null
                                ? CachedImageContainer(
                                  image: controller.parentData?.profilePic,
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
                  Row(
                    children: [
                      commonText.medium(text: AppMessage.parentsInformation, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                      Spacer(),
                      Obx(() {
                        return controller.isChatLoading.value
                            ? SpinKitThreeBounce(color: color.appColor, size: MySize.getScaledSizeHeight(20))
                            : InkWell(
                              onTap: () {
                                if (controller.parentData?.chatId == 0 ||
                                    controller.parentData?.chatId == "0" ||
                                    controller.parentData?.chatId == null ||
                                    controller.parentData?.chatId == "NULL" ||
                                    controller.parentData?.chatId == 'null') {
                                  controller.createChatApi();
                                } else {
                                  Get.to(
                                    () => ChatView(),
                                    arguments: {
                                      'flag': ChatType.CreateChat,
                                      'chatId': controller.parentData?.chatId,
                                      'profilePic': controller.parentData?.profilePic ?? '',
                                      'fullName': controller.parentData?.fullName ?? '',
                                      'otherID': controller.parentData?.id,
                                    },
                                  );
                                }
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
                            width: MySize.getScaledSizeWidth(115),
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
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: commonText.regular(
                                text: "${controller.parentData!.fullName}",
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
                          commonText.regular(text: "${controller.parentData!.id}", fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
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
                                controller.parentData!.countryCode.toString().contains("+")
                                    ? '${controller.parentData!.countryCode}  ${controller.parentData!.mobileNo}'
                                    : '+${controller.parentData!.countryCode}  ${controller.parentData!.mobileNo}',
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
                          commonText.regular(text: AppMessage.gender, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                          commonText.regular(
                            text: controller.parentData?.gender == "male" ? 'Male' : 'Female',
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
                          ),
                        ],
                      ),
                  18.0.hSpace(),
                  controller.isLoading.value
                      ? diagonalShimmer(
                        height: MySize.getScaledSizeHeight(18),
                        width: MySize.getScaledSizeWidth(70),
                        borderRadius: BorderRadius.circular(4),
                      )
                      : commonText.regular(text: AppMessage.address, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                  12.0.hSpace(),
                  controller.isLoading.value
                      ? diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: Get.width, borderRadius: BorderRadius.circular(4))
                      : commonText.regular(text: controller.parentData?.address, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                  30.0.hSpace(),
                  commonText.medium(text: AppMessage.parentsAccountInformation, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
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
                            width: MySize.getScaledSizeWidth(218),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(text: AppMessage.email, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: commonText.regular(
                                text: controller.parentData!.email,
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
                  commonText.medium(text: AppMessage.studentList, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                  16.0.hSpace(),
                  controller.isLoading.value
                      ? ListView.separated(
                        itemCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return diagonalShimmer(height: MySize.getScaledSizeHeight(205), width: Get.width, borderRadius: BorderRadius.circular(8));
                        },
                        separatorBuilder: (context, index) {
                          return 16.0.hSpace();
                        },
                      )
                      : controller.parentData!.students!.isEmpty
                      ? Container(
                        height: 100,
                        child: Center(
                          child: commonText.medium(text: "No student found", fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                        ),
                      )
                      : ListView.separated(
                        itemCount: controller.parentData!.students!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: color.white,
                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(12), vertical: MySize.getScaledSizeHeight(15)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: commonText.medium(
                                          text: controller.parentData!.students![index].fullName,
                                          fontSize: MySize.getScaledSizeHeight(16),
                                          textColor: color.black,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      commonText.medium(
                                        text: "${controller.parentData!.students![index].id}",
                                        fontSize: MySize.getScaledSizeHeight(16),
                                        textColor: color.black,
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
                                            text: AppMessage.relation,
                                            fontSize: MySize.getScaledSizeHeight(14),
                                            textColor: color.textFieldTextColor,
                                          ),
                                          commonText.medium(
                                            text: controller.parentData!.students![index].relationToChild,
                                            fontSize: MySize.getScaledSizeHeight(14),
                                            textColor: color.black,
                                          ),
                                        ],
                                      ),
                                      16.0.hSpace(),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          commonText.regular(
                                            text: 'Program: ',
                                            fontSize: MySize.getScaledSizeHeight(14),
                                            textColor: color.textFieldTextColor,
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: commonText.medium(
                                                text: controller.parentData!.students![index].shiftName,
                                                fontSize: MySize.getScaledSizeHeight(14),
                                                textColor: color.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      20.0.hSpace(),
                                      commonWidget
                                          .customButton(
                                            text: AppMessage.studentProfile,
                                            onTap: () {
                                              Get.to(
                                                () => StudentDetailsView(),
                                                arguments: {"studentList": controller.parentData!.students![index], 'flag': 'parentDetails'},
                                              );
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
                ],
              ),
            ),
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
    ParentsDetailsController controller = Get.put(ParentsDetailsController());
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
              Get.to(() => AddParentsView(), arguments: {'flag': 'editParents', 'parent_details': controller.parentData})!.then((value) {
                if (value == 1) {
                  controller.getParentDetailsApi();
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
                arguments: {"staff_id": controller.parentData!.id, "email": controller.parentData!.email, "type": "parents"},
              );
            },
          ),
          14.0.hSpace(),
          commonWidget.commonDivider(color: color.divider2Color),
          14.0.hSpace(),
          _commonRowImageWithText(
            image: icons.blockIcon,
            text: controller.parentData!.isBlocked == true ? "Un block" : AppMessage.block,
            onTap: () {
              Get.back();
              if (controller.parentData!.isBlocked == true) {
                controller.blockParentApi(status: "unBlock");
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(20))),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GetBuilder<ParentsDetailsController>(
                  assignId: false,
                  builder: (controller) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            commonText.medium(
                              text: AppMessage.deleteParentsProfiles,
                              fontSize: MySize.getScaledSizeHeight(18),
                              textColor: color.black,
                              textAlign: TextAlign.center,
                            ),
                            30.0.hSpace(),
                            ZoomIn(
                              duration: Duration(seconds: 3),
                              child: Image.asset(images.deleteImage, height: MySize.getScaledSizeHeight(104), width: MySize.getScaledSizeWidth(104)),
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
                                    controller.deleteReason.text.isNotEmpty ? color.textFieldErrorColor : color.textFieldErrorColor.withOpacity(0.5),
                                text: AppMessage.yesDeleteAccount,
                                isLoading: controller.isBlockLoading.value,
                                onTap: () {
                                  if (controller.deleteReason.text.isNotEmpty) {
                                    controller.deleteParentApi();
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

  void blockDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(20))),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GetBuilder<ParentsDetailsController>(
                  assignId: false,
                  builder: (controller) {
                    return Container(
                      padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          commonText.medium(
                            text: AppMessage.restrictAccessForParents,
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
                            text: AppMessage.thisActionWillRestrictTheParents,
                            fontSize: MySize.getScaledSizeHeight(16),
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
                                  controller.blockParentApi(status: "Block");
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
