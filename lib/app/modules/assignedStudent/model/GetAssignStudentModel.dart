class GetAssignStudentModel {
  int? status;
  String? message;
  int? totalSchool;
  int? currentPage;
  int? totalPage;
  List<GetAssignStudentData>? data;

  GetAssignStudentModel({this.status, this.message, this.totalSchool, this.currentPage, this.totalPage, this.data});

  GetAssignStudentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalSchool = json['total_school'];
    currentPage = json['current_page'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      data = <GetAssignStudentData>[];
      json['data'].forEach((v) {
        data!.add(new GetAssignStudentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_school'] = this.totalSchool;
    data['current_page'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetAssignStudentData {
  int? id;
  var parentId;
  var email;
  var isoCode;
  var countryCode;
  var mobileNo;
  var fullName;
  var parentName;
  var profilePic;
  var gender;
  var dob;
  var relationToChild;
  var madicalInsuaranceNo;
  var address;
  var requestStatus;
  var shiftId;
  var teacherId;
  var schoolId;
  var createdAt;
  var updatedAt;
  var shiftName;
  var teacherName;

  GetAssignStudentData({
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
    this.shiftName,
    this.teacherName,
  });

  GetAssignStudentData.fromJson(Map<String, dynamic> json) {
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
    shiftName = json['shift_name'];
    teacherName = json['teacher_name'];
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
    data['shift_name'] = this.shiftName;
    data['teacher_name'] = this.teacherName;
    return data;
  }
}
