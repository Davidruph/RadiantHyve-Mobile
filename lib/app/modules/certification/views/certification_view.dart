import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/addCertification/views/add_certification_view.dart';
import 'package:radianthyve_unified/app/modules/certificationDetails/views/certification_details_view.dart';
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
import '../../../../commonWidgets/NoData.dart';
import '../controllers/certification_controller.dart';

class CertificationView extends GetView<CertificationController> {
  const CertificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CertificationController>(
      init: CertificationController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            leading: Padding(
              padding: EdgeInsets.only(left: MySize.getScaledSizeHeight(15)),
              child: GestureDetector(
                onTap: () {
                  controller.scaffoldKey.currentState?.openDrawer();
                },
                child: Image.asset(
                  icons.drawerIcon,
                  height: MySize.getScaledSizeHeight(30),
                  width: MySize.getScaledSizeWidth(30),
                ),
              ),
            ),
            title: commonText.medium(
              text: AppMessage.certification,
              fontSize: MySize.getScaledSizeHeight(18),
              textColor: color.white,
            ),
            centerTitle: false,
            backgroundColor: color.appColor,
          ),
          drawer: drawer(),
          floatingActionButton: InkWell(
            onTap: () {
              Get.to(() => AddCertificationView())!.then((value) {
                if (value == 1) {
                  controller.listCertification();
                }
              });
            },
            child: Container(
              height: MySize.getScaledSizeHeight(50),
              width: MySize.getScaledSizeWidth(50),
              decoration: BoxDecoration(shape: BoxShape.circle, color: color.buttonColor),
              child: Icon(Icons.add_outlined, size: MySize.getScaledSizeHeight(30), color: color.white),
            ).paddingOnly(bottom: MySize.getScaledSizeHeight(28)),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return Padding(
                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                    child: controller.isLoading.value
                        ? ListView.separated(
                            itemCount: 5,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return diagonalShimmer(
                                height: MySize.getScaledSizeHeight(205),
                                width: Get.width,
                                borderRadius: BorderRadius.circular(8),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return 16.0.hSpace();
                            },
                          )
                        : controller.certificationList.isEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  controller.listCertification();
                                },
                                backgroundColor: color.white,
                                color: color.appColor,
                                child: SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                                  child: NoData(height: Get.height / 1.4, width: Get.width),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () async {
                                  controller.listCertification();
                                },
                                backgroundColor: color.white,
                                color: color.appColor,
                                child: ListView.separated(
                                  controller: controller.scrollController,
                                  itemCount: controller.certificationList.length,
                                  shrinkWrap: true,
                                  physics: AlwaysScrollableScrollPhysics(),
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
                                            padding: EdgeInsets.symmetric(
                                              horizontal: MySize.getScaledSizeHeight(12),
                                              vertical: MySize.getScaledSizeHeight(15),
                                            ),
                                            child: commonText.medium(
                                              text: controller.certificationList[index].staffName,
                                              fontSize: MySize.getScaledSizeHeight(16),
                                              textColor: color.black,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          commonWidget.commonDivider(color: color.dividerColor),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: MySize.getScaledSizeHeight(12),
                                              vertical: MySize.getScaledSizeHeight(14),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    commonText.regular(
                                                      text: AppMessage.institutionName,
                                                      fontSize: MySize.getScaledSizeHeight(14),
                                                      textColor: color.textFieldTextColor,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: commonText.regular(
                                                          text: controller.certificationList[index].institutionName,
                                                          fontSize: MySize.getScaledSizeHeight(14),
                                                          textColor: color.black,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                16.0.hSpace(),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    commonText.regular(
                                                      text: AppMessage.hireList,
                                                      fontSize: MySize.getScaledSizeHeight(14),
                                                      textColor: color.textFieldTextColor,
                                                    ),
                                                    commonText.regular(
                                                      text: controller.certificationList[index].hireChecklist,
                                                      fontSize: MySize.getScaledSizeHeight(14),
                                                      textColor: color.black,
                                                    ),
                                                  ],
                                                ),
                                                20.0.hSpace(),
                                                commonWidget
                                                    .customButton(
                                                      text: AppMessage.viewDetails,
                                                      onTap: () {
                                                        Get.to(() => CertificationDetailsView(), arguments: {
                                                          "details": controller.certificationList[index],
                                                        })!
                                                            .then((value) {
                                                          if (value != null) {
                                                            controller.listCertification();
                                                          }
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
                                ),
                              ),
                  );
                }),
              ),
              Obx(() {
                return controller.isLoadMoreRunning.value == true ? Center(child: CommonLoader()) : SizedBox(height: 0);
              }),
            ],
          ),
        );
      },
    );
  }
}
