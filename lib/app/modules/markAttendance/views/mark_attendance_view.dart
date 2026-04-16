import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../commonWidgets/commonShimmer.dart';
import '../../../../commonWidgets/common_drawer.dart';
import '../../../../commonWidgets/common_text.dart';
import '../../../../commonWidgets/common_widgets.dart';
import '../../../../commonWidgets/constant.dart';
import '../../../../commonWidgets/noDataFound.dart';
import '../../../../utils/Img_Icon.dart';
import '../../../../utils/SizeConstant.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/messages.dart';
import '../../attendanceStatus/views/attendance_status_view.dart';
import '../controllers/mark_attendance_controller.dart';

class MarkAttendanceView extends GetView<MarkAttendanceController> {
  const MarkAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarkAttendanceController>(
      init: MarkAttendanceController(),
      assignId: true,
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: controller.scaffoldKey,
            backgroundColor: color.backgroundColor,
            appBar: commonWidget.appBar(
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              leading: Padding(
                padding: EdgeInsets.only(left: MySize.getScaledSizeHeight(15)),
                child: InkWell(
                  onTap: () {
                    controller.scaffoldKey.currentState?.openDrawer();
                  },
                  child: Image.asset(icons.drawerIcon, height: MySize.getScaledSizeHeight(30), width: MySize.getScaledSizeHeight(30)),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: MySize.getScaledSizeHeight(16)),
                  child: InkWell(
                    onTap: () {
                      successfullyDialog(context: context);
                    },
                    child: Image.asset(
                      icons.calendarIcon,
                      height: MySize.getScaledSizeHeight(24),
                      width: MySize.getScaledSizeHeight(24),
                      color: color.white,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
              title: commonText.medium(text: AppMessage.markAttendance, fontSize: MySize.getScaledSizeHeight(18), textColor: color.white),
              centerTitle: false,
              backgroundColor: color.appColor,
            ),
            drawer: drawer(),
            body: Padding(
              padding: EdgeInsets.all(MySize.getScaledSizeHeight(16)),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: color.white, borderRadius: BorderRadius.all(Radius.circular(MySize.getScaledSizeHeight(8)))),
                    child: Padding(
                      padding: EdgeInsets.all(MySize.getScaledSizeHeight(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonText.regular(
                                text: AppMessage.dayDate,
                                textColor: color.textFieldTextColor,
                                fontSize: MySize.getScaledSizeHeight(14),
                              ),
                              10.0.hSpace(),
                              commonText.medium(
                                text: DateFormat('EEEE, dd MMMM, yyyy').format(DateTime.now()),
                                textColor: color.black,
                                fontSize: MySize.getScaledSizeHeight(14),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonText.regular(
                                text: AppMessage.time,
                                textColor: color.textFieldTextColor,
                                fontSize: MySize.getScaledSizeHeight(14),
                              ),
                              10.0.hSpace(),
                              commonText.medium(
                                text: DateFormat('hh:mm a').format(DateTime.now()),
                                textColor: color.black,
                                fontSize: MySize.getScaledSizeHeight(14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  16.0.hSpace(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)),
                      color: color.onboardingBorderColor,
                    ),
                    child: TextField(
                      cursorColor: color.black,
                      controller: controller.searchController,
                      onChanged: (value) {
                        if (controller.searchController.text.isEmpty) {
                          controller.debounceSearch(value);
                        }
                      },
                      onSubmitted: (value) {
                        controller.page = 1;
                        controller.teacherAllStudentApi();
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(
                          RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                        ),
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(16), vertical: MySize.getScaledSizeHeight(14)),
                        hintText: AppMessage.search,
                        border: InputBorder.none,
                        prefixIcon: Image.asset(icons.searchIcon, scale: 4.0),
                        suffixIcon:
                        controller.searchController.text != ''
                            ? InkWell(
                          onTap: () {
                            controller.searchController.clear();
                            controller.teacherAllStudentApi();
                            controller.update();
                          },
                          child: Icon(Icons.close_rounded, size: 24, color: color.black),
                        )
                            : SizedBox(),
                        hintStyle: TextStyle(
                          fontSize: MySize.getScaledSizeHeight(14),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Regular',
                          color: color.onboardingTextColor,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: MySize.getScaledSizeHeight(14),
                        color: color.black,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  16.0.hSpace(),
                  Obx(() {
                    return Expanded(
                      child: RefreshIndicator(
                        displacement: 30,
                        backgroundColor: color.white,
                        color: color.appColor,
                        strokeWidth: 3,
                        onRefresh: () async {
                          controller.page = 1;
                          controller.hasNextPage.value = true;
                          controller.teacherAllStudentApi();
                        },
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                          child: Column(
                            children: [
                              !controller.isLoading.value
                                  ? controller.studentListData.isEmpty
                                  ? buildNoDataWidget(height: MySize.getScaledSizeHeight(500))
                                  : ListView.separated(
                                itemCount: controller.studentListData.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var user = controller.studentListData[index];
                                  return Container(
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        commonText
                                            .medium(
                                          text: user.fullName ?? '',
                                          textColor: color.black,
                                          fontSize: MySize.getScaledSizeHeight(16),
                                        )
                                            .paddingOnly(top: MySize.getScaledSizeHeight(14), left: MySize.getScaledSizeHeight(12)),
                                        13.0.hSpace(),
                                        commonWidget.commonDivider(color: color.dividerColor),
                                        10.0.hSpace(),

                                        SizedBox(
                                          height: MySize.getScaledSizeHeight(50),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: controller.options.length,
                                            itemBuilder: (context, optionIndex) {
                                              return Opacity(
                                                opacity: 1.0,
                                                child: InkWell(
                                                  onTap: () {
                                                    print(controller.isSubmitted.value);
                                                    print('controller.isSubmitted.value');
                                                    if (controller.isSubmitted.value == false) {
                                                      if (optionIndex == 0) {
                                                        controller.studentAttendanceApi(
                                                          studentId: controller.studentListData[index].id,
                                                          attendanceStatus: 'present',
                                                        );
                                                      } else if (optionIndex == 1) {
                                                        if (controller.studentListData[index].attendance!.isEmpty) {
                                                          controller.studentAttendanceApi(
                                                            studentId: controller.studentListData[index].id,
                                                            attendanceStatus: 'absent',
                                                          );
                                                        } else {
                                                          if (controller.studentListData[index].attendance!.first.isOut == true &&
                                                              controller.studentListData[index].attendance!.first.attendanceStatus ==
                                                                  "present") {
                                                            controller.studentAttendanceApi(
                                                              studentId: controller.studentListData[index].id,
                                                              attendanceStatus: 'absent',
                                                            );
                                                          } else {
                                                            if (controller.studentListData[index].attendance!.first.isOut != true) {
                                                              controller.studentAttendanceApi(
                                                                studentId: controller.studentListData[index].id,
                                                                attendanceStatus: 'absent',
                                                              );
                                                            } else {
                                                              toastyInfo.showToast(message: "This student is already out");
                                                            }
                                                          }
                                                        }
                                                      } else {
                                                        if (controller.studentListData[index].attendance!.isNotEmpty) {
                                                          if (controller.studentListData[index].attendance!.first.attendanceStatus ==
                                                              "present") {
                                                            if (controller.studentListData[index].attendance!.first.isOut == false) {
                                                              controller.nameController.clear();
                                                              showDialog(
                                                                context: context,
                                                                builder: (context) {
                                                                  return Dialog(
                                                                    insetPadding: EdgeInsets.symmetric(
                                                                      horizontal: MySize.getScaledSizeWidth(16),
                                                                    ),
                                                                    backgroundColor: Colors.white,
                                                                    child: StatefulBuilder(
                                                                      builder: (context, setState) {
                                                                        return Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [
                                                                            16.0.hSpace(),

                                                                            commonText
                                                                                .semiBold(
                                                                              text: 'Picked up by...',
                                                                              fontSize: MySize.getScaledSizeHeight(18),
                                                                            )
                                                                                .paddingSymmetric(horizontal: MySize.getScaledSizeWidth(16)),
                                                                            10.0.hSpace(),
                                                                            // Mother
                                                                            ListTile(
                                                                              leading: CircleAvatar(
                                                                                backgroundColor: Colors.orange,
                                                                                child: Icon(Icons.woman, color: Colors.white),
                                                                              ),
                                                                              title: commonText.medium(text: 'Mother'),
                                                                              tileColor:
                                                                              controller.selectedOption.value == "Mother"
                                                                                  ? Colors.orange.shade100
                                                                                  : null,
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  controller.selectedOption.value = "Mother";
                                                                                });
                                                                              },
                                                                            ),

                                                                            // Father
                                                                            ListTile(
                                                                              leading: const CircleAvatar(
                                                                                backgroundColor: Colors.blue,
                                                                                child: Icon(Icons.man, color: Colors.white),
                                                                              ),
                                                                              title: commonText.medium(text: 'Father'),
                                                                              tileColor:
                                                                              controller.selectedOption.value == "Father"
                                                                                  ? Colors.blue.shade100
                                                                                  : null,
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  controller.selectedOption.value = "Father";
                                                                                });
                                                                              },
                                                                            ),

                                                                            // Other
                                                                            ListTile(
                                                                              leading: const CircleAvatar(
                                                                                backgroundColor: Colors.green,
                                                                                child: Icon(Icons.person, color: Colors.white),
                                                                              ),
                                                                              title: commonText.medium(text: 'Other'),
                                                                              tileColor:
                                                                              controller.selectedOption.value == "Other"
                                                                                  ? Colors.green.shade100
                                                                                  : null,
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  controller.selectedOption.value = "Other";
                                                                                });
                                                                              },
                                                                            ),

                                                                            12.0.hSpace(),

                                                                            commonWidget
                                                                                .commonTextField(
                                                                              inputFormatters: <TextInputFormatter>[
                                                                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                                                              ],
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              controller: controller.nameController,
                                                                              labelText: 'Name',
                                                                              hintText: 'Enter Name',
                                                                              errorText: '',
                                                                              onTap: () {},
                                                                              onChanged: (value) {},
                                                                              isbordervisibal: false,
                                                                            )
                                                                                .paddingSymmetric(horizontal: MySize.getScaledSizeWidth(16)),
                                                                            12.0.hSpace(),
                                                                            Row(
                                                                              children: [
                                                                                Spacer(),
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.pop(context),
                                                                                  child: commonText.medium(
                                                                                    text: 'Cancel',
                                                                                    textColor: color.appColor,
                                                                                  ),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    if (controller.nameController.text
                                                                                        .trim()
                                                                                        .isNotEmpty) {
                                                                                      log('nameController');
                                                                                      controller.studentAttendanceApi(
                                                                                        studentId: controller.studentListData[index].id,
                                                                                        attendanceStatus: 'out',
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                    } else {
                                                                                      log('nameControllerffsfsdfsdf');
                                                                                      toastyInfo.showToast(
                                                                                        message: 'Please enter who picked up name',
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                  child: commonText.medium(
                                                                                    text: 'Submit',
                                                                                    textColor: color.appColor,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ).paddingOnly(right: MySize.getScaledSizeWidth(10)),
                                                                            16.0.hSpace(),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          } else {
                                                            toastyInfo.showToast(message: "This student is not present today.");
                                                          }
                                                        } else {
                                                          toastyInfo.showToast(message: "This student is not present today.");
                                                        }
                                                      }
                                                    } else {
                                                      toastyInfo.showToast(message: "Attendance already submitted for today");
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        optionIndex == 0
                                                            ? controller.studentListData[index].attendance!.isNotEmpty
                                                            ? (controller.studentListData[index].attendance!.first.attendanceStatus ==
                                                            "present")
                                                            ? icons.presentIcon
                                                            : icons.unCheckIcon
                                                            : icons.unCheckIcon
                                                            : optionIndex == 1
                                                            ? controller.studentListData[index].attendance!.isNotEmpty
                                                            ? controller.studentListData[index].attendance!.first.attendanceStatus ==
                                                            "absent"
                                                            ? icons.absentIcon
                                                            : icons.unCheckIcon
                                                            : icons.unCheckIcon
                                                            : controller.studentListData[index].attendance!.isNotEmpty
                                                            ? controller.studentListData[index].attendance!.first.isOut == true
                                                            ? controller.studentListData[index].attendance!.first.attendanceStatus ==
                                                            "absent"
                                                            ? icons.unCheckIcon
                                                            : icons.outIcon
                                                            : icons.unCheckIcon
                                                            : icons.unCheckIcon,
                                                        height: MySize.getScaledSizeHeight(24),
                                                        width: MySize.getScaledSizeWidth(24),
                                                      ),
                                                      8.0.wSpace(),
                                                      commonText.regular(
                                                        text: controller.options[optionIndex],
                                                        textColor: color.textFieldTextColor,
                                                        fontSize: MySize.getScaledSizeHeight(16),
                                                      ),
                                                      10.0.wSpace(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ).paddingOnly(left: MySize.getScaledSizeHeight(12), bottom: MySize.getScaledSizeHeight(10)),

                                        // SizedBox(
                                        //   height: MySize.getScaledSizeHeight(50),
                                        //   child: ListView.builder(
                                        //     scrollDirection: Axis.horizontal,
                                        //     itemCount: controller.options.length,
                                        //     itemBuilder: (context, optionIndex) {
                                        //       return Opacity(
                                        //         opacity: 1.0,
                                        //         child: InkWell(
                                        //           onTap: () {
                                        //             print(controller.isSubmitted.value);
                                        //             print('controller.isSubmitted.value');
                                        //             if (controller.isSubmitted.value == false) {
                                        //               if (optionIndex == 0) {
                                        //                 controller.studentAttendanceApi(
                                        //                   studentId: controller.studentListData[index].id,
                                        //                   attendanceStatus: 'present',
                                        //                 );
                                        //               } else if (optionIndex == 1) {
                                        //                 if (controller.studentListData[index].attendance!.isEmpty) {
                                        //                   controller.studentAttendanceApi(
                                        //                     studentId: controller.studentListData[index].id,
                                        //                     attendanceStatus: 'absent',
                                        //                   );
                                        //                 } else {
                                        //                   if (controller.studentListData[index].attendance!.first.isOut == true &&
                                        //                       controller.studentListData[index].attendance!.first.attendanceStatus ==
                                        //                           "present") {
                                        //                     controller.studentAttendanceApi(
                                        //                       studentId: controller.studentListData[index].id,
                                        //                       attendanceStatus: 'absent',
                                        //                     );
                                        //                   } else {
                                        //                     if (controller.studentListData[index].attendance!.first.isOut != true) {
                                        //                       controller.studentAttendanceApi(
                                        //                         studentId: controller.studentListData[index].id,
                                        //                         attendanceStatus: 'absent',
                                        //                       );
                                        //                     } else {
                                        //                       toastyInfo.showToast(message: "This student is already out");
                                        //                     }
                                        //                   }
                                        //                 }
                                        //               } else {
                                        //                 if (controller.studentListData[index].attendance!.isNotEmpty) {
                                        //                   if (controller.studentListData[index].attendance!.first.attendanceStatus ==
                                        //                       "present") {
                                        //                     if (controller.studentListData[index].attendance!.first.isOut == false) {
                                        //                       log('ffdfdsfdfddfdfdffdfd');
                                        //                       // controller.studentAttendanceApi(
                                        //                       //   studentId: controller.studentListData[index].id,
                                        //                       //   attendanceStatus: 'out',
                                        //                       // );
                                        //
                                        //
                                        //                       /*showDialog(
                                        //                         context: context,
                                        //                         builder: (context) {
                                        //                           String? selectedOption;
                                        //                           final TextEditingController nameController = TextEditingController();
                                        //
                                        //                           return StatefulBuilder(
                                        //                             builder: (context, setState) {
                                        //                               return AlertDialog(
                                        //                                 title: const Text("Picked up by..."),
                                        //                                 content: Column(
                                        //                                   mainAxisSize: MainAxisSize.min,
                                        //                                   children: [
                                        //                                     // Mother
                                        //                                     ListTile(
                                        //                                       leading: const CircleAvatar(
                                        //                                         backgroundColor: Colors.orange,
                                        //                                         child: Icon(Icons.woman, color: Colors.white),
                                        //                                       ),
                                        //                                       title: const Text("Mother"),
                                        //                                       tileColor:
                                        //                                           selectedOption == "Mother" ? Colors.orange.shade100 : null,
                                        //                                       onTap: () {
                                        //                                         setState(() {
                                        //                                           selectedOption = "Mother";
                                        //                                           nameController.text = "Sarai Fermin"; // auto name
                                        //                                         });
                                        //                                       },
                                        //                                     ),
                                        //                                     const SizedBox(height: 8),
                                        //
                                        //                                     // Father
                                        //                                     ListTile(
                                        //                                       leading: const CircleAvatar(
                                        //                                         backgroundColor: Colors.blue,
                                        //                                         child: Icon(Icons.man, color: Colors.white),
                                        //                                       ),
                                        //                                       title: const Text("Father"),
                                        //                                       tileColor:
                                        //                                           selectedOption == "Father" ? Colors.blue.shade100 : null,
                                        //                                       onTap: () {
                                        //                                         setState(() {
                                        //                                           selectedOption = "Father";
                                        //                                           nameController.text = "Williams Flores"; // auto name
                                        //                                         });
                                        //                                       },
                                        //                                     ),
                                        //                                     const SizedBox(height: 8),
                                        //
                                        //                                     // Other
                                        //                                     ListTile(
                                        //                                       leading: const CircleAvatar(
                                        //                                         backgroundColor: Colors.green,
                                        //                                         child: Icon(Icons.person, color: Colors.white),
                                        //                                       ),
                                        //                                       title: const Text("Other"),
                                        //                                       tileColor:
                                        //                                           selectedOption == "Other" ? Colors.green.shade100 : null,
                                        //                                       onTap: () {
                                        //                                         setState(() {
                                        //                                           selectedOption = "Other";
                                        //                                           nameController.clear();
                                        //                                         });
                                        //                                       },
                                        //                                     ),
                                        //
                                        //                                     // 🔽 TextField only if Other is selected
                                        //                                     if (selectedOption == "Other") ...[
                                        //                                       const SizedBox(height: 12),
                                        //                                       TextField(
                                        //                                         controller: nameController,
                                        //                                         decoration: const InputDecoration(
                                        //                                           hintText: "Enter name",
                                        //                                           border: OutlineInputBorder(),
                                        //                                         ),
                                        //                                       ),
                                        //                                     ],
                                        //                                   ],
                                        //                                 ),
                                        //                                 actions: [
                                        //                                   TextButton(
                                        //                                     onPressed: () => Navigator.pop(context),
                                        //                                     child: const Text("CANCEL"),
                                        //                                   ),
                                        //                                   TextButton(
                                        //                                     onPressed: () {
                                        //                                       if (selectedOption != null &&
                                        //                                           (selectedOption != "Other" ||
                                        //                                               nameController.text.trim().isNotEmpty)) {
                                        //                                         controller.pickupByController.text =
                                        //                                             nameController.text.trim();
                                        //
                                        //                                         // Call API with 'out' status
                                        //                                         controller.studentAttendanceApi(
                                        //                                           studentId: controller.studentListData[index].id,
                                        //                                           attendanceStatus: 'out',
                                        //                                         );
                                        //
                                        //                                         Navigator.pop(context);
                                        //                                       } else {
                                        //                                         ScaffoldMessenger.of(context).showSnackBar(
                                        //                                           const SnackBar(
                                        //                                             content: Text("Please select who picked up"),
                                        //                                           ),
                                        //                                         );
                                        //                                       }
                                        //                                     },
                                        //                                     child: const Text("OK"),
                                        //                                   ),
                                        //                                 ],
                                        //                               );
                                        //                             },
                                        //                           );
                                        //                         },
                                        //                       );*/
                                        //
                                        //                     }
                                        //                   } else {
                                        //                     toastyInfo.showToast(message: "This student is not present today.");
                                        //                   }
                                        //                 } else {
                                        //                   toastyInfo.showToast(message: "This student is not present today.");
                                        //                 }
                                        //               }
                                        //             } else {
                                        //               toastyInfo.showToast(message: "Attendance already submitted for today");
                                        //             }
                                        //           },
                                        //           child: Row(
                                        //             children: [
                                        //               Image.asset(
                                        //                 optionIndex == 0
                                        //                     ? controller.studentListData[index].attendance!.isNotEmpty
                                        //                         ? (controller.studentListData[index].attendance!.first.attendanceStatus ==
                                        //                                 "present")
                                        //                             ? icons.presentIcon
                                        //                             : icons.unCheckIcon
                                        //                         : icons.unCheckIcon
                                        //                     : optionIndex == 1
                                        //                     ? controller.studentListData[index].attendance!.isNotEmpty
                                        //                         ? controller.studentListData[index].attendance!.first.attendanceStatus ==
                                        //                                 "absent"
                                        //                             ? icons.absentIcon
                                        //                             : icons.unCheckIcon
                                        //                         : icons.unCheckIcon
                                        //                     : controller.studentListData[index].attendance!.isNotEmpty
                                        //                     ? controller.studentListData[index].attendance!.first.isOut == true
                                        //                         ? controller.studentListData[index].attendance!.first.attendanceStatus ==
                                        //                                 "absent"
                                        //                             ? icons.unCheckIcon
                                        //                             : icons.outIcon
                                        //                         : icons.unCheckIcon
                                        //                     : icons.unCheckIcon,
                                        //                 height: MySize.getScaledSizeHeight(24),
                                        //                 width: MySize.getScaledSizeWidth(24),
                                        //               ),
                                        //               8.0.wSpace(),
                                        //               commonText.regular(
                                        //                 text: controller.options[optionIndex],
                                        //                 textColor: color.textFieldTextColor,
                                        //                 fontSize: MySize.getScaledSizeHeight(16),
                                        //               ),
                                        //               10.0.wSpace(),
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       );
                                        //     },
                                        //   ),
                                        // ).paddingOnly(left: MySize.getScaledSizeHeight(12), bottom: MySize.getScaledSizeHeight(10)),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => 16.0.hSpace(),
                              )
                                  : ListView.separated(
                                itemCount: 5,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return diagonalShimmer(
                                    height: MySize.getScaledSizeHeight(95),
                                    width: Get.width,
                                    borderRadius: BorderRadius.circular(4),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 16);
                                },
                              ),

                              Obx(() {
                                return controller.isLoadMoreRunning.value == true ? Center(child: CommonLoader()) : Container();
                              }),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            bottomNavigationBar:
            controller.isAttendance.value == true
                ? controller.studentListData.length == 0
                ? SizedBox()
                : Container(
              decoration: BoxDecoration(color: color.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  commonWidget.commonDivider(color: color.notificationContainerColor),
                  commonWidget
                      .customButton(
                    text: AppMessage.viewAttendance,
                    onTap: () {
                      Get.to(
                            () => AttendanceStatusView(),
                        arguments: {'selectedDate': DateFormat('EEEE, d MMMM, yyyy').format(DateTime.now())},
                      );
                    },
                  )
                      .paddingAll(MySize.getScaledSizeHeight(16)),
                ],
              ),
            ).paddingOnly(bottom: Platform.isIOS ? MySize.getScaledSizeHeight(10) : 0)
                : SizedBox(),
          ),
        );
      },
    );
  }

  void successfullyDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(15)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(20))),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
                    child: commonText.medium(
                      text: AppMessage.selectDate,
                      fontSize: MySize.getScaledSizeHeight(18),
                      textColor: color.black,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  commonWidget.commonDivider(color: color.onboardingBorderColor),
                  16.0.hSpace(),
                  TableCalendar(
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, date, _) {
                        if (date.isAfter(DateTime.now())) {
                          return Center(
                            child: Text(
                              '${date.day}',
                              style: TextStyle(color: Colors.grey, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                            ),
                          );
                        }
                        return null; // use default style
                      },

                      markerBuilder: (context, date, events) {
                        final targetDate = DateTime(date.year, date.month, date.day);
                        if (controller.dateList.any(
                              (date) => date.year == targetDate.year && date.month == targetDate.month && date.day == targetDate.day,
                        )) {
                          return Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red));
                        } else {
                          return null;
                        }
                      },
                    ),
                    firstDay: DateTime.utc(2000),
                    lastDay: DateTime.utc(3000),
                    focusedDay: controller.selectedDay,
                    calendarFormat: CalendarFormat.month,
                    selectedDayPredicate: (date) {
                      return isSameDay(controller.selectedDay, date);
                    },
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    daysOfWeekVisible: true,
                    onDaySelected: (selectedDay, focusedDay) {
                      if (selectedDay.isAfter(DateTime.now())) {
                        toastyInfo.showToast(message: "You can't select a future date.");
                        return;
                      }

                      setState(() {
                        controller.selectedDay = selectedDay;
                      });
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
                    onHeaderTapped: (d) {},
                    daysOfWeekHeight: 50.0,
                    rowHeight: 50,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(16), fontWeight: FontWeight.w500),
                      leftChevronIcon: Icon(Icons.arrow_back_ios_new_rounded, size: MySize.getScaledSizeHeight(24)),
                      rightChevronIcon: Icon(Icons.arrow_forward_ios_rounded, size: MySize.getScaledSizeHeight(24)),
                    ),
                    calendarStyle: CalendarStyle(
                      markerSize: 20.0,
                      isTodayHighlighted: true,
                      todayDecoration: BoxDecoration(color: color.transparentColor, shape: BoxShape.circle),
                      selectedDecoration: BoxDecoration(color: color.appColor, shape: BoxShape.circle),
                      selectedTextStyle: TextStyle(color: Colors.white, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                      defaultTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                      holidayTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                      rangeEndTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                      disabledTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                      weekendTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                      outsideTextStyle: TextStyle(
                        color: color.calenderColor,
                        fontSize: MySize.getScaledSizeHeight(13),
                        fontWeight: FontWeight.w500,
                      ),
                      todayTextStyle: TextStyle(color: color.black, fontSize: MySize.getScaledSizeHeight(13), fontWeight: FontWeight.w500),
                      markersAlignment: Alignment.bottomCenter,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(MySize.getScaledSizeHeight(20)),
                    child: commonWidget.customButton(
                      text: AppMessage.viewStudentAttendance,
                      onTap: () {
                        Get.back();
                        Get.to(
                              () => AttendanceStatusView(),
                          arguments: {'flag': 'calendarRoute', 'selectedDate': DateFormat('EEEE, d MMMM, yyyy').format(controller.selectedDay)},
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
