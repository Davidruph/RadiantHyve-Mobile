class ListStudentsDiaperAndBathModel {
  int? status;
  String? message;
  int? totalData;
  int? currentPage;
  int? totalPage;
  List<ListStudentsDiaperAndBathData>? data;

  ListStudentsDiaperAndBathModel(
      {this.status,
        this.message,
        this.totalData,
        this.currentPage,
        this.totalPage,
        this.data});

  ListStudentsDiaperAndBathModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalData = json['total_data'];
    currentPage = json['current_page'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = <ListStudentsDiaperAndBathData>[];
      json['data'].forEach((v) {
        data!.add(new ListStudentsDiaperAndBathData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_data'] = this.totalData;
    data['current_page'] = this.currentPage;
    data['total_page'] = this.totalPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListStudentsDiaperAndBathData {
  int? id;
  int? studentId;
  int? teacherId;
  int? parentId;
  String? reason;
  String? createdAt;
  String? updatedAt;
  String? studentName;
  String? teacherName;

  ListStudentsDiaperAndBathData(
      {this.id,
        this.studentId,
        this.teacherId,
        this.parentId,
        this.reason,
        this.createdAt,
        this.updatedAt,
        this.studentName,
        this.teacherName});

  ListStudentsDiaperAndBathData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    teacherId = json['teacher_id'];
    parentId = json['parent_id'];
    reason = json['reason'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    studentName = json['student_name'];
    teacherName = json['teacher_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['teacher_id'] = this.teacherId;
    data['parent_id'] = this.parentId;
    data['reason'] = this.reason;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['student_name'] = this.studentName;
    data['teacher_name'] = this.teacherName;
    return data;
  }
}
