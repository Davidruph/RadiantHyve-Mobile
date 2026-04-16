class SleepLogsModel {
  int? status;
  String? message;
  SleepLogsData? data;

  SleepLogsModel({this.status, this.message, this.data});

  SleepLogsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SleepLogsData.fromJson(json['data']) : null;
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

class SleepLogsData {
  int? id;
  var startTime;
  var endTime;
  var studentName;
  var studentId;
  var adminId;
  var parentId;
  var createdAt;
  var updatedAt;

  SleepLogsData(
      {this.id,
        this.startTime,
        this.endTime,
        this.studentName,
        this.studentId,
        this.adminId,
        this.parentId,
        this.createdAt,
        this.updatedAt});

  SleepLogsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    studentName = json['student_name'];
    studentId = json['student_id'];
    adminId = json['admin_id'];
    parentId = json['parent_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['student_name'] = this.studentName;
    data['student_id'] = this.studentId;
    data['admin_id'] = this.adminId;
    data['parent_id'] = this.parentId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
