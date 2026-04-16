import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import '../utils/Img_Icon.dart';
import '../utils/SizeConstant.dart';
import 'common_text.dart';

Widget buildNoDataWidget({double? height, String? text}) {
  return SizedBox(
    height: height ?? Get.height / 2,
    width: Get.width,
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(images.noDataFound, height: MySize.getScaledSizeHeight(100), width: MySize.getScaledSizeHeight(100)),
          20.0.hSpace(),
          commonText.medium(text: text ?? 'No Data Found', fontSize: MySize.getScaledSizeHeight(16), textColor: Color(0xff757D83)),
        ],
      ),
    ),
  );
}
