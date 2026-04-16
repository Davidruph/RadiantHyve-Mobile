import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:radianthyve_unified/app/modules/addCertification/views/add_certification_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import '../controllers/certification_details_controller.dart';

class CertificationDetailsView extends GetView<CertificationDetailsController> {
  const CertificationDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CertificationDetailsController>(
      init: CertificationDetailsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: AppMessage.certificationDetails,
            backgroundColor: color.transparentColor,
            actions: [
              Button().paddingOnly(
                right: MySize.getScaledSizeHeight(12),
                top: MySize.getScaledSizeHeight(12),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText.regular(
                        text: AppMessage.staffName,
                        fontSize: MySize.getScaledSizeHeight(14),
                        textColor: color.textFieldTextColor,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: commonText.regular(
                            text: controller.certification!.staffName,
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  18.0.hSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText.regular(
                        text: AppMessage.institutionName,
                        fontSize: MySize.getScaledSizeHeight(14),
                        textColor: color.textFieldTextColor,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: commonText.regular(
                            text: controller.certification!.institutionName,
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  18.0.hSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText.regular(
                        text: AppMessage.hireCheckList,
                        fontSize: MySize.getScaledSizeHeight(14),
                        textColor: color.textFieldTextColor,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: commonText.regular(
                            text: controller.certification!.hireChecklist,
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Button extends StatelessWidget {
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 20,
      child: GestureDetector(
        child: Icon(Icons.more_vert_outlined),
        onTap: () {
          showPopover(
            context: context,
            bodyBuilder: (context) => const ListItems(),
            direction: PopoverDirection.bottom,
            backgroundColor: Colors.white,
            width: MySize.getScaledSizeWidth(247),
            height: MySize.getScaledSizeHeight(108),
          );
        },
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CertificationDetailsController>(
      assignId: false,
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              _commonRowImageWithText(
                image: icons.editIcon,
                text: AppMessage.edit,
                onTap: () {
                  Get.back();
                  Get.to(() => AddCertificationView(), arguments: {
                    'flag': 'editCertification',
                    'details': controller.certification,
                  })!
                      .then((value) {
                    if (value != null) {
                      controller.update();
                    }
                  });
                },
              ),
              14.0.hSpace(),
              commonWidget.commonDivider(color: color.divider2Color),
              14.0.hSpace(),
              _commonRowImageWithText(
                image: icons.deleteIcon,
                text: AppMessage.delete,
                onTap: () {
                  Get.back();
                  deleteCertificationDialog(context: context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _commonRowImageWithText({image, text, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            image,
            height: MySize.getScaledSizeHeight(24),
            width: MySize.getScaledSizeWidth(24),
          ),
          10.0.wSpace(),
          commonText.regular(
            textAlign: TextAlign.center,
            text: text ?? "",
            fontSize: MySize.getScaledSizeHeight(14),
            textColor: color.black,
          ),
        ],
      ),
    );
  }

  void deleteCertificationDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(20)),
          ),
          child: GetBuilder<CertificationDetailsController>(
            assignId: false,
            builder: (controller) {
              return Container(
                padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    commonText.medium(
                      text: AppMessage.deleteCertification,
                      fontSize: MySize.getScaledSizeHeight(18),
                      textColor: color.black,
                      textAlign: TextAlign.center,
                    ),
                    30.0.hSpace(),
                    ZoomIn(
                      duration: Duration(seconds: 3),
                      child: Image.asset(
                        images.deleteImage,
                        height: MySize.getScaledSizeHeight(80),
                        width: MySize.getScaledSizeWidth(80),
                      ),
                    ),
                    30.0.hSpace(),
                    commonText
                        .medium(
                          text: AppMessage.areYouSureYouWantToDeleteTheseCertification,
                          fontSize: MySize.getScaledSizeHeight(16),
                          textColor: color.black,
                          textAlign: TextAlign.center,
                        )
                        .paddingSymmetric(horizontal: MySize.getScaledSizeHeight(14)),
                    30.0.hSpace(),
                    Obx(() {
                      return commonWidget.customButton(
                        buttonColor: color.textFieldErrorColor,
                        text: AppMessage.yesDelete,
                        isLoading: controller.isDeleteLoader.value,
                        onTap: () {
                          controller.deleteCertificationApi();
                        },
                      );
                    }),
                    16.0.hSpace(),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: MySize.getScaledSizeHeight(52),
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: color.homeTextColor,
                          borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                        ),
                        child: Center(
                          child: commonText.medium(
                            text: AppMessage.cancel,
                            textColor: color.cancelColor,
                            fontSize: MySize.getScaledSizeHeight(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
