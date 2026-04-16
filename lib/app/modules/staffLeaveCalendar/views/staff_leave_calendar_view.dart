import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:radianthyve_unified/commonWidgets/commonShimmer.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/NoData.dart';
import '../controllers/staff_leave_calendar_controller.dart';

class StaffLeaveCalendarView extends GetView<StaffLeaveCalendarController> {
  const StaffLeaveCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StaffLeaveCalendarController>(
      init: StaffLeaveCalendarController(),
      assignId: true,
      builder: (controller) {
        return Scaffold(
          backgroundColor: color.backgroundColor,
          appBar: commonWidget.appBar(
              titleText: AppMessage.calendar,
              backgroundColor: color.transparentColor,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: color.black),
              ),
            ),
          body: Padding(
            padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
            child: RefreshIndicator(
              onRefresh: () async {
                controller.ListLeaveRequetsAPI();
              },
              backgroundColor: color.white,
              color: color.appColor,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    TableCalendar(
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          final targetDate = DateTime(date.year, date.month, date.day);
                          if (controller.dateList
                              .any((date) => date.year == targetDate.year && date.month == targetDate.month && date.day == targetDate.day)) {
                            return Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red));
                          } else {
                            return null;
                          }
                        },
                      ),
                      firstDay: DateTime.now(),
                      lastDay: DateTime.utc(3000),
                      focusedDay: controller.selectedDay,
                      calendarFormat: CalendarFormat.month,
                      selectedDayPredicate: (date) {
                        return isSameDay(controller.selectedDay, date);
                      },
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      daysOfWeekVisible: true,
                      onDaySelected: (s, f) {
                        controller.selectedDay = s;
                        controller.ListLeaveRequetsAPI();
                        controller.update();
                      },
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(14), fontWeight: FontWeight.w500),
                        weekendStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(14), fontWeight: FontWeight.w500),
                        dowTextFormatter: (date, locale) {
                          switch (date.weekday) {
                            case DateTime.monday:
                              return 'MO';
                            case DateTime.tuesday:
                              return 'TU';
                            case DateTime.wednesday:
                              return 'WE';
                            case DateTime.thursday:
                              return 'TH';
                            case DateTime.friday:
                              return 'FR';
                            case DateTime.saturday:
                              return 'SA';
                            case DateTime.sunday:
                              return 'SU';
                            default:
                              return DateFormat.E(locale).format(date);
                          }
                        },
                      ),
                      onPageChanged: (focusedDay) {
                        if (DateFormat("yyyy-MM").parse(controller.selectedDay.toString()) != DateFormat("yyyy-MM").parse(focusedDay.toString())) {
                          controller.dateList.clear();
                          controller.selectedDay = focusedDay;
                        }
                      },
                      headerVisible: true,
                      daysOfWeekHeight: 50.0,
                      rowHeight: 50,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(16), fontWeight: FontWeight.w500),
                        leftChevronIcon: Image.asset(
                          icons.calendarArrowLeft,
                          height: MySize.getScaledSizeHeight(24),
                          width: MySize.getScaledSizeHeight(24),
                        ),
                        rightChevronIcon: Image.asset(
                          icons.calendarArrowRight,
                          height: MySize.getScaledSizeHeight(24),
                          width: MySize.getScaledSizeHeight(24),
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        markerSize: 20.0,
                        isTodayHighlighted: true,
                        todayDecoration: controller.selectedDay == DateTime.now()
                            ? BoxDecoration(color: color.white, shape: BoxShape.circle)
                            : BoxDecoration(color: color.transparentColor, shape: BoxShape.circle),
                        todayTextStyle: controller.selectedDay == DateTime.now()
                            ? TextStyle(color: Colors.white, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500)
                            : TextStyle(color: Colors.black, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                        selectedDecoration: BoxDecoration(
                          color: color.appColor,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: TextStyle(color: Colors.white, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                        defaultTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                        holidayTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                        rangeEndTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                        disabledTextStyle: TextStyle(
                          color: color.calenderColor,
                          fontSize: MySize.getScaledSizeHeight(13),
                          fontWeight: FontWeight.w500,
                        ),
                        weekendTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                        outsideTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                        markersAlignment: Alignment.bottomCenter,
                      ),
                    ),
                    20.0.hSpace(),
                    commonWidget.commonDivider(color: color.onboardingBorderColor),
                    16.0.hSpace(),
                    controller.isLoading.value
                        ? ListView.separated(
                            itemCount: 2,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return diagonalShimmer(
                                height: MySize.getScaledSizeHeight(389),
                                width: Get.width,
                                borderRadius: BorderRadius.circular(8),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return 16.0.hSpace();
                            },
                          )
                        : controller.staffLeaveList.isEmpty
                            ? SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                                child: NoData(height: Get.height / 2.8, width: Get.width),
                              )
                            : ListView.separated(
                                itemCount: controller.staffLeaveList.length,
                                shrinkWrap: true,
                                controller: controller.scrollController,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: color.white,
                                      borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeWidth(8))),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: MySize.getScaledSizeWidth(16)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          commonText
                                              .medium(
                                                text: controller.staffLeaveList[index].teacherName,
                                                textColor: color.black,
                                                fontSize: MySize.getScaledSizeHeight(16),
                                              )
                                              .paddingSymmetric(horizontal: MySize.getScaledSizeWidth(12)),
                                          10.0.hSpace(),
                                          commonWidget.commonDivider(color: color.dividerColor),
                                          12.0.hSpace(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(12)),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                commonText.regular(
                                                  text: AppMessage.dateOfLeave,
                                                  textColor: color.textFieldTextColor,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                08.0.hSpace(),
                                                commonText.regular(
                                                  text: controller.staffLeaveList[index].date,
                                                  textColor: color.black,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                16.0.hSpace(),
                                                commonText.regular(
                                                  text: AppMessage.leaveType,
                                                  textColor: color.textFieldTextColor,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                08.0.hSpace(),
                                                commonText.regular(
                                                  text: controller.staffLeaveList[index].leaveType,
                                                  textColor: color.black,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                16.0.hSpace(),
                                                commonText.regular(
                                                  text: AppMessage.reason,
                                                  textColor: color.textFieldTextColor,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                08.0.hSpace(),
                                                commonText.regular(
                                                  text: controller.staffLeaveList[index].reason,
                                                  textColor: color.black,
                                                  fontSize: MySize.getScaledSizeHeight(14),
                                                ),
                                                20.0.hSpace(),
                                                controller.staffLeaveList[index].leaveRequestStatus == "pending"
                                                    ? Row(
                                                        children: [
                                                          Expanded(
                                                            child: commonWidget.customButton(
                                                              buttonColor: color.absentBackgroundColor,
                                                              text: AppMessage.reject,
                                                              textColor: color.textFieldErrorColor,
                                                              isLoading: controller.staffLeaveList[index].isRejectLoader,
                                                              onTap: () {
                                                                if (controller.staffLeaveList[index].isRejectLoader != true &&
                                                                    controller.staffLeaveList[index].isAcceptLoader != true) {
                                                                  controller.UpdateLeaveStatusAPI(
                                                                    status: "rejected",
                                                                    leaveId: controller.staffLeaveList[index].id,
                                                                    index: index,
                                                                  );
                                                                }
                                                                controller.update();
                                                              },
                                                            ),
                                                          ),
                                                          09.0.wSpace(),
                                                          Expanded(
                                                            child: commonWidget.customButton(
                                                              text: AppMessage.accept,
                                                              isLoading: controller.staffLeaveList[index].isAcceptLoader,
                                                              onTap: () {
                                                                if (controller.staffLeaveList[index].isRejectLoader != true &&
                                                                    controller.staffLeaveList[index].isAcceptLoader != true) {
                                                                  controller.UpdateLeaveStatusAPI(
                                                                    status: "accepted",
                                                                    leaveId: controller.staffLeaveList[index].id,
                                                                    index: index,
                                                                  );
                                                                }
                                                                controller.update();
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : controller.staffLeaveList[index].leaveRequestStatus == "rejected"
                                                        ? commonText.medium(
                                                            text: "Rejected",
                                                            textColor: color.textFieldErrorColor,
                                                            fontSize: MySize.getScaledSizeHeight(14),
                                                          )
                                                        : commonText.medium(
                                                            text: "Accepted",
                                                            textColor: color.appColor,
                                                            fontSize: MySize.getScaledSizeHeight(14),
                                                          ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return 16.0.hSpace();
                                },
                              ),
                    Obx(() {
                      return controller.isLoadMoreRunning.value == true ? Center(child: CommonLoader()) : SizedBox(height: 0);
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
