import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgramListController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List programList = [
    {'programName': 'Program 1'},
    {'programName': 'Program 2'},
    {'programName': 'Program 3'},
  ];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      update();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
