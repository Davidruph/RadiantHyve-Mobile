import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../sleepLogs/model/ListSleepLoagStudentModel.dart';

class SleepLogsDetailsController extends GetxController {
  var isLoading = false.obs;
  ListSleepLogsStudentData? listSleepLogsStudentData;

  String formatTimeTo12Hour(String time24) {
    try {
      final DateTime dt = DateFormat("HH:mm:ss").parse(time24);
      return DateFormat("hh:mm a").format(dt);
    } catch (e) {
      return time24;
    }
  }

  @override
  void onInit() {
    if (Get.arguments != null) {
      listSleepLogsStudentData = Get.arguments['sleepLogsData'];
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
}
