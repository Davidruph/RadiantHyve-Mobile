import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:radianthyve_unified/app/modules/makePayment/views/make_payment_view.dart';
import 'package:radianthyve_unified/app/modules/paidFeeDetails/views/paid_fee_details_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../utils/common.dart';
import '../controllers/payment_receipt_controller.dart';

class PaymentReceiptView extends GetView<PaymentReceiptController> {
  const PaymentReceiptView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentReceiptController>(
      init: PaymentReceiptController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.white,
          appBar: commonWidget.appBar(
              titleText: AppMessage.paymentReceipt,
              backgroundColor: color.transparentColor,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.black),
              ),
            ),
          body: SingleChildScrollView(
            child: Screenshot(
              controller: controller.screenController,
              child: Padding(
                padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText.regular(
                          text: AppMessage.studentName,
                          fontSize: MySize.getScaledSizeHeight(14),
                          textColor: color.textFieldTextColor,
                        ),
                        commonText.regular(
                          text: controller.listStudentsInvoiceData?.studentName ?? '',
                          fontSize: MySize.getScaledSizeHeight(16),
                          textColor: color.black,
                        ),
                      ],
                    ),
                    16.0.hSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText.regular(text: AppMessage.studentId, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                        commonText.regular(
                          text: '${controller.listStudentsInvoiceData?.id ?? ''}',
                          fontSize: MySize.getScaledSizeHeight(16),
                          textColor: color.black,
                        ),
                      ],
                    ),
                    20.0.hSpace(),
                    commonWidget.commonDivider(color: color.onboardingBorderColor),
                    12.0.hSpace(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText.medium(text: 'Fees Details', fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                        commonText.medium(
                          text:
                          '${controller.getMonthString(controller.listStudentsInvoiceData?.month ?? '')} , ${controller.listStudentsInvoiceData
                              ?.year ?? 0}',
                          fontSize: MySize.getScaledSizeHeight(16),
                          textColor: color.black,
                        ),
                      ],
                    ),
                    12.0.hSpace(),
                    commonWidget.commonDivider(color: color.onboardingBorderColor),
                    15.0.hSpace(),
                    controller.isLoading.value
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        diagonalShimmer(
                          height: MySize.getScaledSizeHeight(18),
                          width: MySize.getScaledSizeWidth(65),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        diagonalShimmer(
                          height: MySize.getScaledSizeHeight(20),
                          width: MySize.getScaledSizeWidth(65),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText.regular(
                          text: 'Shift Fee',
                          fontSize: MySize.getScaledSizeHeight(14),
                          textColor: color.textFieldTextColor,
                        ),
                        commonText.regular(
                          text: '\$${controller.listStudentsInvoiceData?.shiftFee ?? '0'}',
                          fontSize: MySize.getScaledSizeHeight(16),
                          textColor: color.black,
                        ),
                      ],
                    ),
                    15.0.hSpace(),
                    controller.isLoading.value
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        diagonalShimmer(
                          height: MySize.getScaledSizeHeight(18),
                          width: MySize.getScaledSizeWidth(65),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        diagonalShimmer(
                          height: MySize.getScaledSizeHeight(20),
                          width: MySize.getScaledSizeWidth(65),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText.regular(
                          text: 'Late Fee',
                          fontSize: MySize.getScaledSizeHeight(14),
                          textColor: color.textFieldTextColor,
                        ),
                        commonText.regular(
                          text: '\$${controller.listStudentsInvoiceData?.penaltyFees ?? '0'}',
                          fontSize: MySize.getScaledSizeHeight(16),
                          textColor: color.black,
                        ),
                      ],
                    ),
                    20.0.hSpace(),
                    commonWidget.commonDivider(color: color.onboardingBorderColor),
                    12.0.hSpace(),
                    commonText.medium(text: AppMessage.paymentDetails, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                    12.0.hSpace(),
                    commonWidget.commonDivider(color: color.onboardingBorderColor),
                    15.0.hSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText.regular(text: 'Payment Date ', fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                        commonText.regular(
                          text: controller.convertDateFormat(controller.listStudentsInvoiceData?.createdAt),
                          fontSize: MySize.getScaledSizeHeight(16),
                          textColor: color.black,
                        ),
                      ],
                    ),
                    16.0.hSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText.regular(text: AppMessage.totalPayments, fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
                        commonText.regular(
                          text: '\$${controller.listStudentsInvoiceData?.totalFees ?? ''}',
                          fontSize: MySize.getScaledSizeHeight(16),
                          textColor: color.textFieldFocusColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Obx(() =>
              commonWidget
                  .customButton(
                isLoading: controller.isPdfContentLoading.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(icons.downloadIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
                    10.0.wSpace(),
                    commonText.medium(text: 'Download Receipt', fontSize: MySize.getScaledSizeHeight(16), textColor: color.white),
                  ],
                ),
                onTap: () {
                  controller.convertToPdf(
                      imagePath:
                      "invoice_${controller.listStudentsInvoiceData?.id ?? 0}_${controller.listStudentsInvoiceData?.studentName ?? 'Unknown'}.pdf");
                },
              )
                  .paddingAll(MySize.getScaledSizeHeight(16)),).paddingOnly(bottom: Platform.isIOS?10:0 ),
        );
      },
    );
  }
}
