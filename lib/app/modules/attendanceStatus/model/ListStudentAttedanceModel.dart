class ListStudentAttedanceModel {
  int? status;
  String? message;
  int? totalAttedance;
  int? currentPage;
  int? totalPage;
  bool? isSubmitted;
  List<ListStudentAttedanceData>? data;
  bool? isClockoutAllStudent;

  ListStudentAttedanceModel(
      {this.status,
        this.message,
        this.totalAttedance,
        this.currentPage,
        this.totalPage,
        this.isSubmitted,
        this.data,
        this.isClockoutAllStudent});

  ListStudentAttedanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalAttedance = json['total_attedance'];
    currentPage = json['current_page'];
    totalPage = json['total_page'];
    isSubmitted = json['is_submitted'];
    if (json['data'] != null) {
      data = <ListStudentAttedanceData>[];
      json['data'].forEach((v) {
        data!.add(new ListStudentAttedanceData.fromJson(v));
      });
    }
    isClockoutAllStudent = json['is_clockout_all_student'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_attedance'] = this.totalAttedance;
    data['current_page'] = this.currentPage;
    data['total_page'] = this.totalPage;
    data['is_submitted'] = this.isSubmitted;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['is_clockout_all_student'] = this.isClockoutAllStudent;
    return data;
  }
}

class ListStudentAttedanceData {
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
  var parentName;
  var relationToChild;
  var createdAt;
  var updatedAt;
  var studentName;

  ListStudentAttedanceData(
      {this.id,
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
        this.parentName,
        this.relationToChild,
        this.createdAt,
        this.updatedAt,
        this.studentName});

  ListStudentAttedanceData.fromJson(Map<String, dynamic> json) {
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
    parentName = json['parent_name'];
    relationToChild = json['relation_to_child'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    studentName = json['student_name'];
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
    data['parent_name'] = this.parentName;
    data['relation_to_child'] = this.relationToChild;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['student_name'] = this.studentName;
    return data;
  }
}
