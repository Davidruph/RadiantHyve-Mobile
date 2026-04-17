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
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      init: ForgotPasswordController(),
      assignId: true,
      builder: (controller) {
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
                              commonText.semiBold(text: AppMessage.forgotYourPassword, fontSize: MySize.getScaledSizeHeight(20), textColor: color.black),
                              16.0.hSpace(),
                              commonText.regular(text: AppMessage.pleaseEnterYourRegisteredEmailAddress, fontSize: MySize.getScaledSizeHeight(16), textColor: color.textFieldTextColor),
                              16.0.hSpace(),
                              Obx(() {
                                return commonWidget.commonTextField(
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                                  keyboardType: TextInputType.emailAddress,
                                  controller: controller.emailController,
                                  labelText: AppMessage.email,
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
                  text: AppMessage.forgotPassword,
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
                      controller.forgotPasswordApi();
                    }
                  },
                );
              }).paddingAll(MySize.getScaledSizeHeight(16)),
            ),
          ),
        );
      },
    );
  }
}
