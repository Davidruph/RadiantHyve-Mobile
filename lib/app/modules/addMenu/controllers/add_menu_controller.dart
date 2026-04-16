import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../mealInformation/model/GetMenuModel.dart';
import '../model/TeacherAllStudentModel.dart';

class AddMenuController extends GetxController {
  /// Date
  TextEditingController dateController = TextEditingController();
  var isSelect = 0.obs;
  DateTime? birthDate;
  var date = ''.obs;
  var errorDate = ''.obs;

  /// Time
  TextEditingController timeController = TextEditingController();
  var errorTime = ''.obs;
  RxString menuTimeForApi = ''.obs;

  /// About meal
  TextEditingController aboutMealController = TextEditingController();
  var errorAboutMeal = ''.obs;


  Future<void> dateOfBirthCalendar(BuildContext context) async {
    DateTime now = DateTime.now();

    birthDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      // Only allow today or future
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: color.appColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: color.appColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (birthDate != null) {
      dateController.text = DateFormat("yyyy-MM-dd").format(birthDate!);
      errorDate.value = '';
      update();
    } else {
      errorDate.value = 'Please select a valid future date';
      update();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay initialTime;
    if (menuTimeForApi.value.isNotEmpty) {
      try {
        final parts = menuTimeForApi.value.split(":");
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        initialTime = TimeOfDay(hour: hour, minute: minute);
      } catch (e) {
        initialTime = TimeOfDay.now();
      }
    } else {
      initialTime = TimeOfDay.now();
    }

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: color.appColor,
            hintColor: color.appColor,
            colorScheme: ColorScheme.light(primary: color.appColor, onPrimary: color.white, onSurface: color.black),
            timePickerTheme: TimePickerThemeData(
              dayPeriodColor: color.appColor,
              dayPeriodTextColor: color.black,
              dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: color.white)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      final now = DateTime.now().subtract(Duration(minutes: 1));
      final selectedDate = birthDate;
      if (selectedDate == null) {
        errorTime.value = 'Please select a date first';
        return;
      }
      final selectedDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, pickedTime.hour, pickedTime.minute);
      final isToday = selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day;

      if (isToday && selectedDateTime.isBefore(now)) {
        errorTime.value = 'Please select a future time';
        timeController.clear();
        return;
      }
      timeController.text = pickedTime.format(context);
      final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      final formattedApiTime = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      menuTimeForApi.value = formattedApiTime;
      errorTime.value = '';
    } else {
      if (timeController.text.isEmpty) {
        errorTime.value = 'Please select a time';
      }
    }
  }

  List weeklyScheduleList = [
    {'day': 'Mon', 'isSelect': false},
    {'day': 'Tue', 'isSelect': false},
    {'day': 'Wed', 'isSelect': false},
    {'day': 'Thu', 'isSelect': false},
    {'day': 'Fri', 'isSelect': false},
    {'day': 'Sat', 'isSelect': false},
    {'day': 'Sun', 'isSelect': false},
  ];

  var errorDay = ''.obs;

  final TextEditingController mealController = TextEditingController();
  final List<String> mealOptions = ["Breakfast", "AM Snack", "Lunch", "PM Snack", "Dinner", "Last Snack"];

  List<String> getSuggestions(String query) {
    return mealOptions.where((meal) => meal.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void selectMeal(String meal) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    mealController.text = meal;
    update();
  }

  var errorMeal = ''.obs;

  var isChecked = false;

  var errorStudent = ''.obs;
  final TextEditingController studentListController = TextEditingController();

  List<TeacherAllStudentData> getSuggestionsStudent(String query) {
    return getBookingsUserDataList.where((student) => student.fullName.contains(query.toLowerCase())).toList();
  }

  var selectStudentId;

  void selectStudent(String student) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    studentListController.text = student;
    update();
  }

  var flag, menuId;
  GetMenuData? getMenuData;

  String formatTimeTo12Hour(String time24) {
    try {
      final DateTime dateTime = DateFormat("HH:mm:ss").parse(time24);
      final String formattedTime = DateFormat("hh:mm a").format(dateTime);
      return formattedTime;
    } catch (e) {
      return '';
    }
  }

  String formatTimeTo24Hour(String timeWithSeconds) {
    try {
      final dateTime = DateFormat("HH:mm:ss").parse(timeWithSeconds);
      return DateFormat("HH:mm").format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  void onInit() {
    teacherAllStudentApi();
    super.onInit();
    if (Get.arguments != null) {
      flag = Get.arguments['flag'];
      menuId = Get.arguments['menuId'];
      getMenuData = Get.arguments['getMenuData'];
      if (flag == 'editMenu') {
        mealController.text = getMenuData?.menuType;
        dateController.text = getMenuData?.menuDate;

        birthDate = DateTime.tryParse(dateController.text);

        timeController.text = formatTimeTo12Hour(getMenuData?.menuTime); // UI
        menuTimeForApi.value = formatTimeTo24Hour(getMenuData?.menuTime ?? ''); // API
        aboutMealController.text = getMenuData?.aboutMeal;
        studentListController.text = getMenuData?.student?.fullName ?? '';
        isChecked = getMenuData!.isAll!;
        selectStudentId = getMenuData!.student?.id;
        final apiDaySet = getMenuData?.menuDay?.map((e) => e.menuDay?.toLowerCase() ?? '').toSet() ?? {};
        weeklyScheduleList =
            weeklyScheduleList.map((item) {
              final day = item['day'].toString().toLowerCase();
              return {'day': item['day'], 'isSelect': apiDaySet.contains(day)};
            }).toList();
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool isValidation() {
    errorDate.value = '';
    errorTime.value = '';
    errorAboutMeal.value = '';
    errorDay.value = '';
    errorMeal.value = '';
    errorStudent.value = '';

    bool isValid = true;

    if (mealController.text.trim().isEmpty) {
      errorMeal.value = AppMessage.pleaseSelectMeal;
      isValid = false;
    }
    if (dateController.text.trim().isEmpty) {
      errorDate.value = AppMessage.pleaseSelectYourDate;
      isValid = false;
    }
    if (timeController.text.trim().isEmpty) {
      errorTime.value = AppMessage.pleaseSelectYourTime;
      isValid = false;
    }
    if (aboutMealController.text.trim().isEmpty) {
      errorAboutMeal.value = AppMessage.pleaseEnterAboutMeal;
      isValid = false;
    }
    if (!weeklyScheduleList.any((day) => day['isSelect'] == true)) {
      errorDay.value = AppMessage.pleaseSelectYourWeeklySchedule;
      isValid = false;
    }

    if (!isChecked && studentListController.text.trim().isEmpty) {
      errorStudent.value = "Please select a student.";
      isValid = false;
    }

    return isValid;
  }


  RxBool isLoading = false.obs;

  setMealFromJson(String menuType) {
    if (mealOptions.contains(menuType)) {
      mealController.text = menuType;
      update();
    } else {}
  }

  addMenuApi() async {
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    List<String> selectedMenuDays =
        weeklyScheduleList.where((item) => item['isSelect'] == true).map((item) => item['day'].toString().toLowerCase()).toList();
    final param = {
      "menu_type": mealController.text.trim(),
      "menu_days": selectedMenuDays,
      "menu_date": dateController.text,
      "menu_time": menuTimeForApi.value,
      "about_meal": aboutMealController.text,
      if (isChecked == false) "student_id": selectStudentId,
      "is_all": isChecked,
    };
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.addMenu,
      method: MethodType.post,
      params: param,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back(result: 1);
        } else {
          isLoading.value = false;
        }
        isLoading.value = false;
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

  editMenuApi() async {
    isLoading.value = true;
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      isLoading.value = false;
    }
    List<String> selectedMenuDays =
        weeklyScheduleList.where((item) => item['isSelect'] == true).map((item) => item['day'].toString().toLowerCase()).toList();
    final param = {
      "menu_id": menuId,
      "menu_type": mealController.text.trim(),
      "menu_days": selectedMenuDays,
      "menu_date": dateController.text,
      "menu_time": menuTimeForApi.value,
      "about_meal": aboutMealController.text,
      if (isChecked == false) "student_id": selectStudentId,
      "is_all": isChecked,
    };
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.editMenu,
      method: MethodType.put,
      params: param,
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          Get.back(result: 1);
          Get.back(result: 1);
        } else {
          isLoading.value = false;
        }
        isLoading.value = false;
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

  List<TeacherAllStudentData> getBookingsUserDataList = [];

  teacherAllStudentApi() async {
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.teacherAllStudent,
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        TeacherAllStudentModel teacherAllStudentModel = TeacherAllStudentModel.fromJson(response);
        if (teacherAllStudentModel.status == 1) {
          getBookingsUserDataList = teacherAllStudentModel.data!;
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
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }
}
