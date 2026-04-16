import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmergencyListController extends GetxController {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List emergencyList = [
    {
      'emergency': 'Fire',
      'date': '22/10/2024',
      'class': 'Class 1',
      'emergencyId': '1145685',
    },
    {
      'emergency': 'Storm',
      'date': '22/10/2024',
      'class': 'Class 2',
      'emergencyId': '1145685',
    },
    {
      'emergency': 'Active Shooter',
      'date': '22/10/2024',
      'class': 'All Class',
      'emergencyId': '1145685',
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
