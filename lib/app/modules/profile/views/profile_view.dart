import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/CachedImageContainer.dart';
import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_drawer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/popup.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../changePassword/views/change_password_view.dart';
import '../../editPersonalInformation/views/edit_personal_information_view.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            leading: Padding(
              padding: EdgeInsets.only(left: MySize.getScaledSizeHeight(15)),
              child: GestureDetector(
                onTap: () {
                  controller.scaffoldKey.currentState?.openDrawer();
                },
                child: Image.asset(icons.drawerIcon, height: MySize.getScaledSizeHeight(30), width: MySize.getScaledSizeWidth(30)),
              ),
            ),
            title: commonText.medium(text: AppMessage.profile, fontSize: MySize.getScaledSizeHeight(18), textColor: color.white),
            centerTitle: false,
            // toolbarHeight: 0.0,
            backgroundColor: color.appColor,
          ),
          drawer: drawer(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color.white,
                      borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(18))),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(MySize.getScaledSizeHeight(15)),
                      child: Row(
                        children: [
                          controller.isLoading.value
                              ? diagonalShimmer(
                                height: MySize.getScaledSizeHeight(86),
                                width: MySize.getScaledSizeHeight(86),
                                borderRadius: BorderRadius.circular(50),
                              )
                              : controller.image.value != ''
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  File(controller.image.value),
                                  height: MySize.getScaledSizeHeight(86),
                                  width: MySize.getScaledSizeHeight(86),
                                  fit: BoxFit.cover,
                                ),
                              )
                              : CachedImageContainer(
                                image: '${box.read(PrefsKey.profilePic)}',
                                fit: BoxFit.cover,
                                width: MySize.getScaledSizeHeight(86),
                                height: MySize.getScaledSizeHeight(86),
                                placeHolder: images.appIcon,
                                topCorner: 86,
                                bottomCorner: 86,
                              ),
                          18.0.wSpace(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                controller.isLoading.value
                                    ? diagonalShimmer(
                                      height: MySize.getScaledSizeHeight(20),
                                      width: MySize.getScaledSizeHeight(145),
                                      borderRadius: BorderRadius.circular(4),
                                    )
                                    : commonText.medium(
                                      text: '${box.read(PrefsKey.fullName) ?? ''}',
                                      fontSize: MySize.getScaledSizeHeight(18),
                                      textColor: color.black,
                                      maxLines: 1,
                                    ),
                                11.0.hSpace(),
                                GestureDetector(
                                  onTap: () {
                                    profileBottomSheet(context: context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: color.backgroundColor,
                                      borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                                      border: Border.all(color: color.notificationContainerColor),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: MySize.getScaledSizeHeight(6),
                                        horizontal: MySize.getScaledSizeHeight(14),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(icons.editIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
                                          06.0.wSpace(),
                                          commonText.regular(
                                            text: AppMessage.editProfile,
                                            fontSize: MySize.getScaledSizeHeight(14),
                                            textColor: color.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  16.0.hSpace(),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => EditPersonalInformationView())!.then((value) {
                        if (value != null) {
                          controller.update();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.white,
                        borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: MySize.getScaledSizeHeight(14), horizontal: MySize.getScaledSizeHeight(12)),
                        child: Row(
                          children: [
                            Image.asset(
                              icons.editPersonalInformationIcon,
                              height: MySize.getScaledSizeHeight(24),
                              width: MySize.getScaledSizeWidth(24),
                            ),
                            06.0.wSpace(),
                            commonText.regular(
                              text: AppMessage.editPersonalInformation,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.black,
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_rounded, size: MySize.getScaledSizeHeight(20), color: color.textFieldTextColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  16.0.hSpace(),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ChangePasswordView());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.white,
                        borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: MySize.getScaledSizeHeight(14), horizontal: MySize.getScaledSizeHeight(12)),
                        child: Row(
                          children: [
                            Image.asset(icons.changePasswordIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
                            06.0.wSpace(),
                            commonText.regular(text: AppMessage.changePassword, fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_rounded, size: MySize.getScaledSizeHeight(20), color: color.textFieldTextColor),
                          ],
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
