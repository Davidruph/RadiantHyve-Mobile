class ListStaffModel {
  int? status;
  String? message;
  int? totalStaff;
  int? currentPage;
  int? totalPage;
  List<StaffData>? staffData;

  ListStaffModel({
    this.status,
    this.message,
    this.totalStaff,
    this.currentPage,
    this.totalPage,
    this.staffData,
  });

  ListStaffModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalStaff = json['total_staff'];
    currentPage = json['current_page'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      staffData = <StaffData>[];
      json['data'].forEach((v) {
        staffData!.add(new StaffData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_staff'] = this.totalStaff;
    data['current_page'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.staffData != null) {
      data['data'] = this.staffData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffData {
  int? id;
  String? email;
  String? fullName;
  String? gender;
  bool? isBlocked;
  bool? isDeleted;
  var clockInTime;
  var clockOutTime;

  StaffData({
    this.id,
    this.email,
    this.fullName,
    this.gender,
    this.isBlocked,
    this.isDeleted,
    this.clockInTime,
    this.clockOutTime,
  });

  StaffData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['full_name'];
    gender = json['gender'];
    isBlocked = json['is_blocked'];
    isDeleted = json['is_deleted'];
    clockInTime = json['clock_in_time'];
    clockOutTime = json['clock_out_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    data['gender'] = this.gender;
    data['is_blocked'] = this.isBlocked;
    data['is_deleted'] = this.isDeleted;
    data['clock_in_time'] = this.clockInTime;
    data['clock_out_time'] = this.clockOutTime;
    return data;
  }
}
