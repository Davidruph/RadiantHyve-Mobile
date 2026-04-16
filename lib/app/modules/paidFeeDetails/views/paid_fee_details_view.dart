import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/paymentReceipt/views/payment_receipt_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../controllers/paid_fee_details_controller.dart';

class PaidFeeDetailsView extends GetView<PaidFeeDetailsController> {
  const PaidFeeDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaidFeeDetailsController>(
      init: PaidFeeDetailsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
              titleText: 'Fees Details',
              backgroundColor: color.transparentColor,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.black),
              ),
            ),
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeWidth(16)),
            child: Obx(() {
              return RefreshIndicator(
                displacement: 30,
                backgroundColor: color.white,
                color: color.appColor,
                strokeWidth: 3,
                onRefresh: () async {
                  controller.page = 1;
                  controller.hasNextPage.value = true;
                  controller.listStudentsInvoiceAPI();
                },
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                  child: Column(
                    children: [
                      !controller.isLoading.value
                          ? controller.listStudentsInvoiceDataList.isEmpty
                          ? buildNoDataWidget(height: Get.height / 1.4)
                          : ListView.separated(
                        itemCount: controller.listStudentsInvoiceDataList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: color.white,
                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeWidth(8))),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(12), vertical: MySize.getScaledSizeHeight(15)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      commonText.medium(text: 'Paid', fontSize: MySize.getScaledSizeHeight(16), textColor: color.textFieldFocusColor),
                                      commonText.regular(
                                        text: '\$${controller.listStudentsInvoiceDataList[index].totalFees ?? ''}',
                                        fontSize: MySize.getScaledSizeHeight(14),
                                        textColor: color.black,
                                      ),
                                    ],
                                  ),
                                ),
                                commonWidget.commonDivider(color: color.dividerColor),
                                Padding(
                                  padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          commonText.regular(
                                            text: 'Transaction Id',
                                            fontSize: MySize.getScaledSizeHeight(14),
                                            textColor: color.textFieldTextColor,
                                          ),
                                          commonText.regular(
                                            text: '${controller.listStudentsInvoiceDataList[index].id ?? 0}',
                                            fontSize: MySize.getScaledSizeHeight(14),
                                            textColor: color.black,
                                          ),
                                        ],
                                      ),
                                      16.0.hSpace(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          commonText.regular(
                                            text: 'Date',
                                            fontSize: MySize.getScaledSizeHeight(14),
                                            textColor: color.textFieldTextColor,
                                          ),
                                          commonText.regular(
                                            text: controller.formatDate(controller.listStudentsInvoiceDataList[index].createdAt),
                                            fontSize: MySize.getScaledSizeHeight(14),
                                            textColor: color.black,
                                          ),
                                        ],
                                      ),
                                      20.0.hSpace(),
                                      commonWidget.customButton(
                                        text: 'View Details',
                                        onTap: () {
                                          Get.to(() => PaymentReceiptView(),arguments: {
                                            "listStudentsInvoiceData":controller.listStudentsInvoiceDataList[index]
                                          });
                                        },
                                      ),
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
                      )
                          : ListView.separated(
                        itemCount: controller.paidFeesDetailList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return diagonalShimmer(height: MySize.getScaledSizeHeight(205), width: Get.width, borderRadius: BorderRadius.circular(8));
                        },
                        separatorBuilder: (context, index) {
                          return 16.0.hSpace();
                        },
                      ),
                      Obx(() {
                        return controller.isLoadMoreRunning.value == true ? Center(child: CommonLoader()) : Container();
                      }),
                    ],
                  ),
                ),
              );
            })
          ),
        );
      },
    );
  }
}
