import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassListController extends GetxController {
  final searchController = TextEditingController();

  List attendanceList = [
    {
      "name": "Marvin Cooper",
      "status": "".obs,
    },
    {
      "name": "Hendry Kristian",
      "status": "".obs,
    },
    {
      "name": "Jamie Michael",
      "status": "".obs,
    },
    {
      "name": "Javid David",
      "status": "".obs,
    },
    {
      "name": "Avery James",
      "status": "".obs,
    },
  ].obs;
  var filteredAttendanceList = [];
  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredAttendanceList = List.from(attendanceList);
    } else {
      filteredAttendanceList = attendanceList.where((shift) {
        return shift['name'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update();
  }


  List<String> options = [
    "Present",
    "Absent",
    "Out",
  ];

  void updateStatus(int index, String status) {
    (attendanceList[index]["status"] as RxString).value = status;
  }

  bool get isAttendanceComplete {
    return attendanceList.every(
          (user) => (user["status"] as RxString).value.isNotEmpty,
    );
  }

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      update();
    });
    filteredAttendanceList = List.from(attendanceList);
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
