import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'customToast.dart';

bool isDeviceConnected = false;
bool isAlertSet = false;
var subscription;
var isAppInForeground = AppLifecycleState.resumed;

internetConnectivityChecker() {
  print("result========>");
  subscription = Connectivity().onConnectivityChanged.listen((result) async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    print("result========>$result");
    if (!isDeviceConnected) {
      isAlertSet = true;
      showCustomToast(message: 'You\'re offline! Check your internet connection.', backgroundColor: Colors.red, isError: true);
    } else {
      if (isAlertSet == true) {
        isAlertSet = false;
        showCustomToast(message: "You're back online!", backgroundColor: Colors.green, isError: false);
      }
    }
  });
}

// class InternetChecker {
//   static final Connectivity _connectivity = Connectivity();
//
//   /// Checks if device is connected to the Internet (Wi-Fi or Mobile)
//   static Future<bool> hasInternetConnection() async {
//     final result = await _connectivity.checkConnectivity();
//     return result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
//   }
//
//   /// Listens to Internet changes
//   static Stream<List<ConnectivityResult>> get onConnectionChange => _connectivity.onConnectivityChanged;
// }
