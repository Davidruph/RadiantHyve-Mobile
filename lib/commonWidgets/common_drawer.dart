import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/assignedStudent/views/assigned_student_view.dart';
import 'package:radianthyve_unified/app/modules/childReports/views/child_reports_view.dart';
import 'package:radianthyve_unified/app/modules/classroomData/views/classroom_data_view.dart';
import 'package:radianthyve_unified/app/modules/EmergencyList/views/emergency_list_view.dart';
import 'package:radianthyve_unified/app/modules/certification/views/certification_view.dart';
import 'package:radianthyve_unified/app/modules/home/views/home_view.dart';
import 'package:radianthyve_unified/app/modules/login/views/login_view.dart';
import 'package:radianthyve_unified/app/modules/markAttendance/views/mark_attendance_view.dart';
import 'package:radianthyve_unified/app/modules/mealTracking/views/meal_tracking_view.dart';
import 'package:radianthyve_unified/app/modules/medication/views/medication_view.dart';
import 'package:radianthyve_unified/app/modules/message/views/message_view.dart';
import 'package:radianthyve_unified/app/modules/myLeave/views/my_leave_view.dart';
import 'package:radianthyve_unified/app/modules/parentsList/views/parents_list_view.dart';
import 'package:radianthyve_unified/app/modules/payment/views/payment_view.dart';
import 'package:radianthyve_unified/app/modules/profile/views/profile_view.dart';
import 'package:radianthyve_unified/app/modules/shift/views/shift_view.dart';
import 'package:radianthyve_unified/app/modules/sleepLogs/views/sleep_logs_view.dart';
import 'package:radianthyve_unified/app/modules/staffLeave/views/staff_leave_view.dart';
import 'package:radianthyve_unified/app/modules/staffList/views/staff_list_view.dart';
import 'package:radianthyve_unified/app/modules/studentList/views/student_list_view.dart';
import 'package:radianthyve_unified/app/modules/upcomingBirthday/views/upcoming_birthday_view.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import 'package:radianthyve_unified/utils/roleBasedNavigation.dart';

import '../app/data/api_url.dart';
import '../app/data/dio_client/network_client.dart';
import '../utils/api_custom_toast.dart';
import '../utils/prefsKey.dart';
import 'CachedImageContainer.dart';
import 'constant.dart';

/// Get menu items based on user role
List<Map<String, dynamic>> getDrawerListByRole() {
  final userRole = getUserRole().toLowerCase();
  
  // Common items for all roles
  List<Map<String, dynamic>> commonItems = [
    {
      'icon': icons.home,
      'name': AppMessage.home,
    },
    {
      'icon': icons.message,
      'name': AppMessage.message,
    },
    {
      'icon': icons.profile,
      'name': AppMessage.profile,
    },
  ];
  
  // Role-specific items
  if (userRole == 'parent') {
    return [
      commonItems[0], // Home
      {
        'icon': icons.markAttendanceIcon,
        'name': AppMessage.attendanceStatus,
      },
      {
        'icon': icons.childReportsIcon,
        'name': AppMessage.childReports,
      },
      {
        'icon': icons.paymentIcon,
        'name': AppMessage.payment,
      },
      commonItems[1], // Message
      commonItems[2], // Profile
    ];
  } else if (userRole == 'teacher') {
    return [
      commonItems[0], // Home
      {
        'icon': icons.markAttendanceIcon,
        'name': AppMessage.markAttendance,
      },
      {
        'icon': icons.childReportsIcon,
        'name': AppMessage.childReports,
      },
      {
        'icon': icons.programIcon,
        'name': AppMessage.studentsData,
      },
      {
        'icon': icons.staffLeave,
        'name': AppMessage.myLeave,
      },
      commonItems[1], // Message
      commonItems[2], // Profile
    ];
  } else if (userRole == 'principal' || userRole == 'admin') {
    return [
      commonItems[0], // Home
      {
        'icon': icons.staffList,
        'name': AppMessage.staffList,
      },
      {
        'icon': icons.parentsList,
        'name': AppMessage.parentsList,
      },
      {
        'icon': icons.studentList,
        'name': AppMessage.studentList,
      },
      {
        'icon': icons.staffLeave,
        'name': AppMessage.staffLeave,
      },
      {
        'icon': icons.ProgramIcon,
        'name': AppMessage.program,
      },
      commonItems[1], // Message
      {
        'icon': icons.certification,
        'name': AppMessage.certification,
      },
      {
        'icon': icons.mealTracking,
        'name': AppMessage.mealTracking,
      },
      {
        'icon': icons.sleepLogs,
        'name': AppMessage.sleepLogs,
      },
      {
        'icon': icons.medication,
        'name': AppMessage.medication,
      },
      {
        'icon': icons.paymentIcon,
        'name': AppMessage.payment,
      },
      {
        'icon': icons.upcomingBirthday,
        'name': AppMessage.upcomingBirthday,
      },
      {
        'icon': icons.emergency,
        'name': AppMessage.emergency,
      },
      commonItems[2], // Profile
    ];
  }
  
  // Default to parent menu
  return [
    commonItems[0], // Home
    {
      'icon': icons.markAttendanceIcon,
      'name': AppMessage.attendanceStatus,
    },
    {
      'icon': icons.childReportsIcon,
      'name': AppMessage.childReports,
    },
    {
      'icon': icons.paymentIcon,
      'name': AppMessage.payment,
    },
    commonItems[1], // Message
    commonItems[2], // Profile
  ];
}

class drawer extends StatelessWidget {
   drawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerList = getDrawerListByRole();
    
    return Drawer(
      backgroundColor: Colors.transparent,
      width: MySize.getScaledSizeHeight(334),
      child: Container(
        decoration: BoxDecoration(
          gradient: color.appGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.0.hSpace(),
            Row(
              children: [
                CachedImageContainer(
                  image: '${box.read(PrefsKey.profilePic)}',
                  fit: BoxFit.cover,
                  width: MySize.getScaledSizeHeight(60),
                  height: MySize.getScaledSizeHeight(60),
                  placeHolder: images.appIcon,
                  topCorner: 60,
                  bottomCorner: 60,
                ),
                12.0.wSpace(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonText.medium(text: 'Hello, ${box.read(PrefsKey.fullName)}', fontSize: MySize.getScaledSizeHeight(16), textColor: color.white, maxLines: 1),
                      commonText.regular(text: '${box.read(PrefsKey.emailId) ?? ''}', fontSize: MySize.getScaledSizeHeight(14), textColor: color.white),
                    ],
                  ),
                ),
              ],
            ).paddingAll(MySize.getScaledSizeHeight(16)),
            commonWidget.commonDivider(color: color.containerBackgroundColor),
            34.0.hSpace(),
            Expanded(
              child: ListView.builder(
                itemCount: drawerList.length,
              padding: EdgeInsets.zero,
              shrinkWrap: false,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.back();
                    _handleMenuItemTap(drawerList[index]['name']);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        drawerList[index]['icon'],
                        height: MySize.getScaledSizeHeight(24),
                        width: MySize.getScaledSizeHeight(24),
                        fit: BoxFit.cover,
                      ),
                      12.0.wSpace(),
                      commonText.medium(
                        text: drawerList[index]['name'],
                        fontSize: MySize.getScaledSizeHeight(16),
                        textColor: color.white,
                      ),
                    ],
                  ).paddingOnly(bottom: MySize.getScaledSizeHeight(34)),
                );
              },
            ).paddingOnly(left: MySize.getScaledSizeHeight(16)),
          ),
          24.0.hSpace(),
          commonWidget.commonDivider(color: color.containerBackgroundColor),
          04.0.hSpace(),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(20)),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          commonText.medium(
                            text: AppMessage.logOutOfTheSystem,
                            fontSize: MySize.getScaledSizeHeight(18),
                            textColor: color.black,
                            textAlign: TextAlign.center,
                          ),
                          30.0.hSpace(),
                          ZoomIn(
                            duration: Duration(seconds: 3),
                            child: Image.asset(
                              images.logOutImage,
                              height: MySize.getScaledSizeHeight(80),
                              width: MySize.getScaledSizeWidth(80),
                            ),
                          ),
                          30.0.hSpace(),
                          commonText
                              .medium(
                                text: AppMessage.areYouSureYouWantToLogOut,
                                fontSize: MySize.getScaledSizeHeight(16),
                                textColor: color.black,
                                textAlign: TextAlign.center,
                              )
                              .paddingSymmetric(horizontal: MySize.getScaledSizeHeight(14)),
                          15.0.hSpace(),
                          commonText.regular(
                            text: AppMessage.youWillNeedToLogInAgain,
                            fontSize: MySize.getScaledSizeHeight(16),
                            textColor: color.textFieldTextColor,
                            textAlign: TextAlign.center,
                          ),
                          30.0.hSpace(),
                          Obx(
                                () => commonWidget.customButton(
                              isLoading: isLoading.value,
                              buttonColor: color.textFieldErrorColor,
                              text: AppMessage.yesLogOut,
                              onTap: () {
                                logoutApi();
                              },
                            ),
                          ),
                          16.0.hSpace(),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: MySize.getScaledSizeHeight(52),
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: color.homeTextColor,
                                borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8))),
                              ),
                              child: Center(
                                child: commonText.medium(
                                  text: AppMessage.cancel,
                                  textColor: color.cancelColor,
                                  fontSize: MySize.getScaledSizeHeight(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Row(
              children: [
                Image.asset(
                  icons.logoutIcon,
                  height: MySize.getScaledSizeHeight(24),
                  width: MySize.getScaledSizeWidth(24),
                ),
                12.0.wSpace(),
                commonText.medium(
                  text: AppMessage.logOut,
                  fontSize: MySize.getScaledSizeHeight(16),
                  textColor: color.textFieldErrorColor,
                ),
              ],
            ).paddingAll(MySize.getScaledSizeHeight(16)),
          ),
        ],
      ),
      ),
    );
  }

  RxBool isLoading = false.obs;

  logoutApi() async {
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.logout,
      method: MethodType.post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        if (response['status'] == 1) {
          box.erase();
          Get.offAll(() => LoginView());
          toastyInfo.showToast(message: response['message'], backgroundGradient: color.buttonGradient);
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

  /// Handle menu item tap based on menu item name (role-aware)
  void _handleMenuItemTap(String menuName) {
    if (menuName == AppMessage.home) {
      Get.off(() => HomeView());
    } else if (menuName == AppMessage.markAttendance || menuName == AppMessage.attendanceStatus) {
      Get.off(() => MarkAttendanceView());
    } else if (menuName == AppMessage.childReports) {
      Get.off(() => ChildReportsView());
    } else if (menuName == AppMessage.payment) {
      Get.off(() => PaymentView());
    } else if (menuName == AppMessage.studentsData) {
      // ClassroomData view for teachers
      Get.off(() => ClassroomDataView());
    } else if (menuName == AppMessage.myLeave) {
      Get.off(() => MyLeaveView());
    } else if (menuName == AppMessage.message) {
      Get.off(() => MessageView());
    } else if (menuName == AppMessage.profile) {
      Get.off(() => ProfileView());
    }
    // Principal-specific menu items
    else if (menuName == AppMessage.staffList) {
      Get.off(() => StaffListView());
    } else if (menuName == AppMessage.parentsList) {
      Get.off(() => ParentsListView());
    } else if (menuName == AppMessage.studentList) {
      Get.off(() => StudentListView());
    } else if (menuName == AppMessage.staffLeave) {
      Get.off(() => StaffLeaveView());
    } else if (menuName == AppMessage.program) {
      Get.off(() => ShiftView());
    } else if (menuName == AppMessage.certification) {
      Get.off(() => CertificationView());
    } else if (menuName == AppMessage.mealTracking) {
      Get.off(() => MealTrackingView());
    } else if (menuName == AppMessage.sleepLogs) {
      Get.off(() => SleepLogsView());
    } else if (menuName == AppMessage.medication) {
      Get.off(() => MedicationView());
    } else if (menuName == AppMessage.upcomingBirthday) {
      Get.off(() => UpcomingBirthdayView());
    } else if (menuName == AppMessage.emergency) {
      Get.off(() => EmergencyListView());
    }  }

}