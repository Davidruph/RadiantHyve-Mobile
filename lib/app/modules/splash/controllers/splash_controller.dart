import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/home/views/home_view.dart';
import 'package:radianthyve_unified/app/modules/home/views/teachers_home_view.dart';
import 'package:radianthyve_unified/app/modules/home/views/principal_home_view.dart';
import 'package:radianthyve_unified/app/modules/login/views/login_view.dart';

import '../../../../commonWidgets/InternetConnectivity.dart';
import '../../../../commonWidgets/connect_socket.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/notification_service.dart';
import '../../../../utils/common.dart';
import '../../../../utils/prefsKey.dart';
import '../../../../utils/roleBasedNavigation.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Future.delayed(const Duration(microseconds: 200), () async {
      await notificationService.getNotification();
    });
    await internetConnectivityChecker();
    commonMethod.getDeviceToken();
    route();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  route() {
    Future.delayed(const Duration(seconds: 3), () {
      final userToken = box.read(PrefsKey.userToken);
      if (userToken != null && userToken != "null" && userToken != "") {
        log("userToken=====> $userToken");
        
        // Route to appropriate home based on user role
        final userRole = getUserRole();
        log("User Role: $userRole");
        
        switch(userRole.toLowerCase()) {
          case 'teacher':
            Get.offAll(() => const TeachersHomeView());
            break;
          case 'parent':
            Get.offAll(() => HomeView());
            break;
          case 'principal':
          case 'admin':
            Get.offAll(() => const PrincipalHomeView());
            break;
          default:
            Get.offAll(() => HomeView());
        }
      } else {
        Get.offAll(() => const LoginView());
      }
    });
  }
}
