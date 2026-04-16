import '../../assignedStudent/model/GetAssignStudentModel.dart';

class ParentsDetailsModel {
  int? status;
  String? message;
  ParentsDetailsData? parentsDetailsData;

  ParentsDetailsModel({this.status, this.message, this.parentsDetailsData});

  ParentsDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    parentsDetailsData = json['data'] != null ? new ParentsDetailsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.parentsDetailsData != null) {
      data['data'] = this.parentsDetailsData!.toJson();
    }
    return data;
  }
}


class ParentsDetailsData {
  int? id;
  String? email;
  String? password;
  String? fullName;
  String? gender;
  int? mobileNo;
  String? countryCode;
  String? isoCode;
  String? profilePic;
  bool? isBlocked;
  bool? isDeleted;
  String? address;
  int? totalStudent;
  int? chatId;
  List<GetAssignStudentData>? students;

  ParentsDetailsData({
    this.id,
    this.email,
    this.password,
    this.fullName,
    this.gender,
    this.mobileNo,
    this.countryCode,
    this.isoCode,
    this.profilePic,
    this.isBlocked,
    this.isDeleted,
    this.address,
    this.totalStudent,
    this.students,
    this.chatId,
  });

  ParentsDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    fullName = json['full_name'];
    gender = json['gender'];
    mobileNo = json['mobile_no'];
    countryCode = json['country_code'];
    isoCode = json['iso_code'];
    profilePic = json['profile_pic'];
    isBlocked = json['is_blocked'];
    isDeleted = json['is_deleted'];
    address = json['address'];
    chatId = json['chat_id'];
    totalStudent = json['total_student'];
    if (json['Students'] != null) {
      students = <GetAssignStudentData>[];
      json['Students'].forEach((v) {
        students!.add(new GetAssignStudentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['full_name'] = this.fullName;
    data['gender'] = this.gender;
    data['mobile_no'] = this.mobileNo;
    data['country_code'] = this.countryCode;
    data['iso_code'] = this.isoCode;
    data['profile_pic'] = this.profilePic;
    data['is_blocked'] = this.isBlocked;
    data['is_deleted'] = this.isDeleted;
    data['address'] = this.address;
    data['total_student'] = this.totalStudent;
    data['chat_id'] = this.chatId;
    if (this.students != null) {
      data['Students'] = this.students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/*class Students {
  int? id;
  int? parentId;
  String? email;
  String? isoCode;
  String? countryCode;
  int? mobileNo;
  String? fullName;
  String? parentName;
  String? profilePic;
  String? gender;
  String? dob;
  String? relationToChild;
  String? madicalInsuaranceNo;
  String? address;
  String? requestStatus;
  int? shiftId;
  int? teacherId;
  int? schoolId;
  String? createdAt;
  String? updatedAt;

  Students({
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
  });

  Students.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}*/
