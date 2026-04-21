import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../controllers/verification_controller.dart';

class VerificationView extends GetView<VerificationController> {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationController>(
      init: VerificationController(),
      assignId: true,
      builder: (controller) {
        return Obx(() {
          return IgnorePointer(
            ignoring: controller.isLoading.value,
            child: Form(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
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
  child:Column(
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
                                  commonText.semiBold(text: AppMessage.enterVerificationCode, fontSize: MySize.getScaledSizeHeight(20), textColor: color.black),
                                  16.0.hSpace(),
                                  commonText.regular(text: AppMessage.weHaveJustSentA, fontSize: MySize.getScaledSizeHeight(16), textColor: color.textFieldTextColor),
                                  20.0.hSpace(),
                                  Center(
                                    child: Pinput(
                                      autofocus: true,
                                      focusNode: controller.focusNode,
                                      errorTextStyle: TextStyle(fontSize: MySize.getScaledSizeHeight(14), fontFamily: "Medium", color: Colors.red),
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                      controller: controller.otpPin,
                                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                                      onCompleted: (pin) {
                                        FocusManager.instance.primaryFocus!.unfocus();
                                        controller.forgotVerifyApi(context: context);
                                      },
                                      cursor: Container(height: MySize.getScaledSizeHeight(2), color: color.black, width: MySize.getScaledSizeWidth(10)),
                                      validator: (value) {
                                        if (value!.isEmpty || value == "") {
                                          return 'Please Enter OTP';
                                        } else if (value.length < 4) {
                                          return 'Please Enter Valid OTP';
                                        }
                                        return null;
                                      },
                                      focusedPinTheme: PinTheme(
                                        height: MySize.getScaledSizeHeight(52),
                                        width: MySize.getScaledSizeWidth(48),
                                        margin: EdgeInsets.only(right: MySize.getScaledSizeWidth(12)),
                                        textStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(16), fontFamily: "Medium", fontWeight: FontWeight.w500),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: color.textFieldFocusColor, width: 1),
                                          borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(12))),
                                        ),
                                      ),
                                      submittedPinTheme: PinTheme(
                                        height: MySize.getScaledSizeHeight(52),
                                        width: MySize.getScaledSizeWidth(48),
                                        margin: EdgeInsets.only(right: MySize.getScaledSizeWidth(12)),
                                        textStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(16), fontFamily: "Medium", fontWeight: FontWeight.w500),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(12))),
                                          border: Border.all(color: color.onboardingTextColor, width: 1),
                                        ),
                                      ),
                                      errorPinTheme: PinTheme(
                                        height: MySize.getScaledSizeHeight(52),
                                        width: MySize.getScaledSizeWidth(48),
                                        margin: EdgeInsets.only(right: MySize.getScaledSizeWidth(12)),
                                        textStyle: TextStyle(fontSize: MySize.getScaledSizeHeight(16), fontFamily: "Medium", fontWeight: FontWeight.w500),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: color.textFieldErrorColor, width: 1),
                                          borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(12))),
                                        ),
                                      ),
                                      defaultPinTheme: PinTheme(
                                        height: MySize.getScaledSizeHeight(52),
                                        width: MySize.getScaledSizeWidth(48),
                                        margin: EdgeInsets.only(right: MySize.getScaledSizeWidth(12)),
                                        textStyle: TextStyle(fontSize: MySize.getScaledSizeHeight(16), fontFamily: "Medium", fontWeight: FontWeight.w500),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(12))),
                                          border: Border.all(color: color.onboardingTextColor, width: 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  30.0.hSpace(),
                                  Obx(() {
                                    return controller.remainingTime.value == 0
                                        ? GestureDetector(
                                          onTap: () {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            controller.otpPin.clear();
                                            if (controller.remainingTime.value == 0) {
                                              controller.resendOtpApi(context: context);
                                            }
                                          },
                                          child: Center(
                                            child: Column(
                                              children: [
                                                commonText.regular(text: AppMessage.didntReceiveTheCode, textColor: color.textFieldTextColor, fontSize: MySize.getScaledSizeHeight(14)),
                                                12.0.hSpace(),
                                                commonText.regular(text: AppMessage.resendCode, textColor: color.black, fontSize: MySize.getScaledSizeHeight(14)),
                                              ],
                                            ),
                                          ),
                                        )
                                        : Center(child: commonText.medium(text: controller.formattedTime, fontSize: MySize.getScaledSizeHeight(16), textColor: color.appColor));
                                  }),
                                  16.0.hSpace(),
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
                        text: AppMessage.verify,
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xff9810FA),
                            Color(0xff4F39F6),
                          ],
                        ),
                        onTap: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          if (controller.formKey.currentState!.validate()) {
                            controller.forgotVerifyApi(context: context);
                          }
                        },
                      );
                    }).paddingAll(MySize.getScaledSizeHeight(16)),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
