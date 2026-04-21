class ApiUrl {
  /// Base URL
  // static String baseUrl = "https://app.radianthyve.com:8800";
  static String baseUrl = "http://localhost:8800";

  //========================= AUTH MODULE =========================//
  static String createToken = '$baseUrl/create_token';
  static String login = '$baseUrl/login';
  static String logout = '$baseUrl/logout';
  static String changePassword = '$baseUrl/change_password';
  static String forgotePassword = '$baseUrl/forgot_password';
  static String forgotPassword = '$baseUrl/forgot_password';
  static String forgotVerify = '$baseUrl/verify_otp';
  static String verifyOtp = '$baseUrl/verify_otp';
  static String resetPassword = '$baseUrl/reset_password';

  //========================= PROFILE =========================//
  static String editProfileParent = '$baseUrl/edit_profile_parent';
  static String editTeacherProfile = '$baseUrl/edit_teacher_profile';
  static String editPrincipalProfile = '$baseUrl/edit_principal_profile';

  //========================= NOTIFICATION MODULE =========================//
  static String listNotification = '$baseUrl/list_notification';

  //========================= STUDENT MODULE =========================//
  static String studentsList = '$baseUrl/students_list';
  static String listActiveStudent = '$baseUrl/list_active_student';
  static String listStudentAttedanceParent = '$baseUrl/list_student_attedance_parent';
  static String addStudent = '$baseUrl/add_student';
  static String editStudent = '$baseUrl/edit_student';
  static String deleteStudent = '$baseUrl/delete_student';
  static String studentGet = '$baseUrl/student_get';
  static String studentsDetails = '$baseUrl/students_details';
  static String listStudentTeacher = '$baseUrl/list_student_teacher';
  static String listStudentAttedance = '$baseUrl/list_student_attedance';
  static String getStudentAttedance = '$baseUrl/get_student_attedance';
  static String studentDetails = '$baseUrl/student_details';
  static String studentList = '$baseUrl/student_list';
  static String listStudents = '$baseUrl/list_students';
  static String listNewStudent = '$baseUrl/list_new_student';
  static String listAllStudent = '$baseUrl/list_all_student';
  static String getAllStudent = '$baseUrl/get_all_student';
  static String editStudentProfilePic = '$baseUrl/edit_student_profile_pic';
  static String editStudentStatus = '$baseUrl/edit_student_status';
  static String listTeacher = '$baseUrl/list_teacher';
  static String studentAssignTeacher = '$baseUrl/student_assign_teacher';
  static String teacherAllStudent = '$baseUrl/list_student_teacher';
  static String getAssignStudent = '$baseUrl/get_assign_student';
  static String getAllStudentAttedance = '$baseUrl/get_all_student_attedance';

  //========================= SHIFT & MENU MODULE =========================//
  static String getShift = '$baseUrl/get_shift';
  static String listShift = '$baseUrl/list_shift';
  static String addShift = '$baseUrl/add_shift';
  static String editShift = '$baseUrl/edit_shift';
  static String deleteShift = '$baseUrl/delete_shift';
  
  // Menu/Meal
  static String getMenu = '$baseUrl/get_menu';
  static String listMenu = '$baseUrl/list_menu';
  static String addMenu = '$baseUrl/add_menu';
  static String editMenu = '$baseUrl/edit_menu';
  static String deleteMenu = '$baseUrl/delete_menu';
  static String listMenuStudent = '$baseUrl/list_menu_student';

  //========================= ATTENDANCE MODULE =========================//
  static String attendance = '$baseUrl/attendance';
  static String attendanceList = '$baseUrl/attendance_list';
  static String getTodayAttendance = '$baseUrl/get_today_attendance';
  static String getAttendance = '$baseUrl/get_attendance';
  static String studentAttedance = '$baseUrl/student_attedance';
  static String submittedAttedance = '$baseUrl/submitted_attedance';
  static String getTodayAttendanceTeacher = '$baseUrl/get_today_attendance';
  static String getOtherAttendance = '$baseUrl/get_other_attendance';

  //========================= CHAT MODULE =========================//
  static String joinRoom = "join_room";
  static String leftRoom = "left_room";
  static String newMessage = "new_message";
  static String countUpdate = "count_update";
  static String socketRegister = "socket_register";
  static String joinGroup = "join_group";
  static String leftGroup = "left_group";
  static String newLessonChatMessage = "new_lesson_chat_message";
  static String lessonChatCountUpdate = "lesson_chat_count_update";
  
  static String createChat = "$baseUrl/create_personal_chat";
  static String getPersonalChatMessage = "$baseUrl/get_personal_chat_message";
  static String sendPersonalChatMessage = "$baseUrl/send_personal_chat_message";
  static String getPersonalChats = "$baseUrl/get_personal_chats";
  static String clearChat = "$baseUrl/clear_chat";
  static String listUserChat = "$baseUrl/list_user_chat";
  static String createLessonChat = "$baseUrl/create_lesson_chat";
  static String getLessonChatMessage = "$baseUrl/get_lesson_chat_message";
  static String sendLessonChatMessage = "$baseUrl/send_lesson_chat_message";

  //========================= DIAPER & BATH MODULE =========================//
  static String addDiaperAndBath = "$baseUrl/add_diaper_and_bath";
  static String listDiaperAndBath = "$baseUrl/list_diaper_and_bath";
  static String listStudentsDiaperAndBath = "$baseUrl/list_students_diaper_and_bath";

  //========================= STAFF MODULE (PRINCIPAL) =========================//
  static String listStaff = "$baseUrl/list_staff";
  static String addStaff = "$baseUrl/add_staff";
  static String getStaff = "$baseUrl/get_staff";
  static String editStaff = "$baseUrl/edit_staff";
  static String changeStaffPassword = "$baseUrl/change_staff_password";
  static String blockStaff = "$baseUrl/block_staff";
  static String deleteStaff = "$baseUrl/delete_staff";
  static String staffDetails = "$baseUrl/staff_details";
  static String staffList = "$baseUrl/staff_list";

  //========================= PARENTS MODULE (PRINCIPAL) =========================//
  static String listParent = "$baseUrl/list_parent";
  static String addParent = "$baseUrl/add_parent";
  static String getParent = "$baseUrl/get_parent";
  static String editParent = "$baseUrl/edit_parent";
  static String changeParentPassword = "$baseUrl/change_parent_password";
  static String blockParent = "$baseUrl/block_parent";
  static String deleteParent = "$baseUrl/delete_parent";
  static String parentsList = "$baseUrl/list_parent";
  static String parentsDetails = "$baseUrl/get_parent";

  //========================= LEAVE MODULE =========================//
  static String listLeaveRequets = "$baseUrl/list_leave_requets";
  static String updateLeaveStatus = "$baseUrl/update_leave_status";
  static String listLeaves = "$baseUrl/list_leaves";
  static String listLeaveTeacher = "$baseUrl/list_leave_teacher";
  static String staffApplyLeave = "$baseUrl/staff_apply_leave";
  static String cancelLeave = "$baseUrl/cancel_leave";

  //========================= SLEEP LOGS MODULE =========================//
  static String listSleepLoag = '$baseUrl/list_sleep_loag';
  static String addSleepLogs = '$baseUrl/add_sleep_loag';
  static String editSleepLogs = '$baseUrl/edit_sleep_loag';
  static String listSleepLoagStudent = '$baseUrl/list_sleep_loag_student';

  //========================= MEDICATION MODULE =========================//
  static String listMedification = '$baseUrl/list_medification';
  static String deleteMedification = '$baseUrl/delete_medification';
  static String addMedification = '$baseUrl/add_medification';
  static String editMedification = '$baseUrl/edit_medification';
  static String addMedication = '$baseUrl/add_medification';
  static String editMedication = '$baseUrl/edit_medification';
  static String listMedicationStudent = '$baseUrl/list_medification_student';

  //========================= FEES & PAYMENT MODULE =========================//
  static String listStudentsFees = "$baseUrl/list_students_fees";
  static String listStudentsInvoice = "$baseUrl/list_students_invoice";
  static String listStudentFees = '$baseUrl/list_student_fees';
  static String getInvoice = '$baseUrl/get_invoice';
  static String remainingFees = '$baseUrl/remaining_fees';
  static String makePayment = '$baseUrl/make_payment';

  //========================= CERTIFICATION MODULE (PRINCIPAL) =========================//
  static String addCertification = "$baseUrl/add_certification";
  static String listCertification = "$baseUrl/list_certification";
  static String editCertification = "$baseUrl/edit_certification";
  static String deleteCertification = "$baseUrl/delete_certification";

  //========================= CLASSROOM MODULE (PRINCIPAL) =========================//
  static String addClassroom = "$baseUrl/add_classroom";
  static String listClassroom = "$baseUrl/list_classroom";
  static String editClassroom = "$baseUrl/edit_classroom";
  static String deleteClassroom = "$baseUrl/delete_classroom";

  //========================= PROGRAM MODULE (PRINCIPAL) =========================//
  static String addProgram = "$baseUrl/add_program";
  static String listProgram = "$baseUrl/list_program";
  static String editProgram = "$baseUrl/edit_program";
  static String deleteProgram = "$baseUrl/delete_program";

  //========================= BIRTHDAY & SOS MODULE =========================//
  static String listUpcomingBirthday = '$baseUrl/list_upcoming_birthday';
  static String getSos = '$baseUrl/get_sos';
  static String createSos = '$baseUrl/create_sos';
}

