import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:radianthyve_unified/app/modules/addProgram/views/add_program_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_drawer.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import '../controllers/program_list_controller.dart';

class ProgramListView extends GetView<ProgramListController> {
  const ProgramListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgramListController>(
      init: ProgramListController(),
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
              text: AppMessage.program,
              fontSize: MySize.getScaledSizeHeight(18),
              textColor: color.white,
            ),
            centerTitle: false,
            // toolbarHeight: 0.0,
            backgroundColor: color.appColor,
          ),
          drawer: drawer(),
          floatingActionButton: InkWell(
            onTap: () {
              Get.to(() => AddProgramView());
            },
            child: Container(
              height: MySize.getScaledSizeHeight(50),
              width: MySize.getScaledSizeWidth(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.buttonColor,
              ),
              child: Icon(
                Icons.add_outlined,
                size: MySize.getScaledSizeHeight(30),
                color: color.white,
              ),
            ).paddingOnly(bottom: MySize.getScaledSizeHeight(28)),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
            child: controller.isLoading.value ? ListView.separated(
              itemCount: controller.programList.length,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return diagonalShimmer(
                  height: MySize.getScaledSizeHeight(54),
                  width: Get.width,
                  borderRadius: BorderRadius.circular(8),
                );
              },
              separatorBuilder: (context, index) {
                return 16.0.hSpace();
              },
            ) : ListView.separated(
              itemCount: controller.programList.length,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: color.white,
                    borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            commonText.medium(
                              text: controller.programList[index]['programName'],
                              textColor: color.black,
                              fontSize: MySize.getScaledSizeHeight(16),
                            ),
                            Button(index: index),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return 16.0.hSpace();
              },
            ),
          ),
        );
      },
    );
  }
}

class Button extends StatelessWidget {
  final int index;
  const Button({Key? key, required this.index}) : super(key: key);

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
            bodyBuilder: (context) => Padding(
              padding: EdgeInsets.symmetric(vertical: MySize.getScaledSizeHeight(8)),
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  _commonRowImageWithText(
                    image: icons.editIcon,
                    text: AppMessage.edit,
                    onTap: () {
                      Get.back();
                      Get.to(() => AddProgramView(),arguments: {'flag': 'editProgram'});
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
                      deleteAccountDialog(context: context, index: index);
                    },
                  ),
                ],
              ),
            ),
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

  void deleteAccountDialog({required BuildContext context, required int index}) {
    ProgramListController controller = Get.find();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(20)),
          ),
          child: Container(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                commonText.medium(
                  text: AppMessage.deleteProgram,
                  fontSize: MySize.getScaledSizeHeight(18),
                  textColor: color.black,
                  textAlign: TextAlign.center,
                ),
                30.0.hSpace(),
                ZoomIn(
                  duration: Duration(seconds: 3),
                  child: Image.asset(
                    images.deleteImage,
                    height: MySize.getScaledSizeHeight(104),
                    width: MySize.getScaledSizeWidth(104),
                  ),
                ),
                30.0.hSpace(),
                commonText
                    .medium(
                  text: AppMessage.areYouSureYouWantToDeleteThisProgram,
                  fontSize: MySize.getScaledSizeHeight(16),
                  textColor: color.black,
                  textAlign: TextAlign.center,
                )
                    .paddingSymmetric(horizontal: MySize.getScaledSizeHeight(14)),
                20.0.hSpace(),
                commonWidget.customButton(
                  buttonColor: color.textFieldErrorColor,
                  text: AppMessage.yesDelete,
                  onTap: () {
                    Get.back();
                    controller.programList.removeAt(index); // Corrected deletion
                    controller.update(); // Refresh UI
                  },
                ),
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
          ),
        );
      },
    );
  }

}
