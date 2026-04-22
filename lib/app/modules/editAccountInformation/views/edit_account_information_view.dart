import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import '../controllers/edit_account_information_controller.dart';

class EditAccountInformationView extends GetView<EditAccountInformationController> {
  const EditAccountInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditAccountInformationController>(
      init: EditAccountInformationController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: color.white,
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
              title: Text(
                AppMessage.editAccountInformation,
                style: TextStyle(
                  color: color.white,
                  fontSize: MySize.getScaledSizeHeight(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Obx(() {
                return IgnorePointer(
                  ignoring: controller.isLoading.value,
                  child: Padding(
                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                    child: Column(
                      children: [
                        Obx(() {
                          return commonWidget.commonTextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              FilteringTextInputFormatter.deny(
                                RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                              ),
                            ],
                            readOnly: true,
                            controller: controller.emailController,
                            labelText: AppMessage.email,
                            hintText: AppMessage.enterEmail,
                            errorText: controller.errorEmail.value,
                            textColor: color.editTextColor,
                            onTap: () {
                              controller.isSelect.value = 0;
                            },
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
                        16.0.hSpace(),
                        Obx(() {
                          return commonWidget.commonTextField(
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                            controller: controller.newPasswordController,
                            labelText: AppMessage.newPassword,
                            hintText: AppMessage.enterNewPassword,
                            errorText: controller.errorNewPassword.value,
                            obscureText: controller.isVisibilityNewPassword.value ? true : false,
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
                              controller.isSelect.value = 1;
                            },
                            onChanged: (value) {
                              controller.isSelect.value = 1;
                              if (controller.newPasswordController.text.trim().isEmpty ||
                                  (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@₹#.?\$&*~]).{8,}$')
                                      .hasMatch(controller.newPasswordController.text.trim()))) {
                                controller.errorNewPassword.value = controller.newPasswordController.text.trim().isEmpty
                                    ? AppMessage.pleaseEnterYourPassword
                                    : AppMessage.passwordShouldContainUpper;
                              } else {
                                controller.errorNewPassword.value = '';
                              }
                              controller.update();
                            },
                            isbordervisibal: controller.isSelect.value == 1 ? true : false,
                            contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(10), left: MySize.getScaledSizeWidth(10)),
                          );
                        }),
                        16.0.hSpace(),
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
                              child: Image.asset(
                                controller.isVisibilityConfirmPassword.value ? icons.eyeCloseIcon : icons.eyeIcon,
                                scale: 4,
                              ).paddingOnly(right: 10),
                            ),
                            onTap: () {
                              controller.isSelect.value = 2;
                            },
                            onChanged: (value) {
                              controller.isSelect.value = 2;
                              if (controller.confirmPasswordController.text.trim().isEmpty) {
                                controller.errorConfirmPassword.value = AppMessage.pleaseEnterYourPassword;
                              } else if (controller.newPasswordController.text.trim() != controller.confirmPasswordController.text.trim()) {
                                controller.errorConfirmPassword.value = controller.confirmPasswordController.text.trim().isEmpty
                                    ? AppMessage.pleaseEnterConfirmPassword
                                    : AppMessage.passwordDoesNotMatch;
                              } else {
                                controller.errorConfirmPassword.value = '';
                              }
                            },
                            isbordervisibal: controller.isSelect.value == 2 ? true : false,
                            contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(10), left: MySize.getScaledSizeWidth(10)),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),
            ),
            bottomNavigationBar: Obx(() {
              return commonWidget.customButton(
                text: AppMessage.updatePassword,
                isLoading: controller.isLoading.value,
                gradient: color.buttonGradient,
                onTap: () {
                  if (controller.isValidation()) {
                    controller.StaffPasswordApi();
                  }
                },
              );
            }).paddingAll(MySize.getScaledSizeHeight(16)),
          ),
        );
      },
    );
  }
}
