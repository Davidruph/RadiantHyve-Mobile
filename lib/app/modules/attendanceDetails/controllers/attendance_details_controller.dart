import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../model/GetAttendanceModel.dart';

class AttendanceDetailsController extends GetxController {
  RxBool isLoading = false.obs;
  var attendanceId;

  String getDuration(String clockIn, String clockOut) {
    DateTime inTime = DateTime.parse(clockIn).toLocal();
    DateTime outTime = DateTime.parse(clockOut).toLocal();
    Duration diff = outTime.difference(inTime);

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(diff.inHours)}:${twoDigits(diff.inMinutes % 60)}:${twoDigits(diff.inSeconds % 60)}';
  }

  @override
  void onInit() {
    if (Get.arguments != null) {
      attendanceId = Get.arguments['attendanceId'];
      getAttendanceApi();
    }
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

  String formatReadableDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('d MMMM, yyyy').format(date); // e.g., 12 June, 2025
  }

  String formatClockInTime(String utcTime) {
    DateTime utcDateTime = DateTime.parse(utcTime);
    DateTime localDateTime = utcDateTime.toLocal(); // Optional: Convert to local timezone
    return DateFormat('hh:mm a').format(localDateTime); // Example: "08:00 AM"
  }

  GetAttendanceData? getAttendanceData;

  getAttendanceApi() async {
    isLoading.value = true;
    return NetworkClient.getInstance.callApi(
      baseUrl: "${ApiUrl.getAttendance}/?attendance_id=$attendanceId",
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        GetAttendanceModel attendanceModel = GetAttendanceModel.fromJson(response);
        if (attendanceModel.status == 1) {
          getAttendanceData = attendanceModel.data!;
        }
        isLoading.value = false;
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
}
