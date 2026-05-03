import 'package:get/get.dart';

// Common modules
import '../modules/attendanceDetails/bindings/attendance_details_binding.dart';
import '../modules/attendanceDetails/views/attendance_details_view.dart';
import '../modules/changePassword/bindings/change_password_binding.dart';
import '../modules/changePassword/views/change_password_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/editPersonalInformation/bindings/edit_personal_information_binding.dart';
import '../modules/editPersonalInformation/views/edit_personal_information_view.dart';
import '../modules/forgotPassword/bindings/forgot_password_binding.dart';
import '../modules/forgotPassword/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/mealInformation/bindings/meal_information_binding.dart';
import '../modules/mealInformation/views/meal_information_view.dart';
import '../modules/medicationInformation/bindings/medication_information_binding.dart';
import '../modules/medicationInformation/views/medication_information_view.dart';
import '../modules/message/bindings/message_binding.dart';
import '../modules/message/views/message_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/paymentReceipt/bindings/payment_receipt_binding.dart';
import '../modules/paymentReceipt/views/payment_receipt_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/resetPassword/bindings/reset_password_binding.dart';
import '../modules/resetPassword/views/reset_password_view.dart';
import '../modules/sleepLogsDetails/bindings/sleep_logs_details_binding.dart';
import '../modules/sleepLogsDetails/views/sleep_logs_details_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/studentDetails/bindings/student_details_binding.dart';
import '../modules/studentDetails/views/student_details_view.dart';
import '../modules/studentEditProfile/bindings/student_edit_profile_binding.dart';
import '../modules/studentEditProfile/views/student_edit_profile_view.dart';
import '../modules/verification/bindings/verification_binding.dart';
import '../modules/verification/views/verification_view.dart';

// Parents transport module
import '../modules/transport/bindings/transport_binding.dart';
import '../modules/transport/views/transport_view.dart';

// Parents-specific modules
import '../modules/childReportDetails/bindings/child_report_details_binding.dart';
import '../modules/childReportDetails/views/child_report_details_view.dart';
import '../modules/childReports/bindings/child_reports_binding.dart';
import '../modules/childReports/views/child_reports_view.dart';
import '../modules/editChildsInformation/bindings/edit_childs_information_binding.dart';
import '../modules/editChildsInformation/views/edit_childs_information_view.dart';
import '../modules/makePayment/bindings/make_payment_binding.dart';
import '../modules/makePayment/views/make_payment_view.dart';
import '../modules/markAttendance/bindings/mark_attendance_binding.dart';
import '../modules/markAttendance/views/mark_attendance_view.dart';
import '../modules/notificationDetails/bindings/notification_details_binding.dart';
import '../modules/notificationDetails/views/notification_details_view.dart';
import '../modules/paidFeeDetails/bindings/paid_fee_details_binding.dart';
import '../modules/paidFeeDetails/views/paid_fee_details_view.dart';
import '../modules/parentsReminder/bindings/parents_reminder_binding.dart';
import '../modules/parentsReminder/views/parents_reminder_view.dart';

// Teacher-specific modules
import '../modules/AddDiaper/bindings/add_diaper_binding.dart';
import '../modules/AddDiaper/views/add_diaper_view.dart';
import '../modules/AddSleepInformation/bindings/add_sleep_information_binding.dart';
import '../modules/AddSleepInformation/views/add_sleep_information_view.dart';
import '../modules/ClassroomReport/bindings/classroom_report_binding.dart';
import '../modules/ClassroomReport/views/classroom_report_view.dart';
import '../modules/DiaperHygieneTracker/bindings/diaper_hygiene_tracker_binding.dart';
import '../modules/DiaperHygieneTracker/views/diaper_hygiene_tracker_view.dart';
import '../modules/addLeave/bindings/add_leave_binding.dart';
import '../modules/addLeave/views/add_leave_view.dart';
import '../modules/addMedication/bindings/add_medication_binding.dart';
import '../modules/addMedication/views/add_medication_view.dart';
import '../modules/addMenu/bindings/add_menu_binding.dart';
import '../modules/addMenu/views/add_menu_view.dart';
import '../modules/attendanceStatus/bindings/attendance_status_binding.dart';
import '../modules/attendanceStatus/views/attendance_status_view.dart';
import '../modules/chatList/bindings/chat_list_binding.dart';
import '../modules/chatList/views/chat_list_view.dart';
import '../modules/classList/bindings/class_list_binding.dart';
import '../modules/classList/views/class_list_view.dart';
import '../modules/classroomData/bindings/classroom_data_binding.dart';
import '../modules/classroomData/views/classroom_data_view.dart';
import '../modules/classroomDetails/bindings/classroom_details_binding.dart';
import '../modules/classroomDetails/views/classroom_details_view.dart';
import '../modules/dailyAttendance/bindings/daily_attendance_binding.dart';
import '../modules/dailyAttendance/views/daily_attendance_view.dart';
import '../modules/groupChat/bindings/group_chat_binding.dart';
import '../modules/groupChat/views/group_chat_view.dart';
import '../modules/mealTracking/bindings/meal_tracking_binding.dart';
import '../modules/mealTracking/views/meal_tracking_view.dart';
import '../modules/medication/bindings/medication_binding.dart';
import '../modules/medication/views/medication_view.dart';
import '../modules/myLeave/bindings/my_leave_binding.dart';
import '../modules/myLeave/views/my_leave_view.dart';
import '../modules/sleepLogs/bindings/sleep_logs_binding.dart';
import '../modules/sleepLogs/views/sleep_logs_view.dart';
import '../modules/studentDailyAttendance/bindings/student_daily_attendance_binding.dart';
import '../modules/studentDailyAttendance/views/student_daily_attendance_view.dart';

// Principal-specific modules
import '../modules/EmergencyList/bindings/emergency_list_binding.dart';
import '../modules/EmergencyList/views/emergency_list_view.dart';
import '../modules/StaffDailyAttendance/bindings/staff_daily_attendance_binding.dart';
import '../modules/StaffDailyAttendance/views/staff_daily_attendance_view.dart';
import '../modules/addCertification/bindings/add_certification_binding.dart';
import '../modules/addCertification/views/add_certification_view.dart';
import '../modules/addClassroom/bindings/add_classroom_binding.dart';
import '../modules/addClassroom/views/add_classroom_view.dart';
import '../modules/addParents/bindings/add_parents_binding.dart';
import '../modules/addParents/views/add_parents_view.dart';
import '../modules/addProgram/bindings/add_program_binding.dart';
import '../modules/addProgram/views/add_program_view.dart';
import '../modules/addShiftInformation/bindings/add_shift_information_binding.dart';
import '../modules/addShiftInformation/views/add_shift_information_view.dart';
import '../modules/addStaff/bindings/add_staff_binding.dart';
import '../modules/addStaff/views/add_staff_view.dart';
import '../modules/assignedStudent/bindings/assigned_student_binding.dart';
import '../modules/assignedStudent/views/assigned_student_view.dart';
import '../modules/birthdayDetails/bindings/birthday_details_binding.dart';
import '../modules/birthdayDetails/views/birthday_details_view.dart';
import '../modules/certification/bindings/certification_binding.dart';
import '../modules/certification/views/certification_view.dart';
import '../modules/certificationDetails/bindings/certification_details_binding.dart';
import '../modules/certificationDetails/views/certification_details_view.dart';
import '../modules/classroom/bindings/classroom_binding.dart';
import '../modules/classroom/views/classroom_view.dart';
import '../modules/editAccountInformation/bindings/edit_account_information_binding.dart';
import '../modules/editAccountInformation/views/edit_account_information_view.dart';
import '../modules/emergency/bindings/emergency_binding.dart';
import '../modules/emergency/views/emergency_view.dart';
import '../modules/parentsDetails/bindings/parents_details_binding.dart';
import '../modules/parentsDetails/views/parents_details_view.dart';
import '../modules/parentsList/bindings/parents_list_binding.dart';
import '../modules/parentsList/views/parents_list_view.dart';
import '../modules/programList/bindings/program_list_binding.dart';
import '../modules/programList/views/program_list_view.dart';
import '../modules/reminderToParentsInformation/bindings/reminder_to_parents_information_binding.dart';
import '../modules/reminderToParentsInformation/views/reminder_to_parents_information_view.dart';
import '../modules/shift/bindings/shift_binding.dart';
import '../modules/shift/views/shift_view.dart';
import '../modules/shiftDetails/bindings/shift_details_binding.dart';
import '../modules/shiftDetails/views/shift_details_view.dart';
import '../modules/staffDetails/bindings/staff_details_binding.dart';
import '../modules/staffDetails/views/staff_details_view.dart';
import '../modules/staffLeave/bindings/staff_leave_binding.dart';
import '../modules/staffLeave/views/staff_leave_view.dart';
import '../modules/staffLeaveCalendar/bindings/staff_leave_calendar_binding.dart';
import '../modules/staffLeaveCalendar/views/staff_leave_calendar_view.dart';
import '../modules/staffList/bindings/staff_list_binding.dart';
import '../modules/staffList/views/staff_list_view.dart';
import '../modules/studentList/bindings/student_list_binding.dart';
import '../modules/studentList/views/student_list_view.dart';
import '../modules/upcomingBirthday/bindings/upcoming_birthday_binding.dart';
import '../modules/upcomingBirthday/views/upcoming_birthday_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // Common pages
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.VERIFICATION,
      page: () => const VerificationView(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_DETAILS,
      page: () => const StudentDetailsView(),
      binding: StudentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_EDIT_PROFILE,
      page: () => const StudentEditProfileView(),
      binding: StudentEditProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGE,
      page: () => const MessageView(),
      binding: MessageBinding(),
    ),
    GetPage(
      name: _Paths.MEAL_INFORMATION,
      page: () => const MealInformationView(),
      binding: MealInformationBinding(),
    ),
    GetPage(
      name: _Paths.SLEEP_LOGS_DETAILS,
      page: () => const SleepLogsDetailsView(),
      binding: SleepLogsDetailsBinding(),
    ),
    GetPage(
      name: _Paths.MEDICATION_INFORMATION,
      page: () => const MedicationInformationView(),
      binding: MedicationInformationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PERSONAL_INFORMATION,
      page: () => const EditPersonalInformationView(),
      binding: EditPersonalInformationBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_RECEIPT,
      page: () => const PaymentReceiptView(),
      binding: PaymentReceiptBinding(),
    ),
    
    // Parents transport page
    GetPage(
      name: _Paths.TRANSPORT,
      page: () => const TransportView(),
      binding: TransportBinding(),
    ),

    // Parents-specific pages
    GetPage(
      name: _Paths.MARK_ATTENDANCE,
      page: () => const MarkAttendanceView(),
      binding: MarkAttendanceBinding(),
    ),
    GetPage(
      name: _Paths.CHILD_REPORTS,
      page: () => const ChildReportsView(),
      binding: ChildReportsBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_DETAILS,
      page: () => const NotificationDetailsView(),
      binding: NotificationDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCE_DETAILS,
      page: () => const AttendanceDetailsView(),
      binding: AttendanceDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CHILD_REPORT_DETAILS,
      page: () => const ChildReportDetailsView(),
      binding: ChildReportDetailsBinding(),
    ),
    GetPage(
      name: _Paths.MAKE_PAYMENT,
      page: () => const MakePaymentView(),
      binding: MakePaymentBinding(),
    ),
    GetPage(
      name: _Paths.PAID_FEE_DETAILS,
      page: () => const PaidFeeDetailsView(),
      binding: PaidFeeDetailsBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_CHILDS_INFORMATION,
      page: () => const EditChildsInformationView(),
      binding: EditChildsInformationBinding(),
    ),
    GetPage(
      name: _Paths.PARENTS_REMINDER,
      page: () => const ParentsReminderView(),
      binding: ParentsReminderBinding(),
    ),
    
    // Teacher-specific pages
    GetPage(
      name: _Paths.DAILY_ATTENDANCE,
      page: () => const DailyAttendanceView(),
      binding: DailyAttendanceBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_DAILY_ATTENDANCE,
      page: () => const StudentDailyAttendanceView(),
      binding: StudentDailyAttendanceBinding(),
    ),
    GetPage(
      name: _Paths.ADD_MENU,
      page: () => const AddMenuView(),
      binding: AddMenuBinding(),
    ),
    GetPage(
      name: _Paths.ADD_SLEEP_INFORMATION,
      page: () => const AddSleepInformationView(),
      binding: AddSleepInformationBinding(),
    ),
    GetPage(
      name: _Paths.ADD_MEDICATION,
      page: () => const AddMedicationView(),
      binding: AddMedicationBinding(),
    ),
    GetPage(
      name: _Paths.CLASSROOM_DATA,
      page: () => const ClassroomDataView(),
      binding: ClassroomDataBinding(),
    ),
    GetPage(
      name: _Paths.MY_LEAVE,
      page: () => const MyLeaveView(),
      binding: MyLeaveBinding(),
    ),
    GetPage(
      name: _Paths.CLASSROOM_DETAILS,
      page: () => const ClassroomDetailsView(),
      binding: ClassroomDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_LEAVE,
      page: () => const AddLeaveView(),
      binding: AddLeaveBinding(),
    ),
    GetPage(
      name: _Paths.CLASSROOM_REPORT,
      page: () => const ClassroomReportView(),
      binding: ClassroomReportBinding(),
    ),
    GetPage(
      name: _Paths.CLASS_LIST,
      page: () => const ClassListView(),
      binding: ClassListBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCE_STATUS,
      page: () => const AttendanceStatusView(),
      binding: AttendanceStatusBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_LIST,
      page: () => const ChatListView(),
      binding: ChatListBinding(),
    ),
    GetPage(
      name: _Paths.MEAL_TRACKING,
      page: () => const MealTrackingView(),
      binding: MealTrackingBinding(),
    ),
    GetPage(
      name: _Paths.SLEEP_LOGS,
      page: () => const SleepLogsView(),
      binding: SleepLogsBinding(),
    ),
    GetPage(
      name: _Paths.MEDICATION,
      page: () => const MedicationView(),
      binding: MedicationBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_CHAT,
      page: () => const GroupChatView(),
      binding: GroupChatBinding(),
    ),
    GetPage(
      name: _Paths.DIAPER_HYGIENE_TRACKER,
      page: () => const DiaperHygieneTrackerView(),
      binding: DiaperHygieneTrackerBinding(),
    ),
    GetPage(
      name: _Paths.ADD_DIAPER,
      page: () => const AddDiaperView(),
      binding: AddDiaperBinding(),
    ),
    
    // Principal-specific pages
    GetPage(
      name: _Paths.EMERGENCY,
      page: () => const EmergencyView(),
      binding: EmergencyBinding(),
    ),
    GetPage(
      name: _Paths.STAFF_LIST,
      page: () => const StaffListView(),
      binding: StaffListBinding(),
    ),
    GetPage(
      name: _Paths.STAFF_DETAILS,
      page: () => const StaffDetailsView(),
      binding: StaffDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_STAFF,
      page: () => const AddStaffView(),
      binding: AddStaffBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_ACCOUNT_INFORMATION,
      page: () => const EditAccountInformationView(),
      binding: EditAccountInformationBinding(),
    ),
    GetPage(
      name: _Paths.PARENTS_LIST,
      page: () => const ParentsListView(),
      binding: ParentsListBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PARENTS,
      page: () => const AddParentsView(),
      binding: AddParentsBinding(),
    ),
    GetPage(
      name: _Paths.PARENTS_DETAILS,
      page: () => const ParentsDetailsView(),
      binding: ParentsDetailsBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_LIST,
      page: () => const StudentListView(),
      binding: StudentListBinding(),
    ),
    GetPage(
      name: _Paths.CLASSROOM,
      page: () => const ClassroomView(),
      binding: ClassroomBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CLASSROOM,
      page: () => const AddClassroomView(),
      binding: AddClassroomBinding(),
    ),
    GetPage(
      name: _Paths.STAFF_LEAVE,
      page: () => const StaffLeaveView(),
      binding: StaffLeaveBinding(),
    ),
    GetPage(
      name: _Paths.STAFF_LEAVE_CALENDAR,
      page: () => const StaffLeaveCalendarView(),
      binding: StaffLeaveCalendarBinding(),
    ),
    GetPage(
      name: _Paths.SHIFT,
      page: () => const ShiftView(),
      binding: ShiftBinding(),
    ),
    GetPage(
      name: _Paths.ADD_SHIFT_INFORMATION,
      page: () => const AddShiftInformationView(),
      binding: AddShiftInformationBinding(),
    ),
    GetPage(
      name: _Paths.SHIFT_DETAILS,
      page: () => const ShiftDetailsView(),
      binding: ShiftDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CERTIFICATION,
      page: () => const CertificationView(),
      binding: CertificationBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CERTIFICATION,
      page: () => const AddCertificationView(),
      binding: AddCertificationBinding(),
    ),
    GetPage(
      name: _Paths.CERTIFICATION_DETAILS,
      page: () => const CertificationDetailsView(),
      binding: CertificationDetailsBinding(),
    ),
    GetPage(
      name: _Paths.REMINDER_TO_PARENTS_INFORMATION,
      page: () => const ReminderToParentsInformationView(),
      binding: ReminderToParentsInformationBinding(),
    ),
    GetPage(
      name: _Paths.UPCOMING_BIRTHDAY,
      page: () => const UpcomingBirthdayView(),
      binding: UpcomingBirthdayBinding(),
    ),
    GetPage(
      name: _Paths.EMERGENCY_LIST,
      page: () => const EmergencyListView(),
      binding: EmergencyListBinding(),
    ),
    GetPage(
      name: _Paths.PROGRAM_LIST,
      page: () => const ProgramListView(),
      binding: ProgramListBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PROGRAM,
      page: () => const AddProgramView(),
      binding: AddProgramBinding(),
    ),
    GetPage(
      name: _Paths.ASSIGNED_STUDENT,
      page: () => const AssignedStudentView(),
      binding: AssignedStudentBinding(),
    ),
    GetPage(
      name: _Paths.STAFF_DAILY_ATTENDANCE,
      page: () => const StaffDailyAttendanceView(),
      binding: StaffDailyAttendanceBinding(),
    ),
    GetPage(
      name: _Paths.BIRTHDAY_DETAILS,
      page: () => const BirthdayDetailsView(),
      binding: BirthdayDetailsBinding(),
    ),
  ];
}
