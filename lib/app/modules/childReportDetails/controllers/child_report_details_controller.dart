import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/ListStudentsDiaperAndBathModel.dart';
import '../model/MealTrackingModel.dart';
import '../model/MedicationModel.dart';
import '../model/SleepLogsModel.dart';

class ChildReportDetailsController extends GetxController with GetSingleTickerProviderStateMixin {
  RxInt tabIndex = 0.obs;
  TabController? tabController;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      studentId = Get.arguments['studentId'];
    }
    tabController = TabController(length: 5, vsync: this, initialIndex: tabIndex.value ?? 0);
    mealScrollController.addListener(MealTrackingLoadMore);
    sleepScrollController.addListener(sleepLogsLoadMore);
    medicationScrollController.addListener(medicationLoadMore);
    scrollController.addListener(loadMore);
    mealTrackingAPI();
    sleepLogsAPI();
    medicationAPI();
    listDiaperAndBathApi();

    tabController!.addListener(() {
      tabIndex.value = tabController!.index;
      if (tabIndex.value == 0) {
        mealTrackingAPI();
      } else if (tabIndex.value == 1) {
        sleepLogsAPI();
      } else if (tabIndex.value == 2) {
        medicationAPI();
      } else if (tabIndex.value == 3) {
        listDiaperAndBathApi();
      } else {
        listDiaperAndBathApi();
      }
      update();
    });
    internetChecker();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    if (internetCheckerSubscription != null) {
      internetCheckerSubscription.cancel();
    }
    super.onClose();
  }

  // Start MealTracking

  var isMealTrackingLoadMoreRunning = false.obs;
  var mealTrackingPage = 1, mealTrackingHasNextPage = true.obs;
  var isMealTrackingLoading = false.obs;
  var studentId;
  List<MealTrackingData> mealTrackingDataList = [];
  ScrollController mealScrollController = ScrollController();

  String formatToDayMonthYear(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  String formatTo12HourTime(String time) {
    try {
      final parsedTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(parsedTime);
    } catch (e) {
      return time;
    }
  }

  mealTrackingAPI({int isLoadMore = 0}) async {
    print('studentId-===================>$studentId');
    if (isLoadMore == 1) {
      isMealTrackingLoadMoreRunning.value = true;
    } else {
      mealTrackingPage = 1;
      isMealTrackingLoading.value = true;
      isMealTrackingLoadMoreRunning.value = false;
      mealTrackingHasNextPage.value = true;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.studentsDetails}?page=$mealTrackingPage&type=menu&student_id=$studentId",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        print('response-===================>$response');

        MealTrackingModel responseData = MealTrackingModel.fromJson(response);
        if (isLoadMore != 1) {
          if (responseData.data != null) {
            mealTrackingDataList = responseData.data ?? [];
          }
        } else {
          if (responseData.data!.isNotEmpty) {
            mealTrackingDataList.addAll(responseData.data ?? []);
            isMealTrackingLoadMoreRunning.value = false;
          } else {
            mealTrackingHasNextPage.value = false;
            isMealTrackingLoadMoreRunning.value = false;
          }
        }
        isMealTrackingLoading.value = false;
        update();
      },
      failureCallback: (status, message) {
        isMealTrackingLoading.value = false;
        isMealTrackingLoadMoreRunning.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isMealTrackingLoading.value = false;
        isMealTrackingLoadMoreRunning.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }

  Future<void> MealTrackingLoadMore() async {
    if (mealTrackingHasNextPage.value &&
        !isMealTrackingLoading.value &&
        !isMealTrackingLoadMoreRunning.value &&
        mealScrollController.position.pixels == mealScrollController.position.maxScrollExtent) {
      isMealTrackingLoadMoreRunning.value = true;
      mealTrackingPage++;
      await mealTrackingAPI(isLoadMore: 1);
    }
  }

  // End MealTracking

  // Start SleepLogs

  var isSleepLogsLoadMoreRunning = false.obs;
  var sleepLogsPage = 1, sleepLogsHasNextPage = true.obs;
  var isSleepLogsLoading = false.obs;
  SleepLogsData? sleepLogsData;
  ScrollController sleepScrollController = ScrollController();

  sleepLogsAPI({int isLoadMore = 0}) async {
    if (isLoadMore == 1) {
      isSleepLogsLoadMoreRunning.value = true;
    } else {
      sleepLogsPage = 1;
      isSleepLogsLoading.value = true;
      isSleepLogsLoadMoreRunning.value = false;
      sleepLogsHasNextPage.value = true;
    }

    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.studentsDetails}?page=$sleepLogsPage&type=sleeplog&student_id=$studentId",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        SleepLogsModel responseData = SleepLogsModel.fromJson(response);
        if (isLoadMore != 1) {
          if (responseData.data != null) {
            sleepLogsData = responseData.data;
          }
        } else {
          if (responseData.data != null) {
            sleepLogsData = responseData.data;
            isSleepLogsLoadMoreRunning.value = false;
          } else {
            sleepLogsHasNextPage.value = false;
            isSleepLogsLoadMoreRunning.value = false;
          }
        }
        isSleepLogsLoading.value = false;
        update();
      },
      failureCallback: (status, message) {
        isSleepLogsLoading.value = false;
        isSleepLogsLoadMoreRunning.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isSleepLogsLoading.value = false;
        isSleepLogsLoadMoreRunning.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }

  Future<void> sleepLogsLoadMore() async {
    if (sleepLogsHasNextPage.value &&
        !isSleepLogsLoading.value &&
        !isSleepLogsLoadMoreRunning.value &&
        sleepScrollController.position.pixels == sleepScrollController.position.maxScrollExtent) {
      isSleepLogsLoadMoreRunning.value = true;
      sleepLogsPage++;
      await sleepLogsAPI(isLoadMore: 1);
    }
  }

  // End SleepLogs

  // Start Medication

  var isMedicationLoadMoreRunning = false.obs;
  var medicationPage = 1, medicationHasNextPage = true.obs;
  var isMedicationLoading = false.obs;
  List<MedicationData> medicationDataList = [];

  ScrollController medicationScrollController = ScrollController();

  medicationAPI({int isLoadMore = 0}) async {
    if (isLoadMore == 1) {
      isMedicationLoadMoreRunning.value = true;
    } else {
      medicationPage = 1;
      isMedicationLoading.value = true;
      isMedicationLoadMoreRunning.value = false;
      medicationHasNextPage.value = true;
    }
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.studentsDetails}?page=$medicationPage&type=medication&student_id=$studentId",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        MedicationModel responseData = MedicationModel.fromJson(response);
        if (isLoadMore != 1) {
          if (responseData.data != null) {
            medicationDataList = responseData.data ?? [];
          }
        } else {
          if (responseData.data!.isNotEmpty) {
            medicationDataList.addAll(responseData.data ?? []);
            isMealTrackingLoadMoreRunning.value = false;
          } else {
            medicationHasNextPage.value = false;
            isMealTrackingLoadMoreRunning.value = false;
          }
        }
        isMedicationLoading.value = false;
        update();
      },
      failureCallback: (status, message) {
        isMedicationLoading.value = false;
        isMedicationLoadMoreRunning.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
        isMedicationLoading.value = false;
        isMedicationLoadMoreRunning.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }

  Future<void> medicationLoadMore() async {
    if (medicationHasNextPage.value &&
        !isMedicationLoading.value &&
        !isMedicationLoadMoreRunning.value &&
        medicationScrollController.position.pixels == medicationScrollController.position.maxScrollExtent) {
      isMedicationLoadMoreRunning.value = true;
      medicationPage++;
      await medicationAPI(isLoadMore: 1);
    }
  }

  // End Medication

  String convertDateTimeFormat(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate).toLocal(); // local timezone ma convert
    String formattedDate = DateFormat('dd MMM, yyyy • hh:mm a').format(dateTime);
    return formattedDate;
  }

  var isLoadMoreRunning = false.obs, hasNextPage = true.obs;
  var page = 1;
  RxBool isLoading = false.obs;
  ScrollController scrollController = ScrollController();
  List<ListStudentsDiaperAndBathData> listDiaperAndBathData = [];

  listDiaperAndBathApi({var LoadMore}) async {
    if (LoadMore != 1) {
      isLoading.value = true;
      page = 1;
    } else {
      isLoadMoreRunning.value = false;
    }

    String baseUrl = "${ApiUrl.listStudentsDiaperAndBath}?page=$page&student_id=$studentId&type=${tabIndex.value == 3 ? 'diaper' : 'bath'}";
    print('baseUrl :-$baseUrl');
    return NetworkClient.getInstance.callApi(
      baseUrl: baseUrl,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        ListStudentsDiaperAndBathModel model = ListStudentsDiaperAndBathModel.fromJson(response);
        if (model.status == 1) {
          if (LoadMore != 1) {
            listDiaperAndBathData = model.data!;
            isLoading.value = false;
          } else {
            isLoadMoreRunning.value = false;
            if (listDiaperAndBathData.isNotEmpty) {
              listDiaperAndBathData.addAll(model.data!);
              isLoading.value = false;
            } else {
              hasNextPage.value = false;
            }
          }
        } else {
          isLoading.value = false;
        }
        update();
      },
      failureCallback: (status, message) {
        isLoading.value = false;
        if (status['message'] != null) {
          toastyInfo.showToast(message: status['message']);
        } else {
          toastyInfo.showToast(message: message);
        }
      },
      timeOutCallback: () {
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
      await listDiaperAndBathApi(LoadMore: 1);
    }
  }

  var internetCheckerSubscription;
  bool isDeviceConnected = true;

  Future<void> internetChecker() async {
    internetCheckerSubscription = Connectivity().onConnectivityChanged.listen((result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected) {
        isMealTrackingLoading.value = true;
        update();
      } else {
        mealTrackingAPI();
        sleepLogsAPI();
        medicationAPI();
        ();
        update();
      }
    });
  }
}
