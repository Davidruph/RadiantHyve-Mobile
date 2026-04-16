import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';

import '../controllers/notification_details_controller.dart';

class NotificationDetailsView extends GetView<NotificationDetailsController> {
  const NotificationDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationDetailsController>(
      init: NotificationDetailsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(titleText: AppMessage.notifications,backgroundColor: color.transparentColor),
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText.medium(
                  text: 'Parents Note',
                  fontSize: MySize.getScaledSizeHeight(18),
                  textColor: color.black,
                ),
                16.0.hSpace(),
                commonText.regular(
                  text: 'Your student’s fees have not been paid. Please note that this may require immediate attention to ensure continued access to school resources and activities. Contact the school’s teachers or principal promptly for fee.',
                  fontSize: MySize.getScaledSizeHeight(16),
                  textColor: color.black,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
