import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/paidFeeDetails/views/paid_fee_details_view.dart';
import 'package:radianthyve_unified/app/modules/paymentReceipt/views/payment_receipt_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_drawer.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
      init: PaymentController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          backgroundColor: color.backgroundColor,
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
            leading: Padding(
              padding: EdgeInsets.only(left: MySize.getScaledSizeHeight(15)),
              child: GestureDetector(
                onTap: () {
                  controller.scaffoldKey.currentState?.openDrawer();
                },
                child: Image.asset(icons.drawerIcon, height: MySize.getScaledSizeHeight(30), width: MySize.getScaledSizeWidth(30)),
              ),
            ),
            title: commonText.medium(text: AppMessage.payment, fontSize: MySize.getScaledSizeHeight(18), textColor: color.white),
            centerTitle: false,
            // backgroundColor: color.appColor,
             backgroundColor: Colors.transparent,
          ),
          drawer: drawer(),
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
            child: Column(
              children: [

                 Obx(() {
                    return Expanded(
                      child: RefreshIndicator(
                        displacement: 30,
                        backgroundColor: color.white,
                        color: color.appColor,
                        strokeWidth: 3,
                        onRefresh: () async {
                          controller.page = 1;
                          controller.hasNextPage.value = true;
                          controller.listStudentsFeesAPI();
                        },
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                          child: Column(
                            children: [
                              !controller.isLoading.value
                                  ? controller.listStudentsFeesDataList.isEmpty
                                  ? buildNoDataWidget(height: Get.height / 1.4)
                                  : ListView.separated(
                                itemCount: controller.listStudentsFeesDataList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: color.white,
                                      borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(12), vertical: MySize.getScaledSizeHeight(15)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              commonText.medium(
                                                text: controller.listStudentsFeesDataList[index].fullName ?? '',
                                                fontSize: MySize.getScaledSizeHeight(16),
                                                textColor: color.black,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                  controller.listStudentsFeesDataList[index].requestStatus == 'accepted'
                                                      ? color.presentBackgroundColor
                                                      : color.waitingBackgroundColor,
                                                  borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(50))),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: MySize.getScaledSizeHeight(26),
                                                    vertical: MySize.getScaledSizeHeight(4),
                                                  ),
                                                  child: commonText.regular(
                                                    text: controller.listStudentsFeesDataList[index].requestStatus == 'accepted' ? 'Accepted' : 'Block',
                                                    fontSize: MySize.getScaledSizeHeight(14),
                                                    textColor:
                                                    controller.listStudentsFeesDataList[index].requestStatus == 'accepted'
                                                        ? color.textFieldFocusColor
                                                        : color.waitingColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        commonWidget.commonDivider(color: color.dividerColor),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(12), vertical: MySize.getScaledSizeHeight(14)),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  commonText.regular(
                                                    text: AppMessage.relation,
                                                    fontSize: MySize.getScaledSizeHeight(14),
                                                    textColor: color.textFieldTextColor,
                                                  ),
                                                  commonText.regular(
                                                    text: controller.listStudentsFeesDataList[index].relationToChild ?? '',
                                                    fontSize: MySize.getScaledSizeHeight(14),
                                                    textColor: color.black,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  commonText.regular(
                                                    text: 'Student Id',
                                                    fontSize: MySize.getScaledSizeHeight(14),
                                                    textColor: color.textFieldTextColor,
                                                  ),
                                                  commonText.regular(
                                                    text: '${controller.listStudentsFeesDataList[index].id ?? ''}',
                                                    fontSize: MySize.getScaledSizeHeight(14),
                                                    textColor: color.black,
                                                  ),
                                                ],
                                              ).paddingOnly(top: MySize.getScaledSizeHeight(16)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  commonText.regular(
                                                    text: 'Total Fee',
                                                    fontSize: MySize.getScaledSizeHeight(14),
                                                    textColor: color.textFieldTextColor,
                                                  ),
                                                  commonText.regular(
                                                    text: '\$${controller.listStudentsFeesDataList[index].shiftFee ?? 0}',
                                                    fontSize: MySize.getScaledSizeHeight(14),
                                                    textColor: color.black,
                                                  ),
                                                ],
                                              ).paddingOnly(top: MySize.getScaledSizeHeight(16)),
                                              20.0.hSpace(),
                                              commonWidget
                                                  .customButton(
                                                text: AppMessage.viewDetails,
                                                onTap: () {
                                                  // Get.to(() => PaymentReceiptView());
                                                  Get.to(() => PaidFeeDetailsView(),arguments: {
                                                    'studentId':controller.listStudentsFeesDataList[index].id ?? 0,
                                                  });
                                                },
                                              )
                                                  .paddingSymmetric(horizontal: MySize.getScaledSizeHeight(3)),
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
                                itemCount: 3,
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return diagonalShimmer(height: MySize.getScaledSizeHeight(246), width: Get.width, borderRadius: BorderRadius.circular(6));
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
                      ),
                    );
                  }),

                // controller.isLoading.value
                //     ? diagonalShimmer(
                //   height: MySize.getScaledSizeHeight(62),
                //   width: Get.width,
                //   borderRadius: BorderRadius.circular(8),
                // ) : GestureDetector(
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return Dialog(
                //           backgroundColor: Colors.white,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(20)),
                //           ),
                //           child: Container(
                //             padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
                //             child: Column(
                //               mainAxisSize: MainAxisSize.min,
                //               children: [
                //                 commonText.medium(
                //                   text: 'Parents Note',
                //                   fontSize: MySize.getScaledSizeHeight(18),
                //                   textColor: color.black,
                //                   textAlign: TextAlign.center,
                //                 ),
                //                 30.0.hSpace(),
                //                 ZoomIn(
                //                   duration: Duration(seconds: 3),
                //                   child: Image.asset(
                //                     images.parentsNoteImage,
                //                     height: MySize.getScaledSizeHeight(80),
                //                     width: MySize.getScaledSizeWidth(80),
                //                   ),
                //                 ),
                //                 30.0.hSpace(),
                //                 commonText.regular(
                //                   text: 'Your student’s fees have not been paid. Please note that this may require immediate attention to ensure continued access to school resources and activities. Contact the school’s teachers or principal promptly for fee.',
                //                   fontSize: MySize.getScaledSizeHeight(16),
                //                   textColor: color.textFieldTextColor,
                //                   textAlign: TextAlign.center,
                //                 ),
                //                 30.0.hSpace(),
                //                 commonWidget.customButton(
                //                   buttonColor: color.appColor,
                //                   text: 'Check Details',
                //                   onTap: () {
                //                     Get.back();
                //                     Get.to(() => PaymentReceiptView());
                //                   },
                //                 ),
                //                 16.0.hSpace(),
                //                 InkWell(
                //                   onTap: () {
                //                     Get.back();
                //                   },
                //                   child: Container(
                //                     height: MySize.getScaledSizeHeight(52),
                //                     width: Get.width,
                //                     decoration: BoxDecoration(
                //                       color: color.homeTextColor,
                //                       borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                //                     ),
                //                     child: Center(
                //                       child: commonText.medium(
                //                         text: 'Cancel',
                //                         textColor: color.cancelColor,
                //                         fontSize: MySize.getScaledSizeHeight(16),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: color.white,
                //       borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                //     ),
                //     child: Padding(
                //       padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                //       child: Row(
                //         children: [
                //           Container(
                //             decoration: BoxDecoration(
                //               color: Color(0xffFFF0E6),
                //               borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(50))),
                //               border: Border.all(color: Color(0xffFFD0B0)),
                //             ),
                //             child: Padding(
                //               padding: EdgeInsets.all(MySize.getScaledSizeHeight(8)),
                //               child: Image.asset(
                //                 icons.reminderIcons,
                //                 height: MySize.getScaledSizeHeight(18),
                //                 width: MySize.getScaledSizeWidth(18),
                //               ),
                //             ),
                //           ),
                //           12.0.wSpace(),
                //           commonText.medium(
                //             text: 'Fee Reminder Form School',
                //             fontSize: MySize.getScaledSizeHeight(14),
                //             textColor: color.black,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
