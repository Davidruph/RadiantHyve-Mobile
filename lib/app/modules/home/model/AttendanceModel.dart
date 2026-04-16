class AttendanceModel {
  int? status;
  String? message;
  Data? data;

  AttendanceModel({this.status, this.message, this.data});

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? id;
  int? userId;
  int? schoolId;
  bool? isClockIn;
  String? date;
  String? clockInTime;
  var clockOutTime;
  String? clockInAddress;
  var clockInLatitude;
  var clockInLongitude;
  String? role;
  String? updatedAt;
  String? createdAt;

  Data({
    this.id,
    this.userId,
    this.schoolId,
    this.isClockIn,
    this.date,
    this.clockInTime,
    this.clockOutTime,
    this.clockInAddress,
    this.clockInLatitude,
    this.clockInLongitude,
    this.role,
    this.updatedAt,
    this.createdAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    schoolId = json['school_id'];
    isClockIn = json['is_clock_in'];
    date = json['date'];
    clockInTime = json['clock_in_time'];
    clockOutTime = json['clock_out_time'];
    clockInAddress = json['clock_in_address'];
    clockInLatitude = json['clock_in_latitude'];
    clockInLongitude = json['clock_in_longitude'];
    role = json['role'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['school_id'] = this.schoolId;
    data['is_clock_in'] = this.isClockIn;
    data['date'] = this.date;
    data['clock_in_time'] = this.clockInTime;
    data['clock_out_time'] = this.clockOutTime;
    data['clock_in_address'] = this.clockInAddress;
    data['clock_in_latitude'] = this.clockInLatitude;
    data['clock_in_longitude'] = this.clockInLongitude;
    data['role'] = this.role;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
