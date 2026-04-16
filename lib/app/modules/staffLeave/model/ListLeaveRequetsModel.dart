class ListLeaveRequetsModel {
  int? status;
  String? message;
  int? totalLeave;
  int? currentPage;
  int? totalPage;
  List<ListLeaveRequetsData>? listLeaveRequetsData;

  ListLeaveRequetsModel({this.status, this.message, this.totalLeave, this.currentPage, this.totalPage, this.listLeaveRequetsData});

  ListLeaveRequetsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalLeave = json['total_leave'];
    currentPage = json['current_page'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      listLeaveRequetsData = <ListLeaveRequetsData>[];
      json['data'].forEach((v) {
        listLeaveRequetsData!.add(new ListLeaveRequetsData.fromJson(v));
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
    if (this.listLeaveRequetsData != null) {
      data['data'] = this.listLeaveRequetsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListLeaveRequetsData {
  int? id;
  String? leaveType;
  String? date;
  String? reason;
  String? leaveRequestStatus;
  int? teacherId;
  int? schoolId;
  String? createdAt;
  String? updatedAt;
  String? teacherName;
  bool? isAcceptLoader;
  bool? isRejectLoader;

  ListLeaveRequetsData({
    this.id,
    this.leaveType,
    this.date,
    this.reason,
    this.leaveRequestStatus,
    this.teacherId,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.teacherName,
    this.isAcceptLoader = false,
    this.isRejectLoader = false,
  });

  ListLeaveRequetsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leaveType = json['leave_type'];
    date = json['date'];
    reason = json['reason'];
    leaveRequestStatus = json['leave_request_status'];
    teacherId = json['teacher_id'];
    schoolId = json['school_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    teacherName = json['teacher_name'];
    isAcceptLoader = json['isAcceptLoader'] ?? false;
    isRejectLoader = json['isRejectLoader'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['leave_type'] = this.leaveType;
    data['date'] = this.date;
    data['reason'] = this.reason;
    data['leave_request_status'] = this.leaveRequestStatus;
    data['teacher_id'] = this.teacherId;
    data['school_id'] = this.schoolId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['teacher_name'] = this.teacherName;
    data['isAcceptLoader'] = this.isAcceptLoader;
    data['isRejectLoader'] = this.isRejectLoader;
    return data;
  }
}
