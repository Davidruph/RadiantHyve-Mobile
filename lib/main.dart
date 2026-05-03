import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/transport/views/transport_view.dart';

/// Transport-related notification types sent by the backend
const _transportTypes = {
  'transport_pickup',
  'transport_picked_up',
  'transport_absent',
  'transport_skipped',
  'transport_dropoff',
  'transport_exception_critical',
  'transport_gps_lost',
  'transport_route_delayed',
  'transport_route_completed',
};

/// Navigate to the Route Info screen when parent taps a transport notification
void _handleTransportNotificationTap(RemoteMessage message) {
  final type = message.data['notification_type'] ?? '';
  if (_transportTypes.contains(type)) {
    // Use Get.to so it works from any screen state
    Get.to(() => const TransportView());
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

  // App opened from a terminated state via notification tap
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // Defer navigation until the app has fully started
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleTransportNotificationTap(initialMessage);
    });
  }

  // App was in background and user tapped a notification
  FirebaseMessaging.onMessageOpenedApp.listen(_handleTransportNotificationTap);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GetStorage.init();
  runApp(
    GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      title: "RadiantHyve",
      theme: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
