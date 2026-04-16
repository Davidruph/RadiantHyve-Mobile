class StudentListModel {
  int? status;
  String? message;
  bool? isAttedance;
  int? totalStudent;
  int? currentPage;
  int? totalPage;
  var isSubmitted;
  List<StudentListData>? studentlistdata;

  StudentListModel({
    this.status,
    this.message,
    this.isAttedance,
    this.totalStudent,
    this.currentPage,
    this.totalPage,
    this.studentlistdata,
    this.isSubmitted,
  });

  StudentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isAttedance = json['is_attedance'];
    totalStudent = json['total_student'];
    currentPage = json['current_page'];
    totalPage = json['total_page'];
    isSubmitted = json['is_submitted'];
    if (json['data'] != null) {
      studentlistdata = <StudentListData>[];
      json['data'].forEach((v) {
        studentlistdata!.add(new StudentListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['is_attedance'] = this.isAttedance;
    data['total_student'] = this.totalStudent;
    data['current_page'] = this.currentPage;
    data['total_page'] = this.totalPage;
    data['is_submitted'] = this.isSubmitted;
    if (this.studentlistdata != null) {
      data['data'] = this.studentlistdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentListData {
  int? id;
  String? fullName;
  List<Attendance>? attendance;

  StudentListData({this.id, this.fullName, this.attendance});

  StudentListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    if (json['Attendance'] != null) {
      attendance = <Attendance>[];
      json['Attendance'].forEach((v) {
        attendance!.add(new Attendance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    if (this.attendance != null) {
      data['Attendance'] = this.attendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attendance {
  int? id;
  var date;
  var presentTime;
  var outTime;
  var isOut;
  var attendanceStatus;
  var studentId;
  var teacherId;
  var parentId;
  var schoolId;
  var isSubmitted;
  var createdAt;
  var updatedAt;
  var studentAttendanceId;

  Attendance({
    this.id,
    this.date,
    this.presentTime,
    this.outTime,
    this.isOut,
    this.attendanceStatus,
    this.studentId,
    this.teacherId,
    this.parentId,
    this.schoolId,
    this.isSubmitted,
    this.createdAt,
    this.updatedAt,
    this.studentAttendanceId,
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    presentTime = json['present_time'];
    outTime = json['out_time'];
    isOut = json['is_out'];
    attendanceStatus = json['attendance_status'];
    studentId = json['student_id'];
    teacherId = json['teacher_id'];
    parentId = json['parent_id'];
    schoolId = json['school_id'];
    isSubmitted = json['is_submitted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    studentAttendanceId = json['studentAttendanceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['present_time'] = this.presentTime;
    data['out_time'] = this.outTime;
    data['is_out'] = this.isOut;
    data['attendance_status'] = this.attendanceStatus;
    data['student_id'] = this.studentId;
    data['teacher_id'] = this.teacherId;
    data['parent_id'] = this.parentId;
    data['school_id'] = this.schoolId;
    data['is_submitted'] = this.isSubmitted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['studentAttendanceId'] = this.studentAttendanceId;
    return data;
  }
}
