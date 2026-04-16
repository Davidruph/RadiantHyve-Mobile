import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import '../controllers/add_shift_information_controller.dart';

class AddShiftInformationView extends GetView<AddShiftInformationController> {
  const AddShiftInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddShiftInformationController>(
      init: AddShiftInformationController(),
      assignId: true,
      builder: (logic) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: color.white,
            appBar: commonWidget.appBar(
              titleText: AppMessage.shiftInformation,
              backgroundColor: color.transparentColor,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.black),
              ),
            ),
            body: Obx(() {
              return IgnorePointer(
                ignoring: controller.isLoading.value,
                child: Padding(
                  padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                  child: Column(
                    children: [
                      Obx(() {
                        return commonWidget.commonTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                            FilteringTextInputFormatter.deny(
                              RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                            ),
                          ],
                          keyboardType: TextInputType.text,
                          controller: controller.shiftNameController,
                          labelText: AppMessage.shiftName,
                          hintText: AppMessage.shiftName,
                          errorText: controller.errorShiftName.value,
                          onTap: () {
                            controller.isSelect.value = 0;
                          },
                          onChanged: (value) {
                            controller.isSelect.value = 0;
                            controller.errorShiftName.value = "";
                          },
                          isbordervisibal: controller.isSelect.value == 0 ? true : false,
                        );
                      }),
                      18.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                          keyboardType: TextInputType.number,
                          controller: controller.shiftFeeController,
                          labelText: AppMessage.shiftFee,
                          hintText: AppMessage.enterFee,
                          maxLength: 7,
                          prefixIcon: commonText
                              .medium(
                                text: '\$',
                                textColor: color.textFieldTextColor,
                                fontSize: MySize.getScaledSizeHeight(14),
                              )
                              .paddingOnly(left: MySize.getScaledSizeHeight(15), top: MySize.getScaledSizeHeight(14)),
                          contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(13)),
                          errorText: controller.errorShiftFee.value,
                          onTap: () {
                            controller.isSelect.value = 1;
                          },
                          onChanged: (value) {
                            controller.isSelect.value = 1;
                            controller.errorShiftFee.value = "";
                          },
                          isbordervisibal: controller.isSelect.value == 1 ? true : false,
                        );
                      }),
                      18.0.hSpace(),
                      Obx(() {
                        return commonWidget.commonTextField(
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                          keyboardType: TextInputType.number,
                          controller: controller.lateFeeController,
                          labelText: 'Late Fee',
                          hintText: AppMessage.enterFee,
                          maxLength: 7,
                          prefixIcon: commonText
                              .medium(
                            text: '\$',
                            textColor: color.textFieldTextColor,
                            fontSize: MySize.getScaledSizeHeight(14),
                          )
                              .paddingOnly(left: MySize.getScaledSizeHeight(15), top: MySize.getScaledSizeHeight(14)),
                          contentPadding: EdgeInsets.only(top: MySize.getScaledSizeHeight(13)),
                          errorText: controller.errorLateFee.value,
                          onTap: () {
                            controller.isSelect.value = 2;
                          },
                          onChanged: (value) {
                            controller.isSelect.value = 2;
                            controller.errorLateFee.value = "";
                          },
                          isbordervisibal: controller.isSelect.value == 2 ? true : false,
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),
            bottomNavigationBar: Obx(() {
              return commonWidget.customButton(
                text: AppMessage.save,
                isLoading: controller.isLoading.value,
                onTap: () {
                  if (controller.isValidation()) {
                    if (controller.isLoading.value != true) {
                      if (controller.flag == 'editShift') {
                        controller.EditShiftApi();
                      } else {
                        controller.AddShiftApi();
                      }
                    }
                  }
                },
              );
            }).paddingAll(MySize.getScaledSizeHeight(16)),
          ),
        );
      },
    );
  }
}
