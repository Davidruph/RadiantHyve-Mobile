class StaffDetailsModel {
  int? status;
  String? message;
  StaffDetailsData? staffDetailsData;

  StaffDetailsModel({this.status, this.message, this.staffDetailsData});

  StaffDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    staffDetailsData = json['data'] != null ? new StaffDetailsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.staffDetailsData != null) {
      data['data'] = this.staffDetailsData!.toJson();
    }
    return data;
  }
}

class StaffDetailsData {
  int? id;
  String? email;
  String? password;
  String? fullName;
  String? gender;
  String? dob;
  String? aboutStaff;
  String? joiningDate;
  String? experience;
  var mobileNo;
  String? countryCode;
  String? isoCode;
  String? profilePic;
  bool? isBlocked;
  bool? isDeleted;
  int? totalStudent;
  int? chatId;

  StaffDetailsData({
    this.id,
    this.email,
    this.password,
    this.fullName,
    this.gender,
    this.dob,
    this.aboutStaff,
    this.joiningDate,
    this.experience,
    this.mobileNo,
    this.countryCode,
    this.isoCode,
    this.profilePic,
    this.isBlocked,
    this.isDeleted,
    this.totalStudent,
    this.chatId,
  });

  StaffDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    fullName = json['full_name'];
    gender = json['gender'];
    dob = json['dob'];
    aboutStaff = json['about_staff'];
    joiningDate = json['joining_date'];
    experience = json['experience'];
    mobileNo = json['mobile_no'];
    countryCode = json['country_code'];
    isoCode = json['iso_code'];
    profilePic = json['profile_pic'];
    isBlocked = json['is_blocked'];
    isDeleted = json['is_deleted'];
    totalStudent = json['total_student'];
    chatId = json['chat_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['full_name'] = this.fullName;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['about_staff'] = this.aboutStaff;
    data['joining_date'] = this.joiningDate;
    data['experience'] = this.experience;
    data['mobile_no'] = this.mobileNo;
    data['country_code'] = this.countryCode;
    data['iso_code'] = this.isoCode;
    data['profile_pic'] = this.profilePic;
    data['is_blocked'] = this.isBlocked;
    data['is_deleted'] = this.isDeleted;
    data['total_student'] = this.totalStudent;
    data['chat_id'] = this.chatId;
    return data;
  }
}
