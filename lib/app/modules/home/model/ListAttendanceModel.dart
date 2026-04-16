class ListAttendanceModel {
  int? status;
  String? message;
  bool? isClockIn;
  int? totalAttendance;
  int? currentPage;
  int? totalPage;
  List<AttendanceData>? attendanceData;

  ListAttendanceModel({this.status, this.message, this.isClockIn, this.totalAttendance, this.currentPage, this.totalPage, this.attendanceData});

  ListAttendanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isClockIn = json['is_clock_in'];
    totalAttendance = json['total_attendance'];
    currentPage = json['current_page'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      attendanceData = <AttendanceData>[];
      json['data'].forEach((v) {
        attendanceData!.add(new AttendanceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['is_clock_in'] = this.isClockIn;
    data['total_attendance'] = this.totalAttendance;
    data['current_page'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.attendanceData != null) {
      data['data'] = this.attendanceData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceData {
  int? id;
  String? date;
  String? clockInTime;
  String? clockOutTime;
  bool? isClockIn;
  String? role;
  String? clockInAddress;
  String? clockInLatitude;
  String? clockInLongitude;
  String? clockOutAddress;
  String? clockOutLatitude;
  String? clockOutLongitude;
  int? userId;
  int? schoolId;
  String? createdAt;
  String? updatedAt;

  AttendanceData({
    this.id,
    this.date,
    this.clockInTime,
    this.clockOutTime,
    this.isClockIn,
    this.role,
    this.clockInAddress,
    this.clockInLatitude,
    this.clockInLongitude,
    this.clockOutAddress,
    this.clockOutLatitude,
    this.clockOutLongitude,
    this.userId,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
  });

  AttendanceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    clockInTime = json['clock_in_time'];
    clockOutTime = json['clock_out_time'];
    isClockIn = json['is_clock_in'];
    role = json['role'];
    clockInAddress = json['clock_in_address'];
    clockInLatitude = json['clock_in_latitude'];
    clockInLongitude = json['clock_in_longitude'];
    clockOutAddress = json['clock_out_address'];
    clockOutLatitude = json['clock_out_latitude'];
    clockOutLongitude = json['clock_out_longitude'];
    userId = json['user_id'];
    schoolId = json['school_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['clock_in_time'] = this.clockInTime;
    data['clock_out_time'] = this.clockOutTime;
    data['is_clock_in'] = this.isClockIn;
    data['role'] = this.role;
    data['clock_in_address'] = this.clockInAddress;
    data['clock_in_latitude'] = this.clockInLatitude;
    data['clock_in_longitude'] = this.clockInLongitude;
    data['clock_out_address'] = this.clockOutAddress;
    data['clock_out_latitude'] = this.clockOutLatitude;
    data['clock_out_longitude'] = this.clockOutLongitude;
    data['user_id'] = this.userId;
    data['school_id'] = this.schoolId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
