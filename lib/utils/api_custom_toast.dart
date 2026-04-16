// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:radianthyve_unified/utils/Img_Icon.dart';
// import 'package:radianthyve_unified/utils/common_color.dart';
//
// import '../commonWidgets/common_text.dart';
// import 'SizeConstant.dart';
//
// ToastyInfo toastyInfo = ToastyInfo();
// var isAppInForeground = AppLifecycleState.resumed;
//
// class ToastyInfo {
//   showToast(String message, {Color? backgroundColor, IconData? icon, Color? iconColor}) {
//     if (isAppInForeground == AppLifecycleState.resumed && Get.context != null) {
//       Future.delayed(const Duration(milliseconds: 200), () {
//         try {
//           Flushbar(
//             borderColor: Colors.white.withOpacity(0.5),
//             flushbarPosition: FlushbarPosition.TOP,
//             padding: EdgeInsets.symmetric(vertical: MySize.getScaledSizeHeight(12), horizontal: MySize.getScaledSizeHeight(12)),
//             margin: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(16)),
//             messageText: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: MySize.getScaledSizeHeight(10),
//                   backgroundColor: (backgroundColor != color.toastWarningColor) ? color.white : backgroundColor,
//                   child:
//                       (backgroundColor == color.toastWarningColor)
//                           ? Image.asset(images.warningImage, height: MySize.getScaledSizeHeight(18), width: MySize.getScaledSizeHeight(18))
//                           : Icon(
//                             icon ??
//                                 (message == "You're offline! Check Your internet connection."
//                                     ? Icons.cloud_off
//                                     : message == "You're back online!"
//                                     ? Icons.cloud_done_outlined
//                                     : Icons.check),
//                             color:
//                                 iconColor ??
//                                 (message == "You're offline! Check Your internet connection."
//                                     ? Colors.black
//                                     : message == "You're back online!"
//                                     ? color.black
//                                     : backgroundColor ?? color.primaryColor),
//                             size: MySize.getScaledSizeHeight(14),
//                           ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(child: commonText.semiBold(text: message, textColor: color.white)),
//               ],
//             ),
//             duration: const Duration(seconds: 2),
//             borderRadius: BorderRadius.circular(MySize.getScaledSizeWidth(12)),
//             backgroundColor: backgroundColor ?? color.toastWarningColor,
//           ).show(Get.context!);
//         } catch (e) {
//           print("⚠️ Failed to show toast: $e");
//         }
//       });
//     }
//   }
// }
//
// /*class ToastyInfo {
//   showToast(String message, {backgroundColor, icon, iconColor}) {
//     if (isAppInForeground == AppLifecycleState.resumed) {
//       Future.delayed(const Duration(milliseconds: 200), () {
//         Flushbar(
//           flushbarPosition: FlushbarPosition.TOP,
//           padding: EdgeInsets.symmetric(vertical: MySize.getScaledSizeHeight(12), horizontal: MySize.getScaledSizeHeight(12)),
//           margin: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(16)),
//           messageText: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CircleAvatar(
//                 radius: MySize.getScaledSizeHeight(10),
//                 backgroundColor: (backgroundColor != AppColor.toastWarningColor) ? AppColor.white : backgroundColor,
//                 child: (backgroundColor == AppColor.toastWarningColor)
//                     ? Image.asset(
//                         AppImages.warning,
//                         height: MySize.getScaledSizeHeight(18),
//                         width: MySize.getScaledSizeHeight(18),
//                       )
//                     : Icon(
//                         icon ?? message == "You're offline! Check Your internet connection."
//                             ? Icons.cloud_off
//                             : message == "You're back online!"
//                                 ? Icons.cloud_done_outlined
//                                 : Icons.check,
//                         color: iconColor ?? message == "You're offline! Check Your internet connection."
//                             ? Colors.black
//                             : message == "You're back online!"
//                                 ? AppColor.black
//                                 : backgroundColor ?? AppColor.primaryColor,
//                         size: MySize.getScaledSizeHeight(14),
//                       ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: commonText.poppins600(text: message, textColor: AppColor.white),
//               ),
//             ],
//           ),
//           duration: const Duration(seconds: 2),
//           borderRadius: BorderRadius.circular(MySize.getScaledSizeWidth(12)),
//           backgroundColor: backgroundColor ?? AppColor.toastWarningColor,
//         ).show(Get.context!);
//       });
//     }
//   }
// }*/


import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import '../commonWidgets/common_text.dart';
import 'Img_Icon.dart';
import 'SizeConstant.dart';

ToastyInfo toastyInfo = ToastyInfo();
var isAppInForeground = AppLifecycleState.resumed;

class ToastyInfo {
  showToast({String? message, Color? backgroundColor, icon, iconColor}) {
    if (isAppInForeground == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 200), () {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          padding: EdgeInsets.symmetric(vertical: MySize.getScaledSizeHeight(12), horizontal: MySize.getScaledSizeHeight(12)),
          margin: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeHeight(16)),
          messageText: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: MySize.getScaledSizeHeight(10),
                backgroundColor:
                    backgroundColor == null
                        ? Colors.transparent
                        : (backgroundColor != color.warnRedColor)
                        ? color.white
                        : backgroundColor,
                child:
                    (backgroundColor == color.warnRedColor) || (backgroundColor == null)
                        ? Image.asset(images.warningImage, height: MySize.getScaledSizeHeight(18), width: MySize.getScaledSizeHeight(18))
                        : Icon(
                          icon ?? message == "You're offline! Check Your internet connection."
                              ? Icons.cloud_off
                              : message == "You're back online!"
                              ? Icons.cloud_done_outlined
                              : Icons.check,
                          color:
                              iconColor ?? message == "You're offline! Check Your internet connection."
                                  ? Colors.black
                                  : message == "You're back online!"
                                  ? color.black
                                  : backgroundColor,
                          size: MySize.getScaledSizeHeight(16),
                        ),
              ),
              const SizedBox(width: 8),
              Expanded(child: commonText.semiBold(text: message, textColor: color.white, fontSize: MySize.getScaledSizeHeight(16))),
            ],
          ),
          duration: const Duration(seconds: 2),
          borderRadius: BorderRadius.circular(MySize.getScaledSizeWidth(12)),
          backgroundColor: backgroundColor ?? color.warnRedColor,
          borderColor: Colors.white.withOpacity(0.5),
        ).show(Get.context!);
      });
    }
  }
}
