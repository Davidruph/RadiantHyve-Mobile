import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../addMedication/views/add_medication_view.dart';
import '../controllers/medication_information_controller.dart';

class MedicationInformationView extends GetView<MedicationInformationController> {
  const MedicationInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MedicationInformationController>(
      init: MedicationInformationController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: AppMessage.medicationInformation,
            backgroundColor: color.transparentColor,
            actions: [Button().paddingOnly(right: MySize.getScaledSizeHeight(12), top: MySize.getScaledSizeHeight(12))],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText.regular(text: AppMessage.studentName, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                      commonText.regular(text: controller.listMedicationStudentData?.studentName ?? '', fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                    ],
                  ),
                  18.0.hSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText.regular(text: AppMessage.typeOfDisease, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                      commonText.regular(text: controller.listMedicationStudentData?.typeDisease ?? '', fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                    ],
                  ),
                  18.0.hSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText.regular(text: AppMessage.medicationDetails, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                      commonText.regular(text: controller.listMedicationStudentData?.medicationDetails ?? '', fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                    ],
                  ),
                  18.0.hSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText.regular(text: AppMessage.doctorsName, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                      commonText.regular(text: controller.listMedicationStudentData?.doctorName ?? '', fontSize: MySize.getScaledSizeHeight(16), textColor: color.black),
                    ],
                  ),
                  18.0.hSpace(),
                  controller.isLoading.value
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          diagonalShimmer(height: MySize.getScaledSizeHeight(16), width: MySize.getScaledSizeWidth(164), borderRadius: BorderRadius.circular(4)),
                          diagonalShimmer(height: MySize.getScaledSizeHeight(18), width: MySize.getScaledSizeWidth(124), borderRadius: BorderRadius.circular(4)),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText.regular(text: AppMessage.doctorsPhoneNumber, fontSize: MySize.getScaledSizeHeight(14), textColor: color.textFieldTextColor),
                          commonText.regular(
                            text: '${controller.listMedicationStudentData?.countryCode ?? ''} ${controller.listMedicationStudentData?.mobileNo ?? ''}',
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.black,
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
            onPop: () => print('Popover was popped!'),
            direction: PopoverDirection.bottom,
            backgroundColor: Colors.white,
            width: MySize.getScaledSizeWidth(247),
            height: MySize.getScaledSizeHeight(108),
            // arrowHeight: 16,
            // arrowWidth: 28,
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
    MedicationInformationController controller = Get.put(MedicationInformationController());
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
              Get.to(() => AddMedicationView(), arguments: {'flag': 'editMedication', 'medicationData': controller.listMedicationStudentData});
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
              deleteMedicationDialog(context: context);
            },
          ),
        ],
      ),
    );
  }

  Widget _commonRowImageWithText({image, text, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(image, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
          10.0.wSpace(),
          commonText.regular(textAlign: TextAlign.center, text: text ?? "", fontSize: MySize.getScaledSizeHeight(14), textColor: color.black),
        ],
      ),
    );
  }

  void deleteMedicationDialog({required BuildContext context}) {
    MedicationInformationController controller = Get.put(MedicationInformationController());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(20))),
          child: Container(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                commonText.medium(text: AppMessage.deleteMedication, fontSize: MySize.getScaledSizeHeight(18), textColor: color.black, textAlign: TextAlign.center),
                30.0.hSpace(),
                ZoomIn(duration: Duration(seconds: 3), child: Image.asset(images.deleteImage, height: MySize.getScaledSizeHeight(80), width: MySize.getScaledSizeWidth(80))),
                30.0.hSpace(),
                commonText
                    .medium(text: AppMessage.areYouSureYouWantToDeleteTheseMedications, fontSize: MySize.getScaledSizeHeight(16), textColor: color.black, textAlign: TextAlign.center)
                    .paddingSymmetric(horizontal: MySize.getScaledSizeHeight(14)),
                30.0.hSpace(),
                Obx(() {
                  return commonWidget.customButton(
                    isLoading: controller.isLoading.value,
                    buttonColor: color.textFieldErrorColor,
                    text: AppMessage.yesDelete,
                    onTap: () {
                      controller.deleteMedificationApi();
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
                    decoration: BoxDecoration(color: color.homeTextColor, borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8)))),
                    child: Center(child: commonText.medium(text: AppMessage.cancel, textColor: color.cancelColor, fontSize: MySize.getScaledSizeHeight(16))),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
