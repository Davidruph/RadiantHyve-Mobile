import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nb_utils/nb_utils.dart' as appColor;
import 'package:radianthyve_unified/app/modules/classroomData/views/classroom_data_view.dart';
import 'package:radianthyve_unified/app/modules/myLeave/views/my_leave_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/notifications_controller.dart';
import '../model/ListNotificationModel.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      init: NotificationsController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
            titleText: AppMessage.notifications,
            backgroundColor: color.transparentColor,
          ),
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
            child: Column(
              children: [
                !controller.isLoading.value
                    ? controller.listNotification.isEmpty && controller.isLoading.value == true
                        ? buildNoDataWidget(height: Get.height / 1.5)
                        : controller.listNotification.isEmpty
                        ? RefreshIndicator(
                          displacement: 30,
                          backgroundColor: appColor.white,
                          color: Color(0xff293FE3),
                          strokeWidth: 3,
                          onRefresh: () async {
                            controller.page = 1;
                            await controller.listNotificationApi();
                            controller.update();
                          },
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: buildNoDataWidget(height: Get.height / 1.5),
                          ),
                        )
                        : Expanded(
                          child: RefreshIndicator(
                            displacement: 30,
                            backgroundColor: appColor.white,
                            color: Color(0xff293FE3),
                            strokeWidth: 3,
                            onRefresh: () async {
                              controller.page = 1;
                              await controller.listNotificationApi();
                              controller.update();
                            },
                            child: GroupedListView<ListNotificationData, String>(
                              controller: controller.scrollController,
                              physics: AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              elements: controller.sortNotifications(controller.listNotification),
                              order: GroupedListOrder.DESC,
                              sort: false,
                              padding: EdgeInsets.zero,
                              groupBy:
                                  (ListNotificationData notification) =>
                                      controller.formatToRelativeDate(
                                        DateTime.parse(notification.createdAt ?? ""),
                                      ),
                              groupSeparatorBuilder:
                                  (String groupByValue) => Row(
                                    children: [
                                      commonText
                                          .medium(
                                            text: groupByValue,
                                            textColor: appColor.black,
                                            fontSize: MySize.getScaledSizeHeight(16),
                                          )
                                          .paddingOnly(bottom: MySize.getScaledSizeHeight(10)),
                                    ],
                                  ).paddingOnly(bottom: MySize.getScaledSizeHeight(6)),
                              itemBuilder: (
                                BuildContext context,
                                ListNotificationData notification,
                              ) {
                                final DateTime createdAt =
                                    DateTime.parse(notification.createdAt ?? '').toLocal();
                                final String timeAgo = timeago.format(createdAt);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (notification.notificationType == 'leave_status') {
                                          Get.offAll(() => MyLeaveView());
                                        } else if (notification.notificationType ==
                                            'student_assign_teacher') {
                                          Get.offAll(() => ClassroomDataView());
                                        }
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              icons.notificationIcon2,
                                              height: MySize.getScaledSizeHeight(30),
                                              width: MySize.getScaledSizeWidth(30),
                                            ),
                                            10.0.wSpace(),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  notification.body == ""
                                                      ? SizedBox()
                                                      : commonText.medium(
                                                        text:
                                                            '${controller.convertUtcToLocal(notification.createdAt.toString()) ?? ''} ${notification.body ?? ''}',
                                                        fontSize: MySize.getScaledSizeHeight(12),
                                                        maxLines: 2,
                                                        textColor: appColor.black,
                                                      ),
                                                  08.0.hSpace(),
                                                  commonText.regular(
                                                    text: controller.getTimeDifference(
                                                      notification.createdAt ?? "",
                                                    ),
                                                    fontSize: MySize.getScaledSizeHeight(12),
                                                    textColor: const Color(0xff7B7B7B),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    20.0.hSpace(),
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                    : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: MySize.getScaledSizeHeight(15)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                diagonalShimmer(
                                  height: MySize.getScaledSizeHeight(42),
                                  width: MySize.getScaledSizeHeight(42),
                                  borderRadius: BorderRadius.circular(42),
                                ),
                                10.0.wSpace(),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      diagonalShimmer(
                                        height: MySize.getScaledSizeHeight(17),
                                        width: Get.width,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      05.0.hSpace(),
                                      diagonalShimmer(
                                        height: MySize.getScaledSizeHeight(17),
                                        width: Get.width,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      05.0.hSpace(),
                                      diagonalShimmer(
                                        height: MySize.getScaledSizeHeight(17),
                                        width: MySize.getScaledSizeHeight(51),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                Obx(() {
                  return controller.isLoadMoreRunning.value == true ? CommonLoader() : Container();
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
