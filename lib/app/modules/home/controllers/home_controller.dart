import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../commonWidgets/connect_socket.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/notification_service.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../../../utils/roleBasedNavigation.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../editChildsInformation/model/StudentsListModel.dart';

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Parent-specific attributes
  List<StudentsListData> studentsListDataList = [];
  var isLoadMoreRunning = false.obs;
  var page = 1, hasNextPage = true.obs;
  ScrollController scrollController = ScrollController();
  
  // Teacher/Principal attendance attributes
  var attendanceList = [].obs;
  var elapsedTime = "00:00:00".obs;
  var isClockIn = false.obs;
  var isClockInOutLoader = false.obs;
  var isButtonOnTap = false.obs;
  Timer? _timer;
  
  var isLoading = false.obs;
  final userId = box.read(PrefsKey.userId);
  
  late String userRole;
  
  @override
  void onInit() {
    userRole = getUserRole().toLowerCase();
    
    if (userId != "NULL" || userId != "null" || userId != "" || userId != null) {
      connectSocket();
    }
    
    // Role-based initialization
    if (userRole == 'parent') {
      studentsListAPI();
      scrollController.addListener(StudentsListLoadMore);
    } else if (userRole == 'teacher' || userRole == 'principal' || userRole == 'admin') {
      attendanceListAPI();
      startElapsedTimeTimer();
    }
    
    internetChecker();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    if (userRole == 'parent') {
      scrollController.dispose();
    } else if (userRole == 'teacher' || userRole == 'principal' || userRole == 'admin') {
      _timer?.cancel();
    }
    if (internetCheckerSubscription != null) {
      internetCheckerSubscription.cancel();
    }
    super.onClose();
  }

  // Parent: Students list API
  studentsListAPI({int isLoadMore = 0}) async {
    if (isLoadMore == 1) {
      isLoadMoreRunning.value = true;
    } else {
      page = 1;
      isLoading.value = true;
      isLoadMoreRunning.value = false;
      hasNextPage.value = true;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.studentsList}?page=$page",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        StudentsListModel responseData = StudentsListModel.fromJson(response);
        log('response------->$response');
        if (isLoadMore != 1) {
          if (responseData.data != null) {
            studentsListDataList = responseData.data ?? [];
          }
        } else {
          if (responseData.data!.isNotEmpty) {
            studentsListDataList.addAll(responseData.data ?? []);
            isLoadMoreRunning.value = false;
          } else {
            hasNextPage.value = false;
            isLoadMoreRunning.value = false;
          }
        }
        isLoading.value = false;
        update();
      },
      failureCallback: (status, message) {
        isLoading.value = false;
        isLoadMoreRunning.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isLoading.value = false;
        isLoadMoreRunning.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }

  Future<void> StudentsListLoadMore() async {
    if (hasNextPage.value &&
        !isLoading.value &&
        !isLoadMoreRunning.value &&
        scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isLoadMoreRunning.value = true;
      page++;
      await studentsListAPI(isLoadMore: 1);
    }
  }

  var internetCheckerSubscription;
  bool isDeviceConnected = true;

  Future<void> internetChecker() async {
    internetCheckerSubscription = Connectivity().onConnectivityChanged.listen((result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected) {
        isLoading.value = true;
        update();
      } else {
        if (userRole == 'parent') {
          studentsListAPI();
        } else if (userRole == 'teacher' || userRole == 'principal' || userRole == 'admin') {
          attendanceListAPI();
        }
        update();
      }
    });
  }

  // Teacher/Principal: Attendance API
  attendanceListAPI() async {
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.attendanceList,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        try {
          if (response is List) {
            attendanceList.value = response;
          } else if (response is Map && response['data'] != null) {
            attendanceList.value = response['data'] is List ? response['data'] : [];
          }
          
          // Check if already clocked in today
          if (attendanceList.isNotEmpty && attendanceList[0]['clock_out_time'] == null) {
            isClockIn.value = true;
          } else {
            isClockIn.value = false;
          }
        } catch (e) {
          log('Error parsing attendance: $e');
        }
        isLoading.value = false;
        update();
      },
      failureCallback: (status, message) {
        isLoading.value = false;
      },
      timeOutCallback: () {
        isLoading.value = false;
      },
    );
  }

  // Start elapsed time counter
  void startElapsedTimeTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (attendanceList.isNotEmpty && attendanceList[0]['clock_out_time'] == null) {
        DateTime? clockInTime;
        try {
          clockInTime = DateTime.parse(attendanceList[0]['clock_in_time']);
        } catch (e) {
          log('Error parsing clock in time: $e');
        }
        
        if (clockInTime != null) {
          Duration elapsed = DateTime.now().difference(clockInTime);
          int hours = elapsed.inHours;
          int minutes = elapsed.inMinutes.remainder(60);
          int seconds = elapsed.inSeconds.remainder(60);
          elapsedTime.value = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        }
      } else {
        elapsedTime.value = "00:00:00";
      }
    });
  }

  // Handle clock in/out
  Future<void> handleLocationPermissionAndInit() async {
    isButtonOnTap.value = true;
    isClockInOutLoader.value = true;
    
    try {
      // Mock implementation - replace with actual API call
      await Future.delayed(Duration(seconds: 1));
      
      if (isClockIn.value) {
        // Clock out
        isClockIn.value = false;
      } else {
        // Clock in
        isClockIn.value = true;
      }
      
      await attendanceListAPI();
    } catch (e) {
      log('Error in clock in/out: $e');
    } finally {
      isButtonOnTap.value = false;
      isClockInOutLoader.value = false;
    }
  }
}
