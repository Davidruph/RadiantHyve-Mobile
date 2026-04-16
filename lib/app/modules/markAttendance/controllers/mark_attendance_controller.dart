import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../utils/api_custom_toast.dart';
// import '../../../../utils/messages.dart';
// import '../../../data/api_url.dart';
// import '../../../data/dio_client/network_client.dart';
// import '../model/StudentListModel.dart';
//
// class MarkAttendanceController extends GetxController {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   final searchController = TextEditingController();
//
//   List attendanceList =
//       [
//         {"name": "Marvin Cooper", "mainStatus": "".obs, "isOutSelected": false.obs},
//         {"name": "Hendry Kristian", "mainStatus": "".obs, "isOutSelected": false.obs},
//         {"name": "Jamie Michael", "mainStatus": "".obs, "isOutSelected": false.obs},
//         {"name": "Javid David", "mainStatus": "".obs, "isOutSelected": false.obs},
//         {"name": "Avery James", "mainStatus": "".obs, "isOutSelected": false.obs},
//       ].obs;
//   var filteredAttendanceList = [];
//
//   void filterSearchResults(String query) {
//     if (query.isEmpty) {
//       filteredAttendanceList = List.from(attendanceList);
//     } else {
//       filteredAttendanceList =
//           attendanceList.where((shift) {
//             return shift['name'].toLowerCase().contains(query.toLowerCase());
//           }).toList();
//     }
//     update();
//   }
//
//   // void updateStatus(int index, String selectedOption) {
//   //   var user = attendanceList[index];
//   //
//   //   if (selectedOption == "Out") {
//   //     if ((user["mainStatus"] as RxString).value == "Present") {
//   //       user["isOutSelected"].value = !(user["isOutSelected"] as RxBool).value;
//   //     }
//   //   } else {
//   //     (user["mainStatus"] as RxString).value = selectedOption;
//   //     if (selectedOption == "Absent") {
//   //       user["isOutSelected"].value = false;
//   //     }
//   //   }
//   // }
//
//   bool get isAttendanceComplete {
//     return attendanceList.every((user) => (user["mainStatus"] as RxString).value.isNotEmpty);
//   }
//
//   List<String> options = ["Present", "Absent", "Out"];
//   var isLoading = false.obs;
//
//   List dateList = [];
//   var selectedDay = DateTime.now();
//
//   @override
//   void onInit() {
//     teacherAllStudentApi();
//     scrollController = ScrollController()..addListener(loadMore);
//     filteredAttendanceList = List.from(attendanceList);
//     super.onInit();
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
//
//   List<StudentListData> studentListData = [];
//   List<StudentAttendanceStatus> attendanceStatusList = [];
//
//   // void updateStatus(int index, String status) {
//   //   attendanceStatusList[index].mainStatus.value = status;
//   // }
//
//   //new start
//
//   void updateStatus(int index, String selectedOption) {
//     var user = attendanceList[index];
//     var status = (user["mainStatus"] as RxString);
//     var isOut = (user["isOutSelected"] as RxBool);
//
//     if (selectedOption == "Out") {
//       if (status.value == "Present") {
//         isOut.value = !isOut.value;
//         status.value = isOut.value ? "Out" : "Present";
//       }
//       // If status is "Absent", tapping "Out" does nothing
//     } else {
//       status.value = selectedOption;
//
//       if (selectedOption == "Absent" || selectedOption == "Present") {
//         isOut.value = false;
//       }
//     }
//
//     print("Student $index → Status: ${status.value}, IsOutSelected: ${isOut.value}");
//   }
//
//   //new end
//
//   void assignStatusList() {
//     attendanceStatusList = List.generate(studentListData.length, (_) => StudentAttendanceStatus());
//   }
//
//   var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
//   var page = 1;
//   ScrollController scrollController = ScrollController();
//
//   teacherAllStudentApi({var LoadMore}) async {
//     if (LoadMore != 1) {
//       isLoading.value = true;
//       page = 1;
//     } else {
//       isLoadMoreRunning.value = false;
//     }
//     String baseUrl =
//         "${ApiUrl.studentList}?page=$page"
//         "${searchController.text.trim().isNotEmpty ? "&search=${searchController.text.trim()}" : ""}";
//     return NetworkClient.getInstance.callApi(
//       baseUrl: baseUrl,
//       method: MethodType.get,
//       headers: NetworkClient.getInstance.getAuthHeaders(),
//       successCallback: (response, message) async {
//         StudentListModel studentListModel = StudentListModel.fromJson(response);
//         /*if (studentListModel.status == 1) {
//           if (LoadMore != 1) {
//             studentListData = studentListModel.studentlistdata!;
//             isLoading.value = false;
//           } else {
//             isLoadMoreRunning.value = false;
//             if (studentListData.isNotEmpty) {
//               studentListData.addAll(studentListModel.studentlistdata!);
//               isLoading.value = false;
//             } else {
//               hasNextPage.value = false;
//             }
//           }
//         } else {
//           isLoading.value = false;
//         }*/
//         if (studentListModel.status == 1) {
//           if (LoadMore != 1) {
//             studentListData = studentListModel.studentlistdata!;
//             assignStatusList();
//             isLoading.value = false;
//           } else {
//             isLoadMoreRunning.value = false;
//             if (studentListModel.studentlistdata!.isNotEmpty) {
//               studentListData.addAll(studentListModel.studentlistdata!);
//               // Also extend attendanceStatusList accordingly
//               attendanceStatusList.addAll(
//                 List.generate(
//                   studentListModel.studentlistdata!.length,
//                   (_) => StudentAttendanceStatus(),
//                 ),
//               );
//               isLoading.value = false;
//             } else {
//               hasNextPage.value = false;
//             }
//           }
//         } else {
//           hasNextPage.value = false;
//         }
//
//         update();
//       },
//       failureCallback: (status, message) {
//         isLoading.value = false;
//         if (status['message'] != null) {
//           toastyInfo.showToast(message: status['message']);
//         } else {
//           toastyInfo.showToast(message: message);
//         }
//       },
//       timeOutCallback: () {
//         isLoading.value = false;
//         toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
//       },
//     );
//   }
//
//   Future<dynamic> loadMore() async {
//     if (hasNextPage.value == true &&
//         isLoading.value == false &&
//         isLoadMoreRunning.value == false &&
//         scrollController.offset >= scrollController.position.maxScrollExtent) {
//       isLoadMoreRunning.value = true;
//       page++;
//       await teacherAllStudentApi(LoadMore: 1);
//     }
//   }
// }
//
// class StudentAttendanceStatus {
//   RxString mainStatus = "".obs; // Only one selected at a time, controlled cycle
// }
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/StudentListModel.dart';

class MarkAttendanceController extends GetxController {
  RxBool isAttendance = false.obs;
  RxBool isSubmitted = false.obs;
  RxBool isApiCall = false.obs;


  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  Timer? _debounce;

  void debounceSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      page = 1;
      teacherAllStudentApi();
    });
  }

  List<String> options = ["Present", "Absent", "Out"];
  var isLoading = false.obs;

  List dateList = [];
  var selectedDay = DateTime.now();

  @override
  void onInit() {
    teacherAllStudentApi();
    scrollController = ScrollController()..addListener(loadMore);
    internetChecker();
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

  //region Check internet connection function
  var internetCheckerSubscription;
  bool isDeviceConnected = true;

  Future<void> internetChecker() async {
    internetCheckerSubscription = Connectivity().onConnectivityChanged.listen((result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected) {
        isLoading.value = true;
        update();
      } else {
        teacherAllStudentApi();
        update();
      }
    });
  }

  //endregion

  var selectedOption ='Mother'.obs;
   TextEditingController nameController = TextEditingController();

  List<StudentListData> studentListData = [];

  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;
  ScrollController scrollController = ScrollController();

  teacherAllStudentApi({var LoadMore, isLoadingValue}) async {
    if (LoadMore != 1) {
      if (isLoadingValue != false) {
        isLoading.value = true;
      }
      page = 1;
    } else {
      isLoadMoreRunning.value = false;
    }
    String baseUrl =
        "${ApiUrl.studentList}?page=$page"
        "${searchController.text.trim().isNotEmpty ? "&search=${searchController.text.trim()}" : ""}";
    return NetworkClient.getInstance.callApi(
      baseUrl: baseUrl,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        StudentListModel studentListModel = StudentListModel.fromJson(response);
        isSubmitted.value = studentListModel.isSubmitted!;
        log('isSubmitted.value---->${isSubmitted.value}');
        if (studentListModel.status == 1) {
          if (LoadMore != 1) {
            studentListData = studentListModel.studentlistdata!;
            isAttendance.value = studentListModel.isAttedance!;
            isLoading.value = false;
          } else {
            isLoadMoreRunning.value = false;
            if (studentListModel.studentlistdata!.isNotEmpty) {
              studentListData.addAll(studentListModel.studentlistdata!);
              isLoading.value = false;
            } else {
              hasNextPage.value = false;
            }
          }
        } else {
          hasNextPage.value = false;
        }
        isApiCall.value = false;
        update();
      },
      failureCallback: (status, message) {
        isApiCall.value = false;
        isLoading.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isApiCall.value = false;
        isLoading.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }

  Future<dynamic> loadMore() async {
    if (hasNextPage.value == true &&
        isLoading.value == false &&
        isLoadMoreRunning.value == false &&
        scrollController.offset >= scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await teacherAllStudentApi(LoadMore: 1);
    }
  }

  studentAttendanceApi({studentId, attendanceStatus,}) async {
    isApiCall.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.studentAttedance,
      params:
      attendanceStatus == "out"?
      {"student_id": studentId, "attendance_status": attendanceStatus,'parent_name':nameController.text.trim(),'relation_to_child':selectedOption.value}:
      {"student_id": studentId, "attendance_status": attendanceStatus},
      method: MethodType.post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        teacherAllStudentApi(isLoadingValue: false);
        update();
      },
      failureCallback: (status, message) {
        isApiCall.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isApiCall.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
}
