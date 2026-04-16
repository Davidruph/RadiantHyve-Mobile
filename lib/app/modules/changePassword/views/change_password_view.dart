import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
      init: ChangePasswordController(),
      assignId: true,
      builder: (controller) {
        return Obx(() {
          return IgnorePointer(
            ignoring: controller.isLoading.value,
            child: Scaffold(
              backgroundColor: color.white,
              appBar: commonWidget.appBar(
              titleText: AppMessage.changePassword,
              backgroundColor: color.transparentColor,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.black),
              ),
            ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                  child: Column(
                    children: [
                      Obx(() {
                        return commonWidget.commonTextField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                          ],
                          readOnly: true,
                          controller: controller.emailController,
                          labelText: AppMessage.email,
                          hintText: AppMessage.enterEmail,
                          errorText: controller.errorEmail.value,
                          onTap: () {
                            controller.isSelect.value = 0;
                          },
                          textColor: color.editTextColor,
                          onChanged: (value) {
                            controller.isSelect.value = 0;
                            if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(controller.emailController.text)) {
                              controller.errorEmail.value = AppMessage.pleaseEnterValidEmail;
                            } else {
                              controller.errorEmail.value = "";
                            }
                          },
                          isbordervisibal: controller.isSelect.value == 0 ? true : false,
                        );
                      }),
                      18.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                          controller: controller.oldPasswordController,
                          labelText: AppMessage.currentPassword,
                          hintText: AppMessage.enterCurrentPassword,
                          errorText: controller.errorOldPassword.value,
                          obscureText: controller.isVisibilityOldPassword.value ? true : false,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            controller.isSelect.value = 2;
                          },
                          onChanged: (value) {
                            controller.isSelect.value = 1;
                            controller.isValidOldPassword();
                          },
                          onTap: () {
                            controller.isSelect.value = 1;
                          },

                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.isVisibilityOldPassword.value = !controller.isVisibilityOldPassword.value;
                            },
                            child: Image.asset(controller.isVisibilityOldPassword.value ? icons.eyeCloseIcon : icons.eyeIcon, scale: 4).paddingOnly(right: 10),
                          ),

                          isbordervisibal: controller.isSelect.value == 1 ? true : false,
                          contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(10), left: MySize.getScaledSizeWidth(10)),
                        );
                      }),
                      18.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                          controller: controller.newPasswordController,
                          labelText: AppMessage.newPassword,
                          hintText: AppMessage.enterNewPassword,
                          errorText: controller.errorNewPassword.value,
                          obscureText: controller.isVisibilityNewPassword.value ? true : false,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            controller.isSelect.value = 3;
                          },
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.isVisibilityNewPassword.value = !controller.isVisibilityNewPassword.value;
                            },
                            child: Image.asset(controller.isVisibilityNewPassword.value ? icons.eyeCloseIcon : icons.eyeIcon, scale: 4).paddingOnly(right: 10),
                          ),
                          onTap: () {
                            controller.isSelect.value = 2;
                          },
                          onChanged: (value) {
                            controller.isSelect.value = 2;
                            if (controller.oldPasswordController.text.isNotEmpty) {
                              controller.isValidOldPassword();
                            }
                            if (controller.newPasswordController.text.isNotEmpty) {
                              controller.isValidNewPassword();
                            }
                            if (controller.confirmPasswordController.text.isNotEmpty) {
                              controller.isValidConfirmPassword();
                            }
                          },
                          isbordervisibal: controller.isSelect.value == 2 ? true : false,
                          contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(10), left: MySize.getScaledSizeWidth(10)),
                        );
                      }),
                      18.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.deny(RegExp(r'\s'))],
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
                            child: Image.asset(controller.isVisibilityConfirmPassword.value ? icons.eyeCloseIcon : icons.eyeIcon, scale: 4).paddingOnly(right: 10),
                          ),
                          onTap: () {
                            controller.isSelect.value = 3;
                          },
                          onChanged: (value) {
                            controller.isSelect.value = 3;
                            if (controller.newPasswordController.text.isNotEmpty) {
                              controller.isValidNewPassword();
                            }
                            if (controller.confirmPasswordController.text.isNotEmpty) {
                              controller.isValidConfirmPassword();
                            }
                          },
                          isbordervisibal: controller.isSelect.value == 3 ? true : false,
                          contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(10), left: MySize.getScaledSizeWidth(10)),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                padding: EdgeInsets.only(bottom: Platform.isIOS ? MySize.getScaledSizeHeight(15) : 0),
                child: commonWidget
                    .customButton(
                      isLoading: controller.isLoading.value,
                      text: AppMessage.updatePassword,
                      onTap: () {
                        var isValidOldPassword = controller.isValidationOldPassword();
                        var isValidNewPassword = controller.isValidationNewPassword();
                        var isConfirmPassword = controller.isValidationConPassword();
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (isValidOldPassword && isValidNewPassword && isConfirmPassword) {
                          controller.changePasswordApi(context: context);
                        }
                      },
                    )
                    .paddingAll(MySize.getScaledSizeHeight(16)),
              ),
            ),
          );
        });
      },
    );
  }
}
