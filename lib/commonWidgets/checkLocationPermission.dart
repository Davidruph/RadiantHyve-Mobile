import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/common_color.dart';

import '../utils/SizeConstant.dart';
import '../utils/messages.dart';
import 'common_text.dart';

void checkLocationPermission({Function()? allowOnTap}) async {
  PermissionStatus status = await Permission.location.status;
  if (status.isDenied) {
    showPermissionLocationDialog(context: Get.context!, allowOnTap: allowOnTap);
  } else if (status.isPermanentlyDenied) {
    showPermissionSettingDialog(context: Get.context!);
  }
}

void showPermissionLocationDialog({required BuildContext context, String? permissionName, Function()? allowOnTap}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(16)),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              commonText.semiBold(
                text: AppMessage.allowLocationAccess,
                fontSize: MySize.getScaledSizeHeight(20),
              ),
              const SizedBox(height: 20),
              commonText.regular(
                textAlign: TextAlign.center,
                text: AppMessage.toProceedWith,
                fontSize: MySize.getScaledSizeHeight(14),
                textColor: Colors.black,
              ),
              10.0.hSpace(),
              Image.asset(
                images.location,
                height: MySize.getScaledSizeHeight(150),
                width: MySize.getScaledSizeHeight(150),
              ),
              10.0.hSpace(),
              InkWell(
                onTap: allowOnTap,
                child: Container(
                  width: Get.width,
                  height: MySize.getScaledSizeHeight(48),
                  decoration: BoxDecoration(
                    color: color.appColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: commonText.medium(
                      text: AppMessage.allow,
                      fontSize: MySize.getScaledSizeHeight(16),
                      textColor: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

void showPermissionSettingDialog({required BuildContext context, String? permissionName}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(16)),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              commonText.semiBold(text: AppMessage.fullPermissions, fontSize: MySize.getScaledSizeHeight(20)),
              const SizedBox(height: 20),
              commonText.regular(
                textAlign: TextAlign.center,
                text: AppMessage.allowLocationAccess,
                fontSize: MySize.getScaledSizeHeight(14),
                textColor: color.black,
              ),
              10.0.hSpace(),
              Image.asset(
                images.settingRootImage,
                height: MySize.getScaledSizeHeight(150),
                width: MySize.getScaledSizeHeight(150),
              ),
              10.0.hSpace(),
              InkWell(
                onTap: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: Get.width,
                  height: MySize.getScaledSizeHeight(48),
                  decoration: BoxDecoration(
                    color: color.appColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: commonText.medium(
                      text: AppMessage.goToSettings,
                      fontSize: MySize.getScaledSizeHeight(16),
                      textColor: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
