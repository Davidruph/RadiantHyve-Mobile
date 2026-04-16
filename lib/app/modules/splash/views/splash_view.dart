import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return GetBuilder<SplashController>(
      init: SplashController(),
      assignId: true,
      builder: (logic) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff9810FA),
                  Color(0xff4F39F6),
                ],
              ),
            ),
            child: Column(
              children: [
                commonWidget.appBar(
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                  leading: SizedBox(),
                  toolbarHeight: 0.0,
                  backgroundColor: Colors.transparent,
                ),
                Expanded(
                  child: Center(
                    child: ZoomIn(
                      duration: Duration(seconds: 3),
                      child: Image.asset(
                        images.splashImage,
                        height: MySize.getScaledSizeHeight(128),
                        width: MySize.getScaledSizeWidth(240),
                        fit: BoxFit.fill,
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
