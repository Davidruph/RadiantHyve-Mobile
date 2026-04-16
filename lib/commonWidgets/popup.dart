import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';

void showPermissionSettingDialog({required BuildContext context, String? permissionName}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              commonText.medium(
                text: 'Full Permissions?',
                fontSize: MySize.getScaledSizeHeight(20),
                textColor: color.black,
              ),
              const SizedBox(height: 20),
              commonText.regular(
                text: 'We need access to essential features to ensure the best experience.',
                fontSize: MySize.getScaledSizeHeight(14),
                textColor: color.black,
              ),
              const SizedBox(height: 10),
              Image.asset(
                images.settingRootImage,
                height: MySize.getScaledSizeHeight(110),
                width: MySize.getScaledSizeHeight(110),
              ),
              const SizedBox(height: 10),
              commonWidget.customButton(
                text: 'Go to Settings',
                onTap: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
              )
            ],
          ),
        ),
      );
    },
  );
}

void showPermissionDialog({required BuildContext context, int permission = 1, required Function onConfirm}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              commonText.medium(
                text: permission == 1
                    ? 'Camera Access?'
                    : Platform.isAndroid
                        ? 'Storage Access?'
                        : 'Photo Access?',
                fontSize: MySize.getScaledSizeHeight(18),
                textColor: color.black,
              ),
              const SizedBox(height: 20),
              commonText.regular(
                textAlign: TextAlign.center,
                text: permission == 1
                    ? 'We need access to your camera for profile picture.'
                    : Platform.isAndroid
                        ? 'We need access to your storage for profile picture'
                        : 'We need access to your photo for profile picture',
                fontSize: MySize.getScaledSizeHeight(14),
                textColor: color.black,
              ),
              const SizedBox(height: 10),
              Image.asset(
                permission == 1 ? images.cameraPermissionImage : images.galleryPermissionImage,
                height: MySize.getScaledSizeHeight(140),
                width: MySize.getScaledSizeHeight(140),
              ),
              const SizedBox(height: 10),
              commonWidget.customButton(
                text: 'Continue',
                onTap: () {
                  onConfirm();
                },
              )
            ],
          ),
        ),
      );
    },
  );
}

/*void showPermissionLocationDialog({required BuildContext context, required Function onConfirm}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              commonText.medium(
                text:  'Location Access?',
                fontSize: MySize.getScaledSizeHeight(18),
                textColor: color.white,
              ),
              const SizedBox(height: 20),
              commonText.regular(
                textAlign: TextAlign.center,
                text: 'We need access to your location for further process',
                fontSize: MySize.getScaledSizeHeight(14),
                textColor: color.white,
              ),
              const SizedBox(height: 10),
              Image.asset(
               images.locationPermissionImage,
                height: MySize.getScaledSizeHeight(140),
                width: MySize.getScaledSizeHeight(140),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: commonWidget.customButton(
                      text: 'Cancel',
                      textColor: color.white,
                      buttonColor: color.transparentColor,
                      borderColor: color.dividerColor,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(width: MySize.getScaledSizeWidth(13)),
                  Expanded(
                    child: commonWidget.customButton(
                      text: 'Allow',
                      onTap: () {
                        onConfirm();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}*/

/*void showPermissionNotificationDialog({required BuildContext context, required Function onConfirm}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              commonText.medium(
                text: 'Notification Access?',
                fontSize: MySize.getScaledSizeHeight(18),
                textColor: color.white,
              ),
              const SizedBox(height: 20),
              commonText.regular(
                textAlign: TextAlign.center,
                text: 'We need access to your notification for further process',
                fontSize: MySize.getScaledSizeHeight(14),
                textColor: color.white,
              ),
              const SizedBox(height: 10),
              Image.asset(
                images.locationPermissionImage,
                height: MySize.getScaledSizeHeight(140),
                width: MySize.getScaledSizeHeight(140),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: commonWidget.customButton2(
                      text: 'Cancel',
                      textColor: Colors.white,
                      color: Colors.black,
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(width: MySize.getScaledSizeWidth(13)),
                  Expanded(
                    child: commonWidget.customButton(
                      text: 'Allow',
                      onTap: () {
                        onConfirm();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}*/
