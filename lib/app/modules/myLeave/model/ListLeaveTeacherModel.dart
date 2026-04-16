class ListLeaveTeacherModel {
  int? status;
  String? message;
  int? totalLeave;
  int? currentPage;
  int? totalPage;
  List<ListLeaveTeacherData>? data;

  ListLeaveTeacherModel({this.status, this.message, this.totalLeave, this.currentPage, this.totalPage, this.data});

  ListLeaveTeacherModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalLeave = json['total_leave'];
    currentPage = json['current_page'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      data = <ListLeaveTeacherData>[];
      json['data'].forEach((v) {
        data!.add(new ListLeaveTeacherData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_leave'] = this.totalLeave;
    data['current_page'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListLeaveTeacherData {
  int? id;
  var leaveType;
  var date;
  var reason;
  var leaveRequestStatus;
  var teacherId;
  var createdAt;
  var updatedAt;

  ListLeaveTeacherData({this.id, this.leaveType, this.date, this.reason, this.leaveRequestStatus, this.teacherId, this.createdAt, this.updatedAt});

  ListLeaveTeacherData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leaveType = json['leave_type'];
    date = json['date'];
    reason = json['reason'];
    leaveRequestStatus = json['leave_request_status'];
    teacherId = json['teacher_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['leave_type'] = this.leaveType;
    data['date'] = this.date;
    data['reason'] = this.reason;
    data['leave_request_status'] = this.leaveRequestStatus;
    data['teacher_id'] = this.teacherId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
