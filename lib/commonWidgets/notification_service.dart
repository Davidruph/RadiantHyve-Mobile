import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/parentsReminder/views/parents_reminder_view.dart';
import 'package:permission_handler/permission_handler.dart';
import '../app/modules/attendanceDetails/views/attendance_details_view.dart';
import '../app/modules/chat/views/chat_view.dart';
import '../app/modules/markAttendance/views/mark_attendance_view.dart';
import '../app/modules/message/controllers/message_controller.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

NotificationServices notificationService = NotificationServices();

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<bool> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      PermissionStatus status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> getNotification() async {
    // Request notification permission
    bool permissionGranted = await requestNotificationPermission();
    if (!permissionGranted) {
      return;
    }

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = const InitializationSettings(iOS: initializationSettingsIOS, android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AppleNotification? ios = message.notification?.apple;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          payload: jsonEncode(message.data),
          const NotificationDetails(
            android: AndroidNotificationDetails('1', 'Kleano Provider', channelDescription: "Kleano Provider", icon: '@mipmap/ic_launcher'),
          ),
        );
      }
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      notificationRouting(data: message.data);
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        notificationRouting(data: message.data);
      }
    });
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    Map<String, dynamic> decodePayload = json.decode(notificationResponse.payload!);
    notificationRouting(data: decodePayload);
  }

  notificationRouting({required Map<String, dynamic> data}) async {
    log("notificationRouting==>${data}");
    if (data["notification_type"] == "chat") {
      Get.to(
        () => ChatView(),
        arguments: {'chatId': data["chat_id"], 'profilePic': data["profile_image"], 'fullName': data["test"], 'otherID': data["user_id"]},
      )?.then((value) {
        MessageController controller = Get.find();
        controller.getPersonalChatsDataList[0].unreadMessagesCount = 0;
        controller.update();
      });
    } else if (data["notification_type"] == "By_admin") {
      Get.to(() => ParentsReminderView(), arguments: {'title': data["title"], 'body': data["body"]})?.then((value) {
        MessageController controller = Get.find();
        controller.getPersonalChatsDataList[0].unreadMessagesCount = 0;
        controller.update();
      });
    } else if (data["notification_type"] == "student_attendance") {
      Get.offAll(() => MarkAttendanceView());
    }
  }
}
