import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../../commonWidgets/common_drawer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/commonSizebox.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../controllers/transport_controller.dart';

class TransportView extends GetView<TransportController> {
  const TransportView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransportController>(
      init: TransportController(),
      assignId: true,
      builder: (ctrl) {
        return Scaffold(
          key: ctrl.scaffoldKey,
          backgroundColor: color.backgroundColor,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.light,
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: color.appGradient),
            ),
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: EdgeInsets.only(left: MySize.getScaledSizeHeight(15)),
              child: InkWell(
                onTap: () => ctrl.scaffoldKey.currentState?.openDrawer(),
                child: Icon(Icons.menu, color: Colors.white,
                    size: MySize.getScaledSizeHeight(28)),
              ),
            ),
            title: commonText.medium(
              text: AppMessage.routeInfo,
              fontSize: MySize.getScaledSizeHeight(18),
              textColor: color.white,
            ),
            centerTitle: false,
          ),
          drawer: drawer(),
          body: Obx(() {
            if (ctrl.isLoadingStudents.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (ctrl.studentList.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(MySize.getScaledSizeHeight(24)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_bus_outlined,
                          size: 64, color: Colors.grey[400]),
                      MySize.getScaledSizeHeight(16).hSpace(),
                      commonText.medium(
                        text: 'No children found',
                        fontSize: MySize.getScaledSizeHeight(16),
                        textColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                if (ctrl.selectedStudent != null) {
                  ctrl.fetchTransportStatus(ctrl.selectedStudent!['id']);
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Child selector ──────────────────────────────────────
                    _buildChildSelector(ctrl),
                    MySize.getScaledSizeHeight(16).hSpace(),

                    // ── Loading state ───────────────────────────────────────
                    if (ctrl.isLoadingStatus.value)
                      const Center(
                          child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: CircularProgressIndicator(),
                      ))
                    else ...[
                      // ── Status card ─────────────────────────────────────
                      _buildStatusCard(ctrl),
                      MySize.getScaledSizeHeight(16).hSpace(),

                      // ── Map / GPS pending ─────────────────────────────────
                      if (ctrl.activeTransport != null) ...[
                        ctrl.busPosition != null
                            ? _buildMapCard(ctrl)
                            : _buildGpsPendingCard(ctrl),
                        MySize.getScaledSizeHeight(16).hSpace(),
                      ],

                      // ── Route details ─────────────────────────────────────
                      if (ctrl.activeTransport != null) ...[
                        _buildRouteDetailsCard(ctrl),
                        MySize.getScaledSizeHeight(16).hSpace(),
                      ],

                      // ── Authorized recipients ───────────────────────────
                      if (ctrl.authorizedRecipients.isNotEmpty)
                        _buildRecipientsCard(ctrl),

                      if (ctrl.authorizedRecipients.isNotEmpty)
                        MySize.getScaledSizeHeight(16).hSpace(),

                      // ── Recent activity ─────────────────────────────────
                      if (ctrl.recentLogs.isNotEmpty) _buildActivityCard(ctrl),
                    ],
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // ── Child selector ────────────────────────────────────────────────────────
  Widget _buildChildSelector(TransportController ctrl) {
    if (ctrl.studentList.length == 1) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: MySize.getScaledSizeHeight(16),
          vertical: MySize.getScaledSizeHeight(12),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: MySize.getScaledSizeHeight(18),
              backgroundColor: color.appColor.withOpacity(0.15),
              child: Icon(Icons.child_care,
                  color: color.appColor,
                  size: MySize.getScaledSizeHeight(18)),
            ),
            MySize.getScaledSizeHeight(12).wSpace(),
            commonText.medium(
              text: ctrl.studentList.first['full_name'] ?? '',
              fontSize: MySize.getScaledSizeHeight(16),
              textColor: color.black,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(12)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      padding: EdgeInsets.symmetric(
          horizontal: MySize.getScaledSizeHeight(16),
          vertical: MySize.getScaledSizeHeight(4)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: ctrl.selectedStudent?['id'],
          isExpanded: true,
          icon: Icon(Icons.expand_more, color: color.appColor),
          items: ctrl.studentList.map((s) {
            return DropdownMenuItem<String>(
              value: s['id'],
              child: Row(
                children: [
                  CircleAvatar(
                    radius: MySize.getScaledSizeHeight(14),
                    backgroundColor: color.appColor.withOpacity(0.15),
                    child: Icon(Icons.child_care,
                        color: color.appColor,
                        size: MySize.getScaledSizeHeight(14)),
                  ),
                  MySize.getScaledSizeHeight(10).wSpace(),
                  commonText.medium(
                    text: s['full_name'] ?? '',
                    fontSize: MySize.getScaledSizeHeight(15),
                    textColor: color.black,
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (id) {
            final student = ctrl.studentList.firstWhere((s) => s['id'] == id);
            ctrl.selectStudent(student);
          },
        ),
      ),
    );
  }

  // ── Status card ───────────────────────────────────────────────────────────
  Widget _buildStatusCard(TransportController ctrl) {
    final bool hasRoute = ctrl.activeTransport != null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
      decoration: BoxDecoration(
        color: hasRoute ? ctrl.statusColor.withOpacity(0.08) : Colors.grey[50],
        borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(16)),
        border: Border.all(
          color: hasRoute
              ? ctrl.statusColor.withOpacity(0.3)
              : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(12)),
            decoration: BoxDecoration(
              color: hasRoute
                  ? ctrl.statusColor.withOpacity(0.15)
                  : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              _statusIcon(ctrl.studentCurrentStatus),
              color: hasRoute ? ctrl.statusColor : Colors.grey[400],
              size: MySize.getScaledSizeHeight(28),
            ),
          ),
          MySize.getScaledSizeHeight(16).wSpace(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText.medium(
                  text: ctrl.statusLabel,
                  fontSize: MySize.getScaledSizeHeight(16),
                  textColor:
                      hasRoute ? ctrl.statusColor : Colors.grey[600]!,
                ),
                if (ctrl.lastUpdatedText.isNotEmpty) ...[
                  MySize.getScaledSizeHeight(4).hSpace(),
                  Row(
                    children: [
                      Icon(Icons.circle,
                          size: 8,
                          color: ctrl.statusColor.withOpacity(0.7)),
                      MySize.getScaledSizeHeight(4).wSpace(),
                      commonText.regular(
                        text: 'Live · ${ctrl.lastUpdatedText}',
                        fontSize: MySize.getScaledSizeHeight(12),
                        textColor: ctrl.statusColor.withOpacity(0.7),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'in_vehicle':      return Icons.directions_bus;
      case 'dropped_off':     return Icons.home;
      case 'absent':          return Icons.person_off;
      case 'skipped':         return Icons.skip_next;
      case 'awaiting_pickup': return Icons.access_time;
      default:                return Icons.directions_bus_outlined;
    }
  }

  // ── GPS pending card — shown when route is active but no location yet ────
  Widget _buildGpsPendingCard(TransportController ctrl) {
    return _card(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(12)),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_searching,
              color: Colors.orange[700],
              size: MySize.getScaledSizeHeight(24),
            ),
          ),
          MySize.getScaledSizeHeight(16).wSpace(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText.medium(
                  text: 'Waiting for Live Location',
                  fontSize: MySize.getScaledSizeHeight(14),
                  textColor: Colors.orange[800]!,
                ),
                MySize.getScaledSizeHeight(4).hSpace(),
                commonText.regular(
                  text: 'The bus location will appear here once the driver\'s GPS is active.',
                  fontSize: MySize.getScaledSizeHeight(12),
                  textColor: Colors.grey[600]!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Map card ──────────────────────────────────────────────────────────────
  Widget _buildMapCard(TransportController ctrl) {
    return Container(
      height: MySize.getScaledSizeHeight(220),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(16)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: ctrl.busPosition!,
              initialZoom: 15,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'radianthyve_unified',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: ctrl.busPosition!,
                    width: MySize.getScaledSizeHeight(48),
                    height: MySize.getScaledSizeHeight(48),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6)
                        ],
                      ),
                      child: Icon(
                        Icons.directions_bus,
                        color: color.appColor,
                        size: MySize.getScaledSizeHeight(28),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // "Live" badge
          Positioned(
            top: MySize.getScaledSizeHeight(10),
            right: MySize.getScaledSizeHeight(10),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MySize.getScaledSizeHeight(10),
                vertical: MySize.getScaledSizeHeight(4),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(MySize.getScaledSizeHeight(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1), blurRadius: 4)
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                  ),
                  MySize.getScaledSizeHeight(4).wSpace(),
                  commonText.medium(
                    text: 'Live',
                    fontSize: MySize.getScaledSizeHeight(12),
                    textColor: const Color(0xFF22C55E),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Route details card ────────────────────────────────────────────────────
  Widget _buildRouteDetailsCard(TransportController ctrl) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Route Details', Icons.route),
          MySize.getScaledSizeHeight(12).hSpace(),
          _detailRow(Icons.map_outlined, 'Route', ctrl.routeName),
          MySize.getScaledSizeHeight(8).hSpace(),
          _detailRow(Icons.person_outline, 'Driver', ctrl.driverName),
          MySize.getScaledSizeHeight(8).hSpace(),
          _detailRow(Icons.directions_bus_outlined, 'Vehicle', ctrl.vehicleName),
          MySize.getScaledSizeHeight(8).hSpace(),
          _detailRow(Icons.location_on_outlined, 'Your Stop', ctrl.stopName),
        ],
      ),
    );
  }

  // ── Authorized recipients ─────────────────────────────────────────────────
  Widget _buildRecipientsCard(TransportController ctrl) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Authorized Recipients', Icons.people_outline),
          MySize.getScaledSizeHeight(12).hSpace(),
          ...ctrl.authorizedRecipients.map((r) {
            final name = r['recipient_name'] ?? '';
            final relationship = r['relationship_to_student'] ?? '';
            final phone = r['recipient_phone'] ?? '';
            final isPrimary = r['is_primary'] == true;

            return Padding(
              padding: EdgeInsets.only(bottom: MySize.getScaledSizeHeight(10)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: MySize.getScaledSizeHeight(18),
                    backgroundColor: color.appColor.withOpacity(0.1),
                    child: Icon(Icons.person,
                        color: color.appColor,
                        size: MySize.getScaledSizeHeight(18)),
                  ),
                  MySize.getScaledSizeHeight(12).wSpace(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            commonText.medium(
                              text: name,
                              fontSize: MySize.getScaledSizeHeight(14),
                              textColor: color.black,
                            ),
                            if (isPrimary) ...[
                              MySize.getScaledSizeHeight(6).wSpace(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: MySize.getScaledSizeHeight(6),
                                  vertical: MySize.getScaledSizeHeight(2),
                                ),
                                decoration: BoxDecoration(
                                  color: color.appColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                      MySize.getScaledSizeHeight(4)),
                                ),
                                child: commonText.regular(
                                  text: 'Primary',
                                  fontSize: MySize.getScaledSizeHeight(10),
                                  textColor: color.appColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (relationship.isNotEmpty || phone.isNotEmpty)
                          commonText.regular(
                            text: [relationship, phone]
                                .where((s) => s.isNotEmpty)
                                .join(' · '),
                            fontSize: MySize.getScaledSizeHeight(12),
                            textColor: Colors.grey[600]!,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Recent activity ───────────────────────────────────────────────────────
  Widget _buildActivityCard(TransportController ctrl) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Recent Activity', Icons.history),
          MySize.getScaledSizeHeight(12).hSpace(),
          ...ctrl.recentLogs.take(8).map((log) {
            final eventType = log['event_type'] ?? '';
            final description = log['event_description'] ?? '';
            final createdAt = log['created_at'] ?? '';
            final routeName =
                log['route']?['route_name'] ?? '';

            DateTime? logTime;
            try {
              logTime = DateTime.parse(createdAt).toLocal();
            } catch (_) {}

            return Padding(
              padding:
                  EdgeInsets.only(bottom: MySize.getScaledSizeHeight(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.all(MySize.getScaledSizeHeight(6)),
                    decoration: BoxDecoration(
                      color:
                          ctrl.eventTypeColor(eventType).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.circle,
                        size: 8,
                        color: ctrl.eventTypeColor(eventType)),
                  ),
                  MySize.getScaledSizeHeight(10).wSpace(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MySize.getScaledSizeHeight(8),
                                vertical: MySize.getScaledSizeHeight(3),
                              ),
                              decoration: BoxDecoration(
                                color: ctrl
                                    .eventTypeColor(eventType)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    MySize.getScaledSizeHeight(20)),
                              ),
                              child: commonText.medium(
                                text: ctrl.eventTypeLabel(eventType),
                                fontSize: MySize.getScaledSizeHeight(11),
                                textColor:
                                    ctrl.eventTypeColor(eventType),
                              ),
                            ),
                          ],
                        ),
                        MySize.getScaledSizeHeight(2).hSpace(),
                        commonText.regular(
                          text: description,
                          fontSize: MySize.getScaledSizeHeight(13),
                          textColor: Colors.grey[700]!,
                        ),
                        if (routeName.isNotEmpty)
                          commonText.regular(
                            text: routeName,
                            fontSize: MySize.getScaledSizeHeight(11),
                            textColor: Colors.grey[500]!,
                          ),
                      ],
                    ),
                  ),
                  if (logTime != null)
                    commonText.regular(
                      text:
                          '${logTime.hour.toString().padLeft(2, '0')}:${logTime.minute.toString().padLeft(2, '0')}',
                      fontSize: MySize.getScaledSizeHeight(11),
                      textColor: Colors.grey[400]!,
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(16)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: MySize.getScaledSizeHeight(18), color: color.appColor),
        MySize.getScaledSizeHeight(8).wSpace(),
        commonText.medium(
          text: title,
          fontSize: MySize.getScaledSizeHeight(15),
          textColor: color.black,
        ),
      ],
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: MySize.getScaledSizeHeight(16), color: Colors.grey[500]),
        MySize.getScaledSizeHeight(8).wSpace(),
        commonText.regular(
          text: '$label: ',
          fontSize: MySize.getScaledSizeHeight(13),
          textColor: Colors.grey[600]!,
        ),
        Expanded(
          child: commonText.medium(
            text: value,
            fontSize: MySize.getScaledSizeHeight(13),
            textColor: color.black,
          ),
        ),
      ],
    );
  }
}
