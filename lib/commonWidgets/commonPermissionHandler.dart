import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/Img_Icon.dart';
import '../utils/SizeConstant.dart';
import 'common_text.dart';
import 'common_widgets.dart';

Future<bool> commonPermissionsHandler({required Permission permission}) async {
  PermissionStatus status = await permission.status;
  if (status.isGranted || status.isLimited) return true;
  if (status.isDenied || status.isRestricted) {
    return await handlePermission(permission: permission);
  }
  if (status == PermissionStatus.permanentlyDenied) {
    bool goToSettings = await permissionSettingsDialog();
    if (goToSettings) {
      await openAppSettings();
    }
  }

  return false;
}

Future<bool> handlePermission({required Permission permission}) async {
  String title = '';
  String icon = '';
  if (permission == Permission.camera) {
    title = 'We need access to your camera to enhance your experience.';
    icon = images.cameraPermissionImage;
  } else if (permission == Permission.photos || permission == Permission.mediaLibrary) {
    title = 'We need access to your photos to enhance your experience.';
    icon = images.galleryPermissionImage;
  } else if (permission == Permission.storage) {
    title = 'We need access to your storage to enhance your experience.';
    icon = images.galleryPermissionImage;
  }

  bool userAccepted = await permissionDialog(permission: permission, title: title, icon: icon);
  if (userAccepted) {
    final result = await permission.request();
    return result.isGranted || result.isLimited;
  }

  return false;
}

Future<bool> permissionDialog({required Permission permission, required String title, required String icon}) async {
  return await showDialog<bool>(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              18.0.hSpace(),
              if (icon.isNotEmpty) ZoomIn(child: Image.asset(icon, height: MySize.getScaledSizeHeight(84), width: MySize.getScaledSizeHeight(84))),
              18.0.hSpace(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(16)),
                child: Column(
                  children: [
                    Center(child: commonText.medium(text: title, textAlign: TextAlign.center, fontSize: MySize.getScaledSizeHeight(16))),
                    28.0.hSpace(),
                    commonWidget.customButton(text: 'Continue', onTap: () => Get.back(result: true)),
                    16.0.hSpace(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).then((value) => value ?? false);
}

Future<bool> permissionSettingsDialog() async {
  return await showDialog<bool>(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), color: Colors.white),
          padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(16), vertical: MySize.getScaledSizeHeight(24)),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ZoomIn(child: Image.asset(images.settingRootImage, height: MySize.getScaledSizeHeight(84), width: MySize.getScaledSizeHeight(84))),
                18.0.hSpace(),
                commonText.medium(text: "Full Permissions?", fontSize: MySize.getScaledSizeHeight(18)),
                10.0.hSpace(),
                commonText.medium(
                  text: "We need your location to show nearby deals and places for the best app experience.",
                  textAlign: TextAlign.center,
                  fontSize: MySize.getScaledSizeHeight(14),
                ),
                28.0.hSpace(),
                commonWidget.customButton(text: 'Go to Settings', onTap: () => Get.back(result: true)),
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) => value ?? false);
}
