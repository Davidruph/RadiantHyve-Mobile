class ListSleepLogsStudentModel {
  int? status;
  String? message;
  int? totalStudent;
  int? currentPage;
  int? totalPage;
  List<ListSleepLogsStudentData>? data;

  ListSleepLogsStudentModel({this.status, this.message, this.totalStudent, this.currentPage, this.totalPage, this.data});

  ListSleepLogsStudentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalStudent = json['total_student'];
    currentPage = json['current_page'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      data = <ListSleepLogsStudentData>[];
      json['data'].forEach((v) {
        data!.add(new ListSleepLogsStudentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_student'] = this.totalStudent;
    data['current_page'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListSleepLogsStudentData {
  int? id;
  int? parentId;
  var email;
  var isoCode;
  var countryCode;
  int? mobileNo;
  var fullName;
  var parentName;
  var profilePic;
  var gender;
  var dob;
  var relationToChild;
  var madicalInsuaranceNo;
  var address;
  var requestStatus;
  int? shiftId;
  int? teacherId;
  int? schoolId;
  var createdAt;
  var updatedAt;
  SleepLoag? sleepLoag;

  ListSleepLogsStudentData({
    this.id,
    this.parentId,
    this.email,
    this.isoCode,
    this.countryCode,
    this.mobileNo,
    this.fullName,
    this.parentName,
    this.profilePic,
    this.gender,
    this.dob,
    this.relationToChild,
    this.madicalInsuaranceNo,
    this.address,
    this.requestStatus,
    this.shiftId,
    this.teacherId,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.sleepLoag,
  });

  ListSleepLogsStudentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    email = json['email'];
    isoCode = json['iso_code'];
    countryCode = json['country_code'];
    mobileNo = json['mobile_no'];
    fullName = json['full_name'];
    parentName = json['parent_name'];
    profilePic = json['profile_pic'];
    gender = json['gender'];
    dob = json['dob'];
    relationToChild = json['relation_to_child'];
    madicalInsuaranceNo = json['madical_insuarance_no'];
    address = json['address'];
    requestStatus = json['request_status'];
    shiftId = json['shift_id'];
    teacherId = json['teacher_id'];
    schoolId = json['school_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sleepLoag = json['SleepLoag'] != null ? new SleepLoag.fromJson(json['SleepLoag']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['email'] = this.email;
    data['iso_code'] = this.isoCode;
    data['country_code'] = this.countryCode;
    data['mobile_no'] = this.mobileNo;
    data['full_name'] = this.fullName;
    data['parent_name'] = this.parentName;
    data['profile_pic'] = this.profilePic;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['relation_to_child'] = this.relationToChild;
    data['madical_insuarance_no'] = this.madicalInsuaranceNo;
    data['address'] = this.address;
    data['request_status'] = this.requestStatus;
    data['shift_id'] = this.shiftId;
    data['teacher_id'] = this.teacherId;
    data['school_id'] = this.schoolId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.sleepLoag != null) {
      data['SleepLoag'] = this.sleepLoag!.toJson();
    }
    return data;
  }
}

class SleepLoag {
  int? id;
  var startTime;
  var endTime;
  var studentName;
  var studentId;
  var adminId;
  var parentId;
  String? createdAt;
  String? updatedAt;
  var studentSleepLoagId;

  SleepLoag({
    this.id,
    this.startTime,
    this.endTime,
    this.studentName,
    this.studentId,
    this.adminId,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.studentSleepLoagId,
  });

  SleepLoag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    studentName = json['student_name'];
    studentId = json['student_id'];
    adminId = json['admin_id'];
    parentId = json['parent_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    studentSleepLoagId = json['studentSleepLoagId'];
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
    data['studentSleepLoagId'] = this.studentSleepLoagId;
    return data;
  }
}
