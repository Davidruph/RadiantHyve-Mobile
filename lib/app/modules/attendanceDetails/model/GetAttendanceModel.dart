class GetAttendanceModel {
  int? status;
  String? message;
  GetAttendanceData? data;

  GetAttendanceModel({this.status, this.message, this.data});

  GetAttendanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new GetAttendanceData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GetAttendanceData {
  int? id;
  var date;
  var clockInTime;
  var clockOutTime;
  bool? isClockIn;
  var role;
  var clockInAddress;
  var clockInLatitude;
  var clockInLongitude;
  var clockOutAddress;
  var clockOutLatitude;
  var clockOutLongitude;
  int? userId;
  int? schoolId;
  String? createdAt;
  String? updatedAt;

  GetAttendanceData({
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

  GetAttendanceData.fromJson(Map<String, dynamic> json) {
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
