
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../commonWidgets/CachedImageContainer.dart';
import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_drawer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/enums.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../chat/views/chat_view.dart';
import '../../chatList/views/chat_list_view.dart';
import '../controllers/message_controller.dart';
import '../model/MessageListModel.dart';

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageController>(
      init: MessageController(),
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
            title: commonText.medium(text: AppMessage.message, fontSize: MySize.getScaledSizeHeight(18), textColor: color.white),
            actions: [
              InkWell(
                onTap: () {
                  controller.createLessonChatApi();
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(14))),
                        color: color.viewStudentsColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(10), vertical: MySize.getScaledSizeHeight(6)),
                        child: Row(
                          children: [
                            Image.asset(
                              icons.Class,
                              color: color.buttonColor,
                              height: MySize.getScaledSizeHeight(24),
                              width: MySize.getScaledSizeWidth(24),
                            ),
                            08.0.wSpace(),
                            commonText.regular(
                              text: AppMessage.lessonPlan,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.textFieldTextColor,
                            ),
                          ],
                        ),
                      ),
                    ).paddingOnly(right: MySize.getScaledSizeHeight(16)),
                    controller.chatCount.value != 0
                        ? Positioned(
                          top: -5,
                          right: -5,
                          child: Container(
                            height: MySize.getScaledSizeHeight(20),
                            width: MySize.getScaledSizeWidth(20),
                            decoration: BoxDecoration(color: color.appColor, shape: BoxShape.circle),
                            child: Obx(() {
                              return Center(
                                child: commonText.medium(
                                  text: '${controller.chatCount.value}',
                                  textColor: color.white,
                                  fontSize: MySize.getScaledSizeHeight(14),
                                ),
                              );
                            }),
                          ).paddingOnly(right: MySize.getScaledSizeHeight(16)),
                        )
                        : SizedBox(height: MySize.getScaledSizeHeight(20), width: MySize.getScaledSizeWidth(20)),
                  ],
                ),
              ),
            ],
            centerTitle: false,
            backgroundColor: Colors.transparent,
          ),
          drawer: drawer(),
          floatingActionButton: InkWell(
            onTap: () {
              Get.to(() => ChatListView())?.then((value) {
                if (value != null) {
                  controller.getPersonalChatsApi();
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
          body: Obx(() {
            return RefreshIndicator(
              displacement: 30,
              backgroundColor: color.white,
              color: color.appColor,
              strokeWidth: 3,
              onRefresh: () async {
                controller.page = 1;
                controller.getPersonalChatsApi();
              },
              child: SingleChildScrollView(
                controller: controller.scrollController,
                physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                child: Padding(
                  padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: Get.height * 0.8),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          !controller.isLoading.value
                              ? controller.getPersonalChatsDataList.isEmpty
                                  ? buildNoDataWidget(height: Get.height / 1.5)
                                  : ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.getPersonalChatsDataList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          final myId = int.tryParse(box.read(PrefsKey.userId).toString());
                                          final chatItem = controller.getPersonalChatsDataList[index];
                                          final chatBy = chatItem.chatBy;
                                          final chatTo = chatItem.chatTo;
                                          Get.to(
                                            () => ChatView(),
                                            arguments: {
                                              'flag': ChatType.Message,
                                              'chatId': chatItem.id,
                                              'profilePic': chatItem.otherUserProfileImage ?? '',
                                              'fullName': chatItem.otherUserFullName ?? '',
                                              'otherID': myId == chatBy ? chatTo : chatBy,
                                            },
                                          )?.then((value) {
                                            print('value-------->');
                                            if (value != null) {
                                              print('null-------->');
                                              if (controller.getPersonalChatsDataList.isEmpty) {
                                                print('if-------->');
                                                controller.getPersonalChatsDataList[index].latestMessageCreatedAt = value['lastMessageTime'];
                                                controller.getPersonalChatsDataList[index].messages!.add(
                                                  Messages(
                                                    messageType: value['messageType'],
                                                    id: value['messageId'],
                                                    messageText: value['lastMessage'],
                                                    createdAt: value['lastMessageTime'],
                                                  ),
                                                );
                                              } else {
                                                print('else-------->');
                                                controller.getPersonalChatsDataList[index].messages?.first.messageText = value['lastMessage'];
                                                controller.getPersonalChatsDataList[index].latestMessageCreatedAt = value['lastMessageTime'];
                                                controller.getPersonalChatsDataList[index].messages?.first.messageType = value['messageType'];
                                                controller.getPersonalChatsDataList[index].id = value['messageChatId'];
                                                controller.getPersonalChatsDataList[index].messages?.first.id = value['messageId'];
                                                controller.getPersonalChatsDataList[index].unreadMessagesCount = 0;
                                              }
                                              controller.getPersonalChatsDataList.sort((a, b) {
                                                final aId = a.messages!.isNotEmpty ? a.messages!.first.id ?? 0 : 0;
                                                final bId = b.messages!.isNotEmpty ? b.messages!.first.id ?? 0 : 0;
                                                return bId.compareTo(aId);
                                              });
                                              controller.update();
                                              FocusManager.instance.primaryFocus!.unfocus();
                                            }
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            CachedImageContainer(
                                              image: '${controller.getPersonalChatsDataList[index].otherUserProfileImage}',
                                              fit: BoxFit.cover,
                                              width: MySize.getScaledSizeHeight(48),
                                              height: MySize.getScaledSizeHeight(48),
                                              placeHolder: images.appIcon,
                                              topCorner: 48,
                                              bottomCorner: 48,
                                            ),
                                            10.0.wSpace(),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  commonText.medium(
                                                    text: controller.getPersonalChatsDataList[index].otherUserFullName,
                                                    textColor: color.black,
                                                    fontSize: MySize.getScaledSizeHeight(16),
                                                  ),
                                                  02.0.hSpace(),
                                                  controller.getPersonalChatsDataList[index].messages?.first.messageType == "Text"
                                                      ? commonText.regular(
                                                        text: controller.getPersonalChatsDataList[index].messages?.first.messageText,
                                                        textColor: color.textFieldTextColor,
                                                        fontSize: MySize.getScaledSizeHeight(14),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      )
                                                      : Row(
                                                        children: [
                                                          Image.asset(
                                                            images.gallery,
                                                            height: MySize.getScaledSizeHeight(20),
                                                            width: MySize.getScaledSizeHeight(20),
                                                          ),
                                                          2.0.wSpace(),
                                                          commonText.regular(
                                                            text: 'Photo',
                                                            textColor: color.textFieldTextColor,
                                                            fontSize: MySize.getScaledSizeHeight(14),
                                                          ),
                                                        ],
                                                      ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                commonText.medium(
                                                  text: controller.formatUtcToLocalTime(
                                                    '${controller.getPersonalChatsDataList[index].latestMessageCreatedAt}',
                                                  ),
                                                  textColor: color.timeColor,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                08.0.hSpace(),
                                                controller.getPersonalChatsDataList[index].unreadMessagesCount != 0
                                                    ? Container(
                                                      height: MySize.getScaledSizeHeight(20),
                                                      width: MySize.getScaledSizeWidth(20),
                                                      decoration: BoxDecoration(color: color.appColor, shape: BoxShape.circle),
                                                      child: Center(
                                                        child: commonText.medium(
                                                          text: '${controller.getPersonalChatsDataList[index].unreadMessagesCount}',
                                                          textColor: color.white,
                                                          fontSize: MySize.getScaledSizeHeight(14),
                                                        ),
                                                      ),
                                                    )
                                                    : SizedBox(height: MySize.getScaledSizeHeight(20), width: MySize.getScaledSizeWidth(20)),
                                              ],
                                            ).paddingOnly(left: MySize.getScaledSizeHeight(12)),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return commonWidget
                                          .commonDivider(color: color.onboardingBorderColor)
                                          .paddingOnly(
                                            left: MySize.getScaledSizeHeight(65),
                                            top: MySize.getScaledSizeHeight(20),
                                            bottom: MySize.getScaledSizeHeight(16),
                                          );
                                    },
                                  )
                              : ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: 8,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      diagonalShimmer(
                                        height: MySize.getScaledSizeHeight(48),
                                        width: MySize.getScaledSizeHeight(48),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      10.0.wSpace(),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            diagonalShimmer(
                                              height: MySize.getScaledSizeHeight(18),
                                              width: MySize.getScaledSizeHeight(150),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            06.0.hSpace(),
                                            diagonalShimmer(
                                              height: MySize.getScaledSizeHeight(16),
                                              width: Get.width,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          diagonalShimmer(
                                            height: MySize.getScaledSizeHeight(12),
                                            width: MySize.getScaledSizeHeight(51),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          08.0.hSpace(),
                                        ],
                                      ).paddingOnly(left: MySize.getScaledSizeHeight(12)),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return commonWidget
                                      .commonDivider(color: color.onboardingBorderColor)
                                      .paddingOnly(
                                        left: MySize.getScaledSizeHeight(65),
                                        top: MySize.getScaledSizeHeight(20),
                                        bottom: MySize.getScaledSizeHeight(16),
                                      );
                                },
                              ),

                          Obx(() {
                            return controller.isLoadMoreRunning.value == true ? Center(child: CommonLoader()) : Container();
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
