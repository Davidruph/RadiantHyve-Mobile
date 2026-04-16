import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassroomController extends GetxController {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List ClassRoomList = [
    {
      'className': 'Class 1',
      'totalStudent': '120',
    },
    {
      'className': 'Class 2',
      'totalStudent': '120',
    },
    {
      'className': 'Class 3',
      'totalStudent': '120',
    },
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
