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
import '../../forgotPassword/views/forgot_password_view.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      assignId: true,
      builder: (controller) {
        return Obx(() {
          return IgnorePointer(
            ignoring: controller.isLoading.value,
            child: Scaffold(
              backgroundColor: color.appColor,
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
                leading: SizedBox(),
                toolbarHeight: 0.0,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: color.appGradient,
                ),
                child: Column(
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
                              commonText.semiBold(text: AppMessage.signInToYourAccount, fontSize: MySize.getScaledSizeHeight(20), textColor: color.black),
                              16.0.hSpace(),
                              commonText.regular(text: AppMessage.enterYourAccountDetails, fontSize: MySize.getScaledSizeHeight(16), textColor: color.textFieldTextColor),
                              16.0.hSpace(),
                              Obx(() {
                                return commonWidget.commonTextField(
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                                  keyboardType: TextInputType.emailAddress,
                                  controller: controller.emailController,
                                  labelText: AppMessage.email,
                                  onFieldSubmitted: (value) {
                                    controller.isSelect.value = 1;
                                  },
                                  hintText: AppMessage.enterEmail,
                                  errorText: controller.errorEmail.value,
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
                                  controller: controller.passwordController,
                                  labelText: AppMessage.password,
                                  hintText: AppMessage.enterPassword,
                                  errorText: controller.errorPassword.value,
                                  obscureText: controller.isVisibilityPassword.value,
                                  textInputAction: TextInputAction.done,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      controller.isVisibilityPassword.value = !controller.isVisibilityPassword.value;
                                    },
                                    child: Image.asset(
                                      controller.isVisibilityPassword.value ? icons.eyeCloseIcon : icons.eyeIcon,
                                      scale: 4,
                                    ).paddingOnly(right: 10),
                                  ),
                                  onTap: () {
                                    controller.isSelect.value = 1;
                                  },
                                  onChanged: (value) {
                                    controller.isSelect.value = 1;
                                    controller.isValidation();
                                  },
                                  isbordervisibal: controller.isSelect.value == 1,
                                  contentPadding: EdgeInsets.only(
                                    top: MySize.getScaledSizeHeight(10),
                                    left: MySize.getScaledSizeWidth(10),
                                  ),
                                );
                              }),
                              16.0.hSpace(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => ForgotPasswordView());
                                    },
                                    child: commonText.medium(text: AppMessage.ForgotPassword, textColor: color.textFieldTextColor, fontSize: MySize.getScaledSizeHeight(14)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ),
              bottomNavigationBar: Container(
                padding: EdgeInsets.only(bottom: Platform.isIOS ? MySize.getScaledSizeHeight(15) : 0),
                color: color.white,
                child: Obx(() {
                  return commonWidget.customButton(
                    isLoading: controller.isLoading.value,
                    text: AppMessage.signIn,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xff9810FA),
                        Color(0xff4F39F6),
                      ],
                    ),
                    onTap: () {
                      if (controller.isValidation()) {
                        controller.loginApi();
                      }
                    },
                  );
                }).paddingAll(MySize.getScaledSizeHeight(16)),
              ),
            ),
          );
        });
      },
    );
  }
}
