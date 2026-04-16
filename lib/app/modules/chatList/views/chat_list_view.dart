import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';

import '../../../../commonWidgets/CachedImageContainer.dart';
import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/chat_list_controller.dart';

class ChatListView extends GetView<ChatListController> {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(
      init: ChatListController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: color.backgroundColor,
            appBar: commonWidget.appBar(
              titleText: AppMessage.message,
              backgroundColor: color.transparentColor,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.black),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)),
                      color: color.onboardingBorderColor,
                    ),
                    child: TextField(
                      cursorColor: color.black,
                      controller: controller.searchController,
                      onSubmitted: (value) {
                        controller.page = 1;
                        controller.listUserChatApi();
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(
                          RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                        ),
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(16), vertical: MySize.getScaledSizeHeight(14)),
                        hintText: AppMessage.search,
                        border: InputBorder.none,
                        prefixIcon: Image.asset(icons.searchIcon, scale: 4.0),
                        suffixIcon:
                            controller.searchController.text != ''
                                ? GestureDetector(
                                  onTap: () {
                                    controller.searchController.clear();
                                    controller.listUserChatApi();
                                    controller.update();
                                  },
                                  child: Icon(Icons.close_rounded, size: 24, color: color.black),
                                )
                                : SizedBox(),
                        hintStyle: TextStyle(
                          fontSize: MySize.getScaledSizeHeight(14),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Regular',
                          color: color.onboardingTextColor,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: MySize.getScaledSizeHeight(14),
                        color: color.black,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  15.0.hSpace(),
                  Obx(() {
                    return Expanded(
                      child: RefreshIndicator(
                        displacement: 30,
                        backgroundColor: color.white,
                        color: color.appColor,
                        strokeWidth: 3,
                        onRefresh: () async {
                          controller.page = 1;
                          controller.listUserChatApi();
                        },
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                          child: Column(
                            children: [
                              !controller.isLoading.value
                                  ? controller.listUserChatDataList.isEmpty
                                      ? buildNoDataWidget(height: Get.height / 1.5)
                                      : ListView.separated(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemCount: controller.listUserChatDataList.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              controller.createChatApi(index: index);
                                            },
                                            child: Row(
                                              children: [
                                                CachedImageContainer(
                                                  image: '${controller.listUserChatDataList[index].profilePic}',
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
                                                        text: controller.listUserChatDataList[index].fullName,
                                                        textColor: color.black,
                                                        fontSize: MySize.getScaledSizeHeight(16),
                                                        maxLines: 1,
                                                      ),
                                                      02.0.hSpace(),
                                                      commonText.regular(
                                                        text:
                                                            controller.listUserChatDataList[index].role == 'principal'
                                                                ? "Principal"
                                                                : controller.listUserChatDataList[index].role == 'teacher'
                                                                ? "Teacher"
                                                                : 'Parent',
                                                        textColor: color.textFieldTextColor,
                                                        fontSize: MySize.getScaledSizeHeight(14),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                10.0.wSpace(),
                                                Image.asset(
                                                  icons.message,
                                                  height: MySize.getScaledSizeHeight(24),
                                                  width: MySize.getScaledSizeWidth(24),
                                                  color: color.appColor,
                                                ),
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
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 8,
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
                                          10.0.wSpace(),
                                          diagonalShimmer(
                                            height: MySize.getScaledSizeHeight(24),
                                            width: MySize.getScaledSizeWidth(24),
                                            borderRadius: BorderRadius.circular(24),
                                          ),
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
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
