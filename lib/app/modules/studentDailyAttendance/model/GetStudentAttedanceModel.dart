class GetStudentAttedanceModel {
  int? status;
  String? message;
  int? totalAttedance;
  int? currentPage;
  int? totalPage;
  List<GetStudentAttedanceData>? data;

  GetStudentAttedanceModel({
    this.status,
    this.message,
    this.totalAttedance,
    this.currentPage,
    this.totalPage,
    this.data,
  });

  GetStudentAttedanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalAttedance = json['total_attedance'];
    currentPage = json['current_page'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = <GetStudentAttedanceData>[];
      json['data'].forEach((v) {
        data!.add(new GetStudentAttedanceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_attedance'] = this.totalAttedance;
    data['current_page'] = this.currentPage;
    data['total_page'] = this.totalPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetStudentAttedanceData {
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

  GetStudentAttedanceData({
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

  GetStudentAttedanceData.fromJson(Map<String, dynamic> json) {
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
