import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:readmore/readmore.dart';

import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/parents_reminder_controller.dart';

class ParentsReminderView extends GetView<ParentsReminderController> {
  const ParentsReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      assignId: true,
      init: ParentsReminderController(),
      builder: (context) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: 'Parents Reminder',
            backgroundColor: color.transparentColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonText.regular(
                    text: 'Notification Title',
                    fontSize: MySize.getScaledSizeHeight(14),
                    textColor: color.textFieldTextColor,
                  ),
                  05.0.hSpace(),
                  commonText.medium(
                    text: controller.title ?? '',
                    fontSize: MySize.getScaledSizeHeight(16),
                    textColor: color.black,
                  ),
                  10.0.hSpace(),
                  commonText.regular(
                    text: 'Notification Body',
                    fontSize: MySize.getScaledSizeHeight(14),
                    textColor: color.textFieldTextColor,
                  ),
                  05.0.hSpace(),
                  ReadMoreText(
                    controller.body ??'',
                    trimLines: 3,
                    colorClickableText: Colors.blue,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Read more',
                    trimExpandedText: ' Read less',
                    style: TextStyle(
                      fontSize: MySize.getScaledSizeHeight(16),
                      color: color.black,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

