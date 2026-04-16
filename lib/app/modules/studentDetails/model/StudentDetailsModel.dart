// class StudentDetailsModel {
//   int? status;
//   String? messsage;
//   StudentDetailsData? data;
//
//   StudentDetailsModel({this.status, this.messsage, this.data});
//
//   StudentDetailsModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     messsage = json['messsage'];
//     data = json['data'] != null ? new StudentDetailsData.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['messsage'] = this.messsage;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class StudentDetailsData {
//   int? id;
//   int? parentId;
//   String? email;
//   String? isoCode;
//   String? countryCode;
//   int? mobileNo;
//   String? fullName;
//   String? parentName;
//   String? profilePic;
//   String? gender;
//   String? dob;
//   String? relationToChild;
//   String? madicalInsuaranceNo;
//   String? address;
//   String? requestStatus;
//   int? shiftId;
//   int? teacherId;
//   int? schoolId;
//   String? createdAt;
//   String? updatedAt;
//   String? shiftName;
//   String? teacherName;
//   StudentParent? studentParent;
//
//   StudentDetailsData({
//     this.id,
//     this.parentId,
//     this.email,
//     this.isoCode,
//     this.countryCode,
//     this.mobileNo,
//     this.fullName,
//     this.parentName,
//     this.profilePic,
//     this.gender,
//     this.dob,
//     this.relationToChild,
//     this.madicalInsuaranceNo,
//     this.address,
//     this.requestStatus,
//     this.shiftId,
//     this.teacherId,
//     this.schoolId,
//     this.createdAt,
//     this.updatedAt,
//     this.shiftName,
//     this.teacherName,
//     this.studentParent,
//   });
//
//   StudentDetailsData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     parentId = json['parent_id'];
//     email = json['email'];
//     isoCode = json['iso_code'];
//     countryCode = json['country_code'];
//     mobileNo = json['mobile_no'];
//     fullName = json['full_name'];
//     parentName = json['parent_name'];
//     profilePic = json['profile_pic'];
//     gender = json['gender'];
//     dob = json['dob'];
//     relationToChild = json['relation_to_child'];
//     madicalInsuaranceNo = json['madical_insuarance_no'];
//     address = json['address'];
//     requestStatus = json['request_status'];
//     shiftId = json['shift_id'];
//     teacherId = json['teacher_id'];
//     schoolId = json['school_id'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     shiftName = json['shift_name'];
//     teacherName = json['teacher_name'];
//     studentParent =
//         json['StudentParent'] != null ? new StudentParent.fromJson(json['StudentParent']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['parent_id'] = this.parentId;
//     data['email'] = this.email;
//     data['iso_code'] = this.isoCode;
//     data['country_code'] = this.countryCode;
//     data['mobile_no'] = this.mobileNo;
//     data['full_name'] = this.fullName;
//     data['parent_name'] = this.parentName;
//     data['profile_pic'] = this.profilePic;
//     data['gender'] = this.gender;
//     data['dob'] = this.dob;
//     data['relation_to_child'] = this.relationToChild;
//     data['madical_insuarance_no'] = this.madicalInsuaranceNo;
//     data['address'] = this.address;
//     data['request_status'] = this.requestStatus;
//     data['shift_id'] = this.shiftId;
//     data['teacher_id'] = this.teacherId;
//     data['school_id'] = this.schoolId;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['shift_name'] = this.shiftName;
//     data['teacher_name'] = this.teacherName;
//     if (this.studentParent != null) {
//       data['StudentParent'] = this.studentParent!.toJson();
//     }
//     return data;
//   }
// }
//
// class StudentParent {
//   int? id;
//   String? fullName;
//   String? gender;
//   Null? address;
//   int? mobileNo;
//   String? countryCode;
//   String? isoCode;
//
//   StudentParent({
//     this.id,
//     this.fullName,
//     this.gender,
//     this.address,
//     this.mobileNo,
//     this.countryCode,
//     this.isoCode,
//   });
//
//   StudentParent.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     fullName = json['full_name'];
//     gender = json['gender'];
//     address = json['address'];
//     mobileNo = json['mobile_no'];
//     countryCode = json['country_code'];
//     isoCode = json['iso_code'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['full_name'] = this.fullName;
//     data['gender'] = this.gender;
//     data['address'] = this.address;
//     data['mobile_no'] = this.mobileNo;
//     data['country_code'] = this.countryCode;
//     data['iso_code'] = this.isoCode;
//     return data;
//   }
// }

class StudentDetailsModel {
  int? status;
  String? messsage;
  StudentDetailsData? data;

  StudentDetailsModel({this.status, this.messsage, this.data});

  StudentDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messsage = json['messsage'];
    data = json['data'] != null ? new StudentDetailsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messsage'] = this.messsage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StudentDetailsData {
  int? id;
  var parentId;
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
  StudentParent? studentParent;

  StudentDetailsData({
    this.id,
    this.parentId,
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
    this.studentParent,
  });

  StudentDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
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
    studentParent = json['StudentParent'] != null ? new StudentParent.fromJson(json['StudentParent']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
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
    if (this.studentParent != null) {
      data['StudentParent'] = this.studentParent!.toJson();
    }
    return data;
  }
}

class StudentParent {
  int? id;
  String? fullName;
  String? gender;
  var address;
  int? mobileNo;
  String? countryCode;
  String? isoCode;
  String? profilePic;
  var chatId;

  StudentParent({this.id, this.fullName, this.gender, this.address, this.mobileNo, this.countryCode, this.isoCode, this.profilePic, this.chatId});

  StudentParent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    gender = json['gender'];
    address = json['address'];
    mobileNo = json['mobile_no'];
    countryCode = json['country_code'];
    isoCode = json['iso_code'];
    profilePic = json['profile_pic'];
    chatId = json['chat_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['mobile_no'] = this.mobileNo;
    data['country_code'] = this.countryCode;
    data['iso_code'] = this.isoCode;
    data['profile_pic'] = this.profilePic;
    data['chat_id'] = this.chatId;
    return data;
  }
}
