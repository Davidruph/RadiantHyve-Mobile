import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChildReportsController extends GetxController {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List ChildReportList = [
    {
      'name': 'Meal',
    },
    {
      'name': 'Sleep Logs',
    },
    {
      'name': 'Medication',
    },
    {
      'name': 'Diaper & Hygiene Tracker',
    },
  ];


  @override
  void onInit() {
    super.onInit();
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
