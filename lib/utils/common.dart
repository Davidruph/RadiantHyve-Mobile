import 'dart:io';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:radianthyve_unified/utils/prefsKey.dart';

import '../app/modules/login/model/loginModel.dart';
import '../commonWidgets/constant.dart';

CommonMethod commonMethod = CommonMethod();

class CommonMethod {
  Future<String> getDeviceToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? deviceToken = "";
      deviceToken = await messaging.getToken();
      log("deviceToken :- ${deviceToken}");
      return deviceToken ?? "no_token";
    } catch (e) {
      log("Error getting device token: $e");
      return "no_token";
    }
  }

  Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    var deviceId;
    if (Platform.isIOS) {
      deviceId = await FlutterUdid.udid;
      log("deviceId :- ${deviceId}");
      return deviceId;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id;
      return deviceId;
    }
  }

  storeUserData(LoginModel responseData) async {
    if (responseData.token != null && responseData.token!.isNotEmpty) {
      box.write(PrefsKey.userToken, responseData.token);
    }
    if (responseData.refreshToken != null && responseData.refreshToken!.isNotEmpty) {
      box.write(PrefsKey.refreshToken, responseData.refreshToken);
    }
    box.write(PrefsKey.userId, responseData.data!.id);
    box.write(PrefsKey.emailId, responseData.data!.email);
    box.write(PrefsKey.isoCode, responseData.data!.isoCode);
    box.write(PrefsKey.countryCode, responseData.data!.countryCode);
    box.write(PrefsKey.mobileNo, responseData.data!.mobileNo);
    box.write(PrefsKey.fullName, responseData.data!.fullName);
    box.write(PrefsKey.profilePic, responseData.data!.profilePic);
    box.write(PrefsKey.loginType, responseData.data!.loginType);
    box.write(PrefsKey.dob, responseData.data!.dob);
    box.write(PrefsKey.role, responseData.data!.role);
    box.write(PrefsKey.gender, responseData.data!.gender);
    box.write(PrefsKey.joiningDate, responseData.data!.joiningDate);
    box.write(PrefsKey.experience, responseData.data!.experience);
    box.write(PrefsKey.aboutStaff, responseData.data!.aboutStaff);
    box.write(PrefsKey.aboutStaff, responseData.data!.address);
    box.write(PrefsKey.tokenId, responseData.tokenId);
  }

  String convertDateFormat(String dateString) {
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } catch (e) {
      return dateString;
    }
  }

  String convertToTime(String dateString) {
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      String hour = dateTime.hour.toString().padLeft(2, '0');
      String minute = dateTime.minute.toString().padLeft(2, '0');
      return "$hour:$minute";
    } catch (e) {
      return dateString;
    }
  }
}

// Utility functions for date formatting
String convertDateFormat(String dateString) {
  try {
    final DateTime dateTime = DateTime.parse(dateString);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  } catch (e) {
    return dateString;
  }
}

String convertDateTimeFormat(String dateString) {
  try {
    final DateTime dateTime = DateTime.parse(dateString);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  } catch (e) {
    return dateString;
  }
}

String convertToTime(String dateString) {
  try {
    final DateTime dateTime = DateTime.parse(dateString);
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  } catch (e) {
    return dateString;
  }
}

String convertToMMMddYYYY(String dateString) {
  try {
    final DateTime dateTime = DateTime.parse(dateString);
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}";
  } catch (e) {
    return dateString;
  }
}

// DateTime extension for formatting
extension DateTimeFormatter on DateTime {
  String convertDateTimeFormatExt() {
    return "${this.day}/${this.month}/${this.year}";
  }

  String convertToMMMddYYYYExt() {
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[this.month - 1]} ${this.day}, ${this.year}";
  }

  String convertToTimeOnly() {
    String hour = this.hour.toString().padLeft(2, '0');
    String minute = this.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}
