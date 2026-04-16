import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassroomReportController extends GetxController with GetSingleTickerProviderStateMixin {

  TabController? tabController;
  var selectedIndex = 0.obs;

  var isLoading = false.obs;

  List mealTracking = [
    {
      'mealType': 'Morning Snack',
      'date': '28/10/2024',
      'time': '09:30 AM',
    },
    {
      'mealType': 'Lunch',
      'date': '28/10/2024',
      'time': '12:30 PM',
    },
  ];

  final searchController = TextEditingController();
  List sleepLogsList = [
    {
      'studentName': 'Dianne Howard',
      'studentID': '396350',
      'parentsName': 'Esther Howard',
      'sleepSummary': '11:00 PM to 07:00 AM',
      'isAddInfo': true,
    },
    {
      'studentName': 'Brooklyn Simmons',
      'studentID': '396350',
      'parentsName': 'Esther Howard',
      'sleepSummary': '11:00 PM to 07:00 AM',
      'isAddInfo': false,
    },
    {
      'studentName': 'Henry Miles',
      'studentID': '396350',
      'parentsName': 'Esther Howard',
      'sleepSummary': '11:00 PM to 07:00 AM',
      'isAddInfo': false,
    },
  ];
  var filteredSleepLogsList = [];
  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredSleepLogsList = List.from(sleepLogsList);
    } else {
      filteredSleepLogsList = sleepLogsList.where((shift) {
        return shift['studentName'].toLowerCase().contains(query.toLowerCase()) ||
            shift['parentsName'].toLowerCase().contains(query.toLowerCase()) ||
            shift['studentID'].toString().contains(query);
      }).toList();
    }
    update();
  }

  final searchController1 = TextEditingController();
  List medicationList = [
    {
      'studentName': 'Dianne Howard',
      'studentID': '396350',
      'typeOfDisease': 'Allergy',
      'doctorsName': 'Dr. Faisal Ahmed',
    },
    {
      'studentName': 'Brooklyn Simmons',
      'studentID': '396350',
      'typeOfDisease': 'Fever',
      'doctorsName': 'Dr. Faisal Ahmed',
    },
    {
      'studentName': 'Dianne Howard',
      'studentID': '396350',
      'typeOfDisease': 'Allergy',
      'doctorsName': 'Dr. Zafar Islam',
    },

  ];
  var filteredMedicationList = [];
  void filterMedicationResults(String query) {
    if (query.isEmpty) {
      filteredMedicationList = List.from(medicationList);
    } else {
      filteredMedicationList = medicationList.where((shift) {
        return shift['studentName'].toLowerCase().contains(query.toLowerCase()) ||
            shift['typeOfDisease'].toLowerCase().contains(query.toLowerCase()) ||
            shift['doctorsName'].toLowerCase().contains(query.toLowerCase()) ||
            shift['studentID'].toString().contains(query);
      }).toList();
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      update();
    });
    tabController = TabController(length: 3, vsync: this);
    filteredSleepLogsList = List.from(sleepLogsList);
    filteredMedicationList = List.from(medicationList);
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
