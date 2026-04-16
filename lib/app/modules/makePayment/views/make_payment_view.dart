import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../controllers/make_payment_controller.dart';

class MakePaymentView extends GetView<MakePaymentController> {
  const MakePaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MakePaymentController>(
      init: MakePaymentController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            leading: SizedBox(),
            toolbarHeight: 0.0,
            backgroundColor: color.appColor,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: MySize.getScaledSizeHeight(200),
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: color.appColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(right: MySize.getScaledSizeWidth(16), left: MySize.getScaledSizeWidth(16), top: MySize.getScaledSizeWidth(18)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                splashColor: color.transparentColor,
                                highlightColor: color.transparentColor,
                                onTap: () {
                                  Get.back();
                                },
                                child: Image.asset(
                                  icons.backIcon,
                                  height: MySize.getScaledSizeHeight(24),
                                  width: MySize.getScaledSizeWidth(24),
                                  color: color.white,
                                ),
                              ),
                              Spacer(),
                              commonText.medium(
                                text: AppMessage.payment,
                                fontSize: MySize.getScaledSizeHeight(18),
                                textColor: color.white,
                              ),
                              16.0.wSpace(),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -80,
                    right: 16,
                    left: 16,
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: color.white,
                        borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeWidth(8))),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(MySize.getScaledSizeWidth(15)),
                            child: Row(
                              children: [
                                controller.isLoading.value
                                    ? diagonalShimmer(
                                  height: MySize.getScaledSizeHeight(74),
                                  width: MySize.getScaledSizeWidth(74),
                                  borderRadius: BorderRadius.circular(50),
                                ) : Image.asset(
                                  images.profileImage3,
                                  height: MySize.getScaledSizeHeight(74),
                                  width: MySize.getScaledSizeWidth(74),
                                ),
                                12.0.wSpace(),
                                controller.isLoading.value
                                    ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    diagonalShimmer(
                                      height: MySize.getScaledSizeHeight(20),
                                      width: MySize.getScaledSizeWidth(132),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    10.0.hSpace(),
                                    diagonalShimmer(
                                      height: MySize.getScaledSizeHeight(16),
                                      width: MySize.getScaledSizeWidth(115),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ) : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commonText.medium(
                                      text: 'Ronald Richards',
                                      fontSize: MySize.getScaledSizeHeight(16),
                                      textColor: color.black,
                                    ),
                                    10.0.hSpace(),
                                    Row(
                                      children: [
                                        commonText.regular(
                                          text: "${AppMessage.studentId}: ",
                                          fontSize: MySize.getScaledSizeHeight(12),
                                          textColor: color.textFieldTextColor,
                                        ),
                                        commonText.regular(
                                          text: '396350',
                                          fontSize: MySize.getScaledSizeHeight(12),
                                          textColor: color.black,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          commonWidget.commonDivider(color: color.onboardingBorderColor),
                          Padding(
                            padding: EdgeInsets.all(MySize.getScaledSizeWidth(15)),
                            child: controller.isLoading.value
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                diagonalShimmer(
                                  height: MySize.getScaledSizeHeight(18),
                                  width: MySize.getScaledSizeWidth(103),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                diagonalShimmer(
                                  height: MySize.getScaledSizeHeight(18),
                                  width: MySize.getScaledSizeWidth(56),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ) : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                commonText.medium(
                                  text: AppMessage.totalPayments,
                                  fontSize: MySize.getScaledSizeHeight(14),
                                  textColor: color.black,
                                ),
                                commonText.medium(
                                  text: '\$199.00',
                                  fontSize: MySize.getScaledSizeHeight(14),
                                  textColor: color.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              84.0.hSpace(),
              Padding(
                padding: EdgeInsets.all(MySize.getScaledSizeWidth(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonText.medium(
                      text: 'Payment Method',
                      fontSize: MySize.getScaledSizeHeight(16),
                      textColor: color.black,
                    ),
                    15.0.hSpace(),
                    controller.isLoading.value
                        ? ListView.separated(
                      itemCount: controller.paymentList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return diagonalShimmer(
                          height: MySize.getScaledSizeHeight(62),
                          width: Get.width,
                          borderRadius: BorderRadius.circular(8),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return 16.0.hSpace();
                      },
                    ) : ListView.separated(
                      itemCount: controller.paymentList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            controller.selectedIndex.value = index;
                            controller.update();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: color.white,
                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeWidth(8))),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(MySize.getScaledSizeWidth(12)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    controller.paymentList[index]['icon'],
                                    height: MySize.getScaledSizeHeight(38),
                                    width: MySize.getScaledSizeWidth(38),
                                  ),
                                  10.0.wSpace(),
                                  commonText.medium(
                                    text: controller.paymentList[index]['name'],
                                    fontSize: MySize.getScaledSizeHeight(14),
                                    textColor: color.black,
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    controller.selectedIndex.value == index ? icons.circleCheck : icons.circleUnCheck,
                                    height: MySize.getScaledSizeHeight(24),
                                    width: MySize.getScaledSizeWidth(24),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return 16.0.hSpace();
                      },
                    ),
                    Obx(
                          () => controller.selectedIndex == -1
                          ? commonText
                          .medium(
                        text: controller.errorPaymentMethod.value,
                        fontSize: MySize.getScaledSizeHeight(10),
                        textColor: color.textFieldErrorColor,
                        textAlign: TextAlign.center,
                      )
                          .paddingOnly(
                        top: MySize.getScaledSizeHeight(4),
                        right: MySize.getScaledSizeHeight(16),
                        left: MySize.getScaledSizeHeight(16),
                      ) : SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: commonWidget
              .customButton(
            text: 'Proceed to Pay',
            onTap: () {
              if(controller.isValidation()){
                Get.back(result: true);
                controller.update();
              }
            },
          )
              .paddingAll(MySize.getScaledSizeHeight(16)),
        );
      },
    );
  }
}
