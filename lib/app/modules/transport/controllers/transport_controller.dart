import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/api_url.dart';
import '../../../data/dio_client/network_client.dart';
import '../../../../commonWidgets/connect_socket.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/messages.dart';
import '../../../../utils/prefsKey.dart';
import '../../../../commonWidgets/constant.dart';

class TransportController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ── State ────────────────────────────────────────────────────────────────
  var isLoadingStudents = false.obs;
  var isLoadingStatus = false.obs;

  List<Map<String, dynamic>> studentList = [];
  Map<String, dynamic>? selectedStudent;

  // Active transport
  Map<String, dynamic>? activeTransport;
  Map<String, dynamic>? liveLocation;
  List<Map<String, dynamic>> recentLogs = [];
  List<Map<String, dynamic>> authorizedRecipients = [];

  // Live bus position on map
  LatLng? busPosition;
  DateTime? lastLocationUpdate;

  // Periodic refresh timer
  Timer? _refreshTimer;

  // ── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchStudentList();
    _subscribeToSocket();
    // Poll every 30 s as a fallback if socket event is missed
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (selectedStudent != null) {
        fetchTransportStatus(selectedStudent!['id']);
      }
    });
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    socket?.off(ApiUrl.transportStudentUpdate);
    socket?.off(ApiUrl.transportLocationUpdate);
    socket?.off(ApiUrl.transportRouteUpdate);
    super.onClose();
  }

  // ── Socket ───────────────────────────────────────────────────────────────
  void _subscribeToSocket() {
    socket?.on(ApiUrl.transportStudentUpdate, (data) {
      if (selectedStudent == null) return;
      final Map<String, dynamic> payload = Map<String, dynamic>.from(data ?? {});
      if (payload['student_id'] == null) return;

      // Only update if it's our selected child
      if (activeTransport != null &&
          payload['student_id'].toString() == activeTransport!['student_id']?.toString()) {
        if (payload['pickup_status'] != null) {
          activeTransport!['pickup_status'] = payload['pickup_status'];
        }
        if (payload['current_status'] != null) {
          activeTransport!['current_status'] = payload['current_status'];
        }
        if (payload['dropoff_status'] != null) {
          activeTransport!['dropoff_status'] = payload['dropoff_status'];
        }
        update();
      }
    });

    socket?.on(ApiUrl.transportLocationUpdate, (data) {
      if (selectedStudent == null || activeTransport == null) return;
      final Map<String, dynamic> payload = Map<String, dynamic>.from(data ?? {});
      // Match by route_id
      if (activeTransport!['route_id']?.toString() == payload['route_id']?.toString()) {
        final lat = double.tryParse(payload['latitude']?.toString() ?? '');
        final lng = double.tryParse(payload['longitude']?.toString() ?? '');
        if (lat != null && lng != null) {
          busPosition = LatLng(lat, lng);
          liveLocation = payload;
          lastLocationUpdate = DateTime.now();
          update();
        }
      }
    });

    // When a route is completed/ended, clear the active transport immediately
    // so the parent sees "no active route" instead of stale tracking data.
    socket?.on(ApiUrl.transportRouteUpdate, (data) {
      if (activeTransport == null) return;
      final Map<String, dynamic> payload = Map<String, dynamic>.from(data ?? {});
      final routeId = activeTransport!['route_id']?.toString();
      if (payload['route_id']?.toString() == routeId &&
          payload['status'] == 'completed') {
        activeTransport = null;
        busPosition = null;
        liveLocation = null;
        lastLocationUpdate = null;
        update();
      }
    });
  }

  // ── API calls ─────────────────────────────────────────────────────────────
  void fetchStudentList() {
    isLoadingStudents.value = true;
    NetworkClient.getInstance.callApi(
      baseUrl: '${ApiUrl.studentsList}?page=1',
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        isLoadingStudents.value = false;
        final List rawList = response['data'] ?? [];
        studentList = rawList
            .where((s) => s['request_status'] == 'accepted')
            .map<Map<String, dynamic>>((s) => {
                  'id': s['id']?.toString() ?? '',
                  'full_name': s['full_name'] ?? 'Child',
                })
            .toList();

        if (studentList.isNotEmpty) {
          selectedStudent = studentList.first;
          fetchTransportStatus(selectedStudent!['id']);
        }
        update();
      },
      failureCallback: (status, message) {
        isLoadingStudents.value = false;
        update();
      },
      timeOutCallback: () {
        isLoadingStudents.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }

  void selectStudent(Map<String, dynamic> student) {
    selectedStudent = student;
    activeTransport = null;
    liveLocation = null;
    busPosition = null;
    recentLogs = [];
    authorizedRecipients = [];
    update();
    fetchTransportStatus(student['id']);
  }

  void fetchTransportStatus(String studentId) {
    isLoadingStatus.value = true;
    NetworkClient.getInstance.callApi(
      baseUrl: ApiUrl.studentTransportStatus(studentId),
      method: MethodType.get,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) async {
        isLoadingStatus.value = false;
        final data = response['data'] ?? {};

        activeTransport = data['active_transport'] != null
            ? Map<String, dynamic>.from(data['active_transport'])
            : null;

        liveLocation = data['live_location'] != null
            ? Map<String, dynamic>.from(data['live_location'])
            : null;

        recentLogs = (data['recent_logs'] as List? ?? [])
            .map<Map<String, dynamic>>((l) => Map<String, dynamic>.from(l))
            .toList();

        authorizedRecipients = (data['authorized_recipients'] as List? ?? [])
            .map<Map<String, dynamic>>((r) => Map<String, dynamic>.from(r))
            .toList();

        // Parse bus position from live_location
        if (liveLocation != null) {
          final lat = double.tryParse(liveLocation!['latitude']?.toString() ?? '');
          final lng = double.tryParse(liveLocation!['longitude']?.toString() ?? '');
          if (lat != null && lng != null) {
            busPosition = LatLng(lat, lng);
            lastLocationUpdate = DateTime.tryParse(
                liveLocation!['last_updated']?.toString() ?? '');
          }
        }
        update();
      },
      failureCallback: (status, message) {
        isLoadingStatus.value = false;
        log('Transport status error: $status — $message');
        toastyInfo.showToast(
          message: status['message'] ?? message ?? 'Could not load transport status',
        );
        update();
      },
      timeOutCallback: () {
        isLoadingStatus.value = false;
        toastyInfo.showToast(message: AppMessage.noInternetConnectionFound);
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String get studentCurrentStatus {
    if (activeTransport == null) return 'no_route';
    final current = activeTransport!['current_status'] ?? '';
    final pickup = activeTransport!['pickup_status'] ?? '';
    if (current == 'dropped_off') return 'dropped_off';
    if (pickup == 'picked_up') return 'in_vehicle';
    if (pickup == 'absent') return 'absent';
    if (pickup == 'skipped') return 'skipped';
    return 'awaiting_pickup';
  }

  String get statusLabel {
    switch (studentCurrentStatus) {
      case 'in_vehicle':  return 'In Vehicle — On the way';
      case 'dropped_off': return 'Dropped Off — Arrived safely';
      case 'absent':      return 'Absent at Stop';
      case 'skipped':     return 'Pickup Skipped';
      case 'awaiting_pickup': return 'Awaiting Pickup';
      default:            return 'No Active Route';
    }
  }

  Color get statusColor {
    switch (studentCurrentStatus) {
      case 'in_vehicle':      return const Color(0xFF22C55E);
      case 'dropped_off':     return const Color(0xFF3B82F6);
      case 'absent':          return const Color(0xFFEF4444);
      case 'skipped':         return const Color(0xFFF97316);
      case 'awaiting_pickup': return const Color(0xFFEAB308);
      default:                return const Color(0xFF9CA3AF);
    }
  }

  String get routeName =>
      activeTransport?['route']?['route_name'] ?? '—';

  String get driverName =>
      activeTransport?['route']?['driver']?['full_name'] ?? '—';

  String get vehicleName {
    final v = activeTransport?['route']?['vehicle'];
    if (v == null) return '—';
    final name = v['vehicle_name'] ?? '';
    final plate = v['registration_plate'] ?? '';
    return plate.isNotEmpty ? '$name · $plate' : name;
  }

  String get stopName =>
      activeTransport?['stop']?['stop_name'] ?? '—';

  String get lastUpdatedText {
    if (lastLocationUpdate == null) return '';
    final diff = DateTime.now().difference(lastLocationUpdate!);
    if (diff.inSeconds < 60) return 'Updated ${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return 'Updated ${diff.inMinutes}m ago';
    return 'Updated ${diff.inHours}h ago';
  }

  Color eventTypeColor(String eventType) {
    if (eventType.contains('pickup_completed')) return const Color(0xFF22C55E);
    if (eventType.contains('dropoff')) return const Color(0xFF3B82F6);
    if (eventType.contains('absent')) return const Color(0xFFEF4444);
    if (eventType.contains('skipped')) return const Color(0xFFF97316);
    if (eventType.contains('route_started')) return const Color(0xFF8B5CF6);
    if (eventType.contains('route_ended')) return const Color(0xFF6B7280);
    return const Color(0xFF9CA3AF);
  }

  String eventTypeLabel(String eventType) {
    final map = {
      'route_started': 'Route Started',
      'pickup_completed': 'Picked Up',
      'pickup_absent': 'Absent',
      'pickup_skipped': 'Skipped',
      'dropoff_completed': 'Dropped Off',
      'route_ended': 'Route Ended',
      'final_check': 'Vehicle Check',
    };
    return map[eventType] ?? eventType.replaceAll('_', ' ');
  }
}
