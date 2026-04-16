import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
      init: ResetPasswordController(),
      assignId: true,
      builder: (controller) {
        return Obx(() {
          return IgnorePointer(
            ignoring: controller.isLoading.value,
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                backgroundColor: color.appColor,
                appBar: commonWidget.appBar(
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                  backgroundColor: color.appColor,
                  iconColor: color.white,
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.back();
                  },
                ),
                body: Column(
                  children: [
                    76.0.hSpace(),
                    Center(
                      child: ZoomIn(
                        duration: Duration(seconds: 3),
                        child: Image.asset(images.splashImage, height: MySize.getScaledSizeHeight(110), width: MySize.getScaledSizeWidth(206), fit: BoxFit.fill),
                      ),
                    ),
                    20.0.hSpace(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: color.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(MySize.getScaledSizeHeight(30)), topRight: Radius.circular(MySize.getScaledSizeHeight(30))),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                04.0.hSpace(),
                                commonText.semiBold(text: AppMessage.resetPassword, fontSize: MySize.getScaledSizeHeight(20), textColor: color.black),
                                16.0.hSpace(),
                                commonText.regular(text: AppMessage.chooseAPasswordThatBoth, fontSize: MySize.getScaledSizeHeight(16), textColor: color.textFieldTextColor),
                                16.0.hSpace(),
                                Obx(() {
                                  return commonWidget.commonTextField(
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                                    keyboardType: TextInputType.emailAddress,
                                    controller: controller.newPasswordController,
                                    labelText: AppMessage.newPassword,
                                    hintText: AppMessage.enterNewPassword,
                                    errorText: controller.errorNewPassword.value,
                                    obscureText: controller.isVisibilityNewPassword.value,
                                    textInputAction: TextInputAction.next,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        controller.isVisibilityNewPassword.value = !controller.isVisibilityNewPassword.value;
                                      },
                                      child: Image.asset(
                                        controller.isVisibilityNewPassword.value ? icons.eyeCloseIcon : icons.eyeIcon,
                                        scale: 4,
                                      ).paddingOnly(right: 10),
                                    ),
                                    onTap: () {
                                      controller.isSelect.value = 0;
                                    },
                                    onChanged: (value) {
                                      controller.isSelect.value = 0;

                                      final passwordRegex = RegExp(r'^.{8,}$');

                                      if (controller.newPasswordController.text.trim().isEmpty ||
                                          !passwordRegex.hasMatch(controller.newPasswordController.text.trim())) {
                                        controller.errorNewPassword.value = controller.newPasswordController.text.trim().isEmpty
                                            ? AppMessage.pleaseEnterYourPassword
                                            : "Password must be at least 8 characters.";
                                      } else {
                                        controller.errorNewPassword.value = '';
                                      }
                                    },
                                    isbordervisibal: controller.isSelect.value == 0,
                                    contentPadding: EdgeInsets.only(
                                      top: MySize.getScaledSizeHeight(10),
                                      left: MySize.getScaledSizeWidth(10),
                                    ),
                                  );
                                }),
                                16.0.hSpace(),
                                Obx(() {
                                  return commonWidget.commonTextField(
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.deny(RegExp(r'\s')), // Prevent spaces
                                    ],
                                    keyboardType: TextInputType.visiblePassword,
                                    controller: controller.confirmPasswordController,
                                    labelText: AppMessage.confirmPassword,
                                    hintText: AppMessage.enterConfirmPassword,
                                    errorText: controller.errorConfirmPassword.value,
                                    obscureText: controller.isVisibilityConfirmPassword.value ? true : false,
                                    textInputAction: TextInputAction.done,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        controller.isVisibilityConfirmPassword.value = !controller.isVisibilityConfirmPassword.value;
                                      },
                                      child: Image.asset(
                                        controller.isVisibilityConfirmPassword.value ? icons.eyeCloseIcon : icons.eyeIcon,
                                        scale: 4,
                                      ).paddingOnly(right: 10),
                                    ),
                                    onTap: () {
                                      controller.isSelect.value = 1;
                                    },
                                    onChanged: (value) {
                                      controller.isSelect.value = 1;

                                      if (controller.confirmPasswordController.text.trim().isEmpty) {
                                        controller.errorConfirmPassword.value = AppMessage.pleaseEnterYourPassword;
                                      } else if (controller.newPasswordController.text.trim() != controller.confirmPasswordController.text.trim()) {
                                        controller.errorConfirmPassword.value = AppMessage.passwordDoesNotMatch;
                                      } else {
                                        controller.errorConfirmPassword.value = '';
                                      }
                                    },
                                    isbordervisibal: controller.isSelect.value == 1,
                                    contentPadding: EdgeInsets.only(
                                      top: MySize.getScaledSizeHeight(10),
                                      left: MySize.getScaledSizeWidth(10),
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: Container(
                  padding: EdgeInsets.only(bottom: Platform.isIOS ? MySize.getScaledSizeHeight(15) : 0),
                  color: color.white,
                  child: Obx(() {
                    return commonWidget.customButton(
                      isLoading: controller.isLoading.value,
                      text: AppMessage.updatePassword,
                      onTap: () {
                        if (controller.isValidation()) {
                          controller.resetPasswordApi();
                        }
                      },
                    );
                  }).paddingAll(MySize.getScaledSizeHeight(16)),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
