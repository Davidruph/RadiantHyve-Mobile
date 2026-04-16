import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/CachedImageContainer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/photoView.dart';
import '../../../../commonWidgets/popup.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../controllers/group_chat_controller.dart';
import '../model/GetLessonChatMessageModel.dart';

class GroupChatView extends GetView<GroupChatController> {
  const GroupChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatController>(
      init: GroupChatController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: WillPopScope(
            onWillPop: () => controller.onWillPop(),
            child: Scaffold(
              backgroundColor: color.backgroundColor,
              appBar: commonWidget.appBar(
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                leading: SizedBox(),
                toolbarHeight: 0.0,
                backgroundColor: color.backgroundColor,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(MySize.getScaledSizeWidth(16)),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            controller.onWillPop();
                          },
                          child: Image.asset(icons.backIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
                        ),
                        10.0.wSpace(),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(50))),
                          child: Image.asset(images.appIcon, height: MySize.getScaledSizeHeight(38), width: MySize.getScaledSizeHeight(38)),
                        ),
                        08.0.wSpace(),
                        commonText.medium(text: 'Radiant Hyve', textColor: color.black, fontSize: MySize.getScaledSizeHeight(16)),
                      ],
                    ),
                  ),
                  controller.isChatLoading.value ? SizedBox() : commonWidget.commonDivider(color: color.onboardingBorderColor),
                  Obx(() {
                    return controller.isSendMessageLoading.value
                        ? Container(
                          height: MySize.getScaledSizeHeight(3),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff2A9CFE), Color(0x402A9CFE)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: LinearProgressIndicator(
                            minHeight: MySize.getScaledSizeHeight(3),
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                        : const SizedBox();
                  }),
                  controller.isChatLoading.value
                      ? Expanded(child: SpinKitCircle(color: color.appColor, size: MySize.getScaledSizeHeight(40)))
                      : Expanded(
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          reverse: true,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(16)),
                            child: GroupedListView<dynamic, String>(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 10),
                              elements: controller.messageDataList,
                              groupBy: (element) {
                                return controller.formattedDate(element.createdAt);
                              },
                              groupComparator: (value1, value2) => value2.compareTo(value1),
                              sort: false,
                              reverse: true,
                              order: GroupedListOrder.DESC,
                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                              physics: const BouncingScrollPhysics(),
                              groupSeparatorBuilder: (String value) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Container(height: MySize.getScaledSizeHeight(1), color: color.onboardingBorderColor)),
                                    Center(
                                      child: commonText.medium(text: value, fontSize: MySize.getScaledSizeHeight(12), textColor: Color(0xff757D83)),
                                    ).paddingSymmetric(horizontal: 10),
                                    Expanded(child: Container(height: MySize.getScaledSizeHeight(1), color: color.onboardingBorderColor)),
                                  ],
                                ).paddingSymmetric(vertical: MySize.getScaledSizeHeight(18), horizontal: 8);
                              },
                              itemBuilder: (context, element) {
                                int index = controller.messageDataList.indexOf(element);
                                return controller.messageDataList[index].messageBy == box.read(PrefsKey.userId)
                                    ? chatSender(controller.messageDataList, index)
                                    : chatReceiver(controller.messageDataList, index);
                              },
                            ),
                          ),
                        ),
                      ),
                  10.0.hSpace(),
                  commonWidget.commonDivider(color: color.onboardingBorderColor),
                  Container(
                    color: color.white,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MySize.getScaledSizeWidth(08),
                        bottom: Platform.isIOS ? MySize.getScaledSizeHeight(30) : MySize.getScaledSizeHeight(16),
                        left: MySize.getScaledSizeWidth(16),
                        right: MySize.getScaledSizeWidth(16),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              profileBottomSheet(context: context);
                            },
                            child: Icon(Icons.add_outlined, size: MySize.getScaledSizeHeight(24)),
                          ),
                          06.0.wSpace(),
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(minHeight: MySize.getScaledSizeHeight(50), maxHeight: MySize.getScaledSizeHeight(120)),
                              child: TextField(
                                cursorColor: color.black,
                                maxLines: null,
                                minLines: 1,
                                onChanged: (value) {
                                  controller.update();
                                },
                                controller: controller.messageController,
                                decoration: InputDecoration(
                                  hintText: "Type...",
                                  hintStyle: TextStyle(
                                    fontSize: MySize.getScaledSizeHeight(14),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Regular',
                                    color: color.onboardingTextColor,
                                  ),
                                  fillColor: color.backgroundColor,
                                  filled: true,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          controller.messageController.text.trim().isEmpty
                              ? const SizedBox()
                              : Padding(
                                padding: const EdgeInsets.only(left: 11),
                                child: InkWell(
                                  onTap: () {
                                    if (controller.messageController.text.trim().isNotEmpty) {
                                      if (controller.messageController.text.isNotEmpty) {
                                        controller.sendMessageApi(type: "Text", message: controller.messageController.text.trim());
                                        controller.messageController.clear();
                                        controller.scrollController.animateTo(
                                          controller.scrollController.position.minScrollExtent,
                                          duration: const Duration(milliseconds: 800),
                                          curve: Curves.linear,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: MySize.getScaledSizeHeight(48),
                                    width: MySize.getScaledSizeHeight(48),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeWidth(8))),
                                      color: color.appColor,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        icons.sendIcon,
                                        height: MySize.getScaledSizeHeight(24),
                                        width: MySize.getScaledSizeWidth(24),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  profileBottomSheet({required context}) {
    return commonWidget.bottomSheet(
      child: Column(
        children: [
          16.0.hSpace(),
          InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              Get.back();
              controller.pickMedia(argument: 1);
            },
            child: Row(
              children: [
                Image.asset(icons.cameraIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
                10.0.wSpace(),
                commonText.medium(text: AppMessage.takeAPicture, textColor: color.black, fontSize: MySize.getScaledSizeHeight(14)),
              ],
            ),
          ),
          20.0.hSpace(),
          commonWidget.commonDivider(),
          20.0.hSpace(),
          InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              Get.back();
              controller.pickMedia(argument: 2);
            },
            child: Row(
              children: [
                Image.asset(icons.galleryIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24)),
                10.0.wSpace(),
                commonText.medium(text: AppMessage.selectFromGallery, textColor: color.black, fontSize: MySize.getScaledSizeHeight(14)),
              ],
            ),
          ),
          20.0.hSpace(),
          commonWidget.commonDivider(),
          20.0.hSpace(),
          InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              Get.back();
              controller.pickFiles();
            },
            child: Row(
              children: [
                Image.asset(icons.programIcon, height: MySize.getScaledSizeHeight(24), width: MySize.getScaledSizeWidth(24), color: color.black),
                10.0.wSpace(),
                commonText.medium(text: AppMessage.selectFromDocumentFile, textColor: color.black, fontSize: MySize.getScaledSizeHeight(14)),
              ],
            ),
          ),
          30.0.hSpace(),
        ],
      ).paddingSymmetric(horizontal: MySize.getScaledSizeWidth(16)),
    );
  }

  bool isSameMinute(DateTime t1, DateTime t2) {
    return t1.year == t2.year && t1.month == t2.month && t1.day == t2.day && t1.hour == t2.hour && t1.minute == t2.minute;
  }

  Widget chatReceiver(List<GetLessonChatMessageData> messageData1, int index) {
    GetLessonChatMessageData messageData = messageData1[index];
    final showTime =
        index == 0 ||
        (index > 0 && !isSameMinute(DateTime.parse(messageData1[index - 1].createdAt ?? ""), DateTime.parse(messageData.createdAt ?? "")));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            messageData.sendermessage?.role == 'school'
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: Image.asset(images.appIcon, height: MySize.getScaledSizeHeight(34), width: MySize.getScaledSizeHeight(34)),
                )
                : CachedImageContainer(
                  image: messageData.sendermessage?.profilePic ?? "",
                  height: MySize.getScaledSizeHeight(34),
                  width: MySize.getScaledSizeHeight(34),
                  bottomCorner: MySize.getScaledSizeWidth(34),
                  topCorner: MySize.getScaledSizeWidth(34),
                  fit: BoxFit.cover,
                  placeHolder: images.appIcon,
                ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText.medium(
                  text:
                      messageData.sendermessage?.role == 'school'
                          ? messageData.sendermessage?.schoolName ?? ""
                          : messageData.sendermessage?.fullName ?? "",
                  fontSize: MySize.getScaledSizeHeight(14),
                  textColor: color.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        if (messageData.messageType == "Image")
                          GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              Get.to(() => PhotoViewWidget(imgUrl: messageData.messageText, flag: "networkImage"));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                margin: EdgeInsets.only(top: MySize.getScaledSizeWidth(10)),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: color.notificationContainerColor),
                                padding: EdgeInsets.all(10),
                                child: CachedImageContainer(
                                  image: "${messageData.messageText}",
                                  height: MySize.getScaledSizeHeight(200),
                                  width: MySize.getScaledSizeHeight(200),
                                  fit: BoxFit.cover,
                                  placeHolder: images.appIcon,
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                            ),
                          )
                        else if (messageData.messageType == "Text")
                          Container(
                            margin: EdgeInsets.only(top: MySize.getScaledSizeWidth(10)),
                            constraints: BoxConstraints(maxWidth: Get.width / 1.4),
                            padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(20), vertical: MySize.getScaledSizeHeight(12)),
                            decoration: BoxDecoration(
                              color: color.notificationContainerColor,
                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(12))),
                            ),
                            child: commonText.regular(
                              text: messageData.messageText ?? "",
                              textColor: color.black,
                              fontSize: MySize.getScaledSizeHeight(14),
                            ),
                          )
                        else if (messageData.messageType == 'Document' && messageData.messageText != null)
                          Container(
                            margin: EdgeInsets.only(bottom: MySize.getScaledSizeWidth(6), top: MySize.getScaledSizeWidth(10)),
                            height: MySize.getScaledSizeWidth(56),
                            width: MySize.getScaledSizeWidth(247),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeWidth(10))),
                              border: Border.all(color: color.onboardingBorderColor),
                              color: color.notificationContainerColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(12), vertical: MySize.getScaledSizeWidth(16)),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child:
                                        messageData.messageText!.contains(".pdf") || messageData.messageText!.contains(".doc")
                                            ? Image.asset(
                                              icons.pdfViewIcon,
                                              height: MySize.getScaledSizeHeight(28),
                                              width: MySize.getScaledSizeWidth(28),
                                              fit: BoxFit.fill,
                                            )
                                            : CachedImageContainer(
                                              image: "${messageData.messageText}",
                                              height: MySize.getScaledSizeHeight(28),
                                              width: MySize.getScaledSizeHeight(28),
                                              fit: BoxFit.cover,
                                              placeHolder: images.appIcon,
                                            ),
                                  ),
                                  12.0.wSpace(),
                                  Expanded(
                                    child: commonText.regular(
                                      text: '${messageData.fileName ?? ''}',
                                      textColor: color.black,
                                      fontSize: MySize.getScaledSizeHeight(14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  12.0.wSpace(),
                                  GestureDetector(
                                    onTap: () {
                                      controller.downloadAttendanceSheet('${messageData.messageText}', messageData.fileName ?? '');
                                    },
                                    child: Icon(Icons.arrow_circle_down_outlined, size: MySize.getScaledSizeHeight(24), color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                if (showTime && messageData.createdAt != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: MySize.getScaledSizeHeight(5)),
                    child: commonText.medium(
                      text: DateFormat('hh:mm a').format(DateTime.parse(messageData.createdAt!).toLocal()),
                      fontSize: MySize.getScaledSizeHeight(12),
                      textColor: color.black,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget chatSender(List<GetLessonChatMessageData> messageData1, index) {
    GetLessonChatMessageData messageData = messageData1[index];
    final showTime =
        index == 0 || !isSameMinute(DateTime.parse(messageData1[index - 1].createdAt ?? ""), DateTime.parse(messageData.createdAt ?? ""));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Message Type Handling
          if (messageData.messageType == 'Text' && messageData.messageText != null)
            Container(
              constraints: BoxConstraints(maxWidth: MySize.getScaledSizeWidth(260)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: color.waitingBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(12))),
              ),
              child: commonText.regular(text: messageData.messageText ?? "", textColor: Color(0xff1F1F1F), fontSize: MySize.getScaledSizeHeight(14)),
            )
          else if (messageData.messageType == 'Image' && messageData.messageText != null)
            GestureDetector(
              onTap: () {
                Get.to(() => PhotoViewWidget(imgUrl: messageData.messageText, flag: "networkImage"));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: color.waitingBackgroundColor),
                  padding: EdgeInsets.all(10),
                  child: CachedImageContainer(
                    image: "${messageData.messageText}",
                    height: MySize.getScaledSizeHeight(200),
                    width: MySize.getScaledSizeHeight(200),
                    fit: BoxFit.cover,
                    placeHolder: images.appIcon,
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
            )
          else if (messageData.messageType == 'Document' && messageData.messageText != null)
            Container(
              margin: EdgeInsets.only(bottom: MySize.getScaledSizeWidth(6)),
              height: MySize.getScaledSizeWidth(56),
              width: MySize.getScaledSizeWidth(247),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeWidth(10))),
                color: color.waitingBackgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(12), vertical: MySize.getScaledSizeWidth(16)),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child:
                          messageData.messageText!.contains(".pdf") || messageData.messageText!.contains(".doc")
                              ? Image.asset(
                                icons.pdfViewIcon,
                                height: MySize.getScaledSizeHeight(28),
                                width: MySize.getScaledSizeWidth(28),
                                fit: BoxFit.fill,
                              )
                              : CachedImageContainer(
                                image: "${messageData.messageText}",
                                height: MySize.getScaledSizeHeight(28),
                                width: MySize.getScaledSizeHeight(28),
                                fit: BoxFit.cover,
                                placeHolder: images.appIcon,
                              ),
                    ),
                    12.0.wSpace(),
                    Expanded(
                      child: commonText.regular(
                        text: '${messageData.fileName ?? ''}',
                        textColor: color.black,
                        fontSize: MySize.getScaledSizeHeight(14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    12.0.wSpace(),
                    GestureDetector(
                      onTap: () {
                        controller.downloadAttendanceSheet('${messageData.messageText}', messageData.fileName ?? '');
                      },
                      child: Icon(Icons.arrow_circle_down_outlined, size: MySize.getScaledSizeHeight(24), color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          if (showTime)
            Padding(
              padding: EdgeInsets.only(bottom: MySize.getScaledSizeHeight(5)),
              child: commonText.regular(
                text: messageData.createdAt != null ? DateFormat('hh:mm a').format(DateTime.parse(messageData.createdAt!).toLocal()) : '',
                fontSize: MySize.getScaledSizeHeight(12),
                textColor: Color(0xff6C737F),
              ),
            ),
        ],
      ),
    );
  }
}
