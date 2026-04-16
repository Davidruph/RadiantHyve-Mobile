import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/route_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../commonWidgets/constant.dart';
import '../../../utils/api_custom_toast.dart';
import '../../../utils/prefsKey.dart';
import '../../modules/login/views/login_view.dart';
import '../api_url.dart';

class MethodType {
  static const String post = "POST";
  static const String get = "GET";
  static const String put = "PUT";
  static const String delete = "DELETE";
  static const String patch = "PATCH";
}

class NetworkClient {
  static NetworkClient? shared;

  NetworkClient._();

  static NetworkClient get getInstance => shared = shared ?? NetworkClient._();

  Dio dio = Dio();

  Map<String, dynamic> getAuthHeaders({String? tokenRegister}) {
    Map<String, dynamic> authHeaders = <String, dynamic>{};
    String token = "";
    if (box.read(PrefsKey.userToken) != null) {
      token = box.read(PrefsKey.userToken);
      log('UserToken -----> $token');
    }
    if (tokenRegister != null) {
      dio.options.headers["Authorization"] = "Bearer $tokenRegister";
    } else {
      if (!isNullEmptyOrFalse(token)) {
        dio.options.headers["Authorization"] = "Bearer $token";
      } else {
        authHeaders["Content-Type"] = "application/json";
      }
    }
    return authHeaders;
  }

  Future callApi({
    required String baseUrl,
    required String method,
    var params,
    Map<String, dynamic>? headers,
    Function(dynamic response, String message)? successCallback,
    Function(dynamic message, String statusCode)? failureCallback,
    Function()? timeOutCallback,
  }) async {
    bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      toastyInfo.showToast(message: "You're offline! Check your internet connection.");
      return;
    }

    dio.options.validateStatus = (status) {
      return true;
    };
    dio.options.connectTimeout = const Duration(seconds: 40); //5s
    dio.options.receiveTimeout = const Duration(seconds: 40);

    if (headers != null) {
      for (var key in headers.keys) {
        dio.options.headers[key] = headers[key];
      }
    }

    switch (method) {
      case MethodType.post:
        try {
          Response response = await dio.post(baseUrl, data: params, options: Options(headers: {'Content-Type': 'application/json'}));
          parseResponse(response, successCallback: successCallback!, failureCallback: failureCallback!);
        } on DioError catch (e) {
          if (kDebugMode) {
            // print("Network Client Function: $e");
          }

          if (e.type == DioExceptionType.connectionError) {
            timeOutCallback!();
          } else {
            failureCallback!('', '$e');
          }
        }

        break;
      case MethodType.patch:
        Response response = await dio.patch(baseUrl, data: params);
        parseResponse(response, successCallback: successCallback!, failureCallback: failureCallback!);
        log('baseUrl :- $baseUrl');
        break;
      case MethodType.get:
        try {
          Response response = await dio.get(baseUrl, queryParameters: params, options: Options(headers: {'Content-Type': 'application/json'}));
          parseResponse(response, successCallback: successCallback!, failureCallback: failureCallback!);
        } on DioError catch (e) {
          if (e.type == DioExceptionType.connectionError) {
            timeOutCallback!();
          } else {
            failureCallback!('', '$e');
          }
          print(e.toString());
        }
        break;
      case MethodType.put:
        try {
          Response response = await dio.put(baseUrl, data: params, options: Options(headers: {'Content-Type': 'application/json'}));
          parseResponse(response, successCallback: successCallback!, failureCallback: failureCallback!);
          log('baseUrl :- $baseUrl');
        } on DioError catch (e) {
          if (kDebugMode) {
            print("Network Client Function: $e");
          }
          if (e.type == DioExceptionType.connectionError) {
            timeOutCallback!();
          } else {
            failureCallback!('', '$e');
          }
        }
        break;

      case MethodType.delete:
        try {
          Response response = await dio.delete(baseUrl, data: params, options: Options(headers: {'Content-Type': 'application/json'}));
          log('baseUrl :- $baseUrl');
          parseResponse(response, successCallback: successCallback!, failureCallback: failureCallback!);
        } on DioError catch (e) {
          if (kDebugMode) {
            // print("Network Client Function: $e");
          }

          if (e.type == DioExceptionType.connectionError) {
            timeOutCallback!();
          } else {
            failureCallback!('', '$e');
          }
        }
        break;

      default:
    }
  }

  parseResponse(
    Response response, {
    Function(dynamic response, String message)? successCallback,
    Function(dynamic statusCode, String message)? failureCallback,
  }) async {
    String message = "response.data['message']";
    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202 || response.statusCode == 203) {
      if (isNullEmptyOrFalse(response.data)) {
        successCallback!(response.statusCode, message);
        return;
      }
      if (response.data is Map<String, dynamic> || response.data is List<dynamic>) {
        successCallback!(response.data, message);
        return;
      } else if (response.data is List<Map<String, dynamic>>) {
        successCallback!(response.data, response.statusMessage.toString());
        return;
      } else {
        failureCallback!(response.data, response.statusMessage.toString());
        return;
      }
    } else {
      if (response.statusCode == 401) {
        await refreshToken();

        log("runtimeType---->${response.statusMessage}");
        log("statusCode---->${response.statusCode}");

        toastyInfo.showToast(message: "you are unauthorized");
      } else {
        failureCallback!(response.data, response.statusMessage.toString());
      }
      return;
    }
  }

  refreshToken() async {
    String refreshToken = "";
    if (box.read(PrefsKey.refreshToken) != null) {
      refreshToken = box.read(PrefsKey.refreshToken);
    }
    if (refreshToken.isEmpty) return;

    try {
      final response = await dio.get(
        ApiUrl.createToken,
        queryParameters: {"refresh_token": refreshToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        final newAccessToken = response.data['token'];
        if (newAccessToken != null) {
          box.write(PrefsKey.userToken, newAccessToken);
          dio.options.headers["Authorization"] = "Bearer $newAccessToken";
          return true;
        }
        return true;
      } else {
        log("else response----$response");
        toastyInfo.showToast(message: "${response.statusMessage}");
        box.erase();
        Get.offAll(() => LoginView());
      }
      return false;
    } catch (e) {
      log("else else response----$e");
      box.erase();
      return false;
    }
  }
}

bool isNullEmptyOrFalse(dynamic data) {
  if (data is Map<String, dynamic> || data is List<dynamic>) {
    return data == null || data.length == 0;
  }
  return data == null || false == data || "" == data;
}
