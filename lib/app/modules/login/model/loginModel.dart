class LoginModel {
  int? status;
  String? message;
  String? token;
  String? refreshToken;
  var tokenId;
  LoginData? data;

  LoginModel({this.status, this.message, this.token, this.refreshToken, this.data,this.tokenId});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    refreshToken = json['refresh_token'];
    tokenId = json['token_id'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    data['token'] = token;
    data['refresh_token'] = refreshToken;
    data['token_id'] = tokenId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  int? id;
  String? email;
  String? isoCode;
  String? countryCode;
  var mobileNo;
  String? password;
  bool? isEmailVerify;
  String? loginType;
  var otp;
  var otpCreatedAt;
  var fullName;
  var role;
  var profilePic;
  var gender;
  var dob;
  var qualification;
  var designation;
  String? experience;
  String? joiningDate;
  var address;
  String? aboutStaff;
  var schoolName;
  int? schoolId;
  bool? isBlocked;
  String? subscriptionPlan;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  LoginData({
    this.id,
    this.email,
    this.isoCode,
    this.countryCode,
    this.mobileNo,
    this.password,
    this.isEmailVerify,
    this.loginType,
    this.otp,
    this.otpCreatedAt,
    this.fullName,
    this.role,
    this.profilePic,
    this.gender,
    this.dob,
    this.qualification,
    this.designation,
    this.experience,
    this.joiningDate,
    this.address,
    this.aboutStaff,
    this.schoolName,
    this.schoolId,
    this.isBlocked,
    this.subscriptionPlan,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    isoCode = json['iso_code'];
    countryCode = json['country_code'];
    mobileNo = json['mobile_no'];
    password = json['password'];
    isEmailVerify = json['is_email_verify'];
    loginType = json['login_type'];
    otp = json['otp'];
    otpCreatedAt = json['otp_created_at'];
    fullName = json['full_name'];
    role = json['role'];
    profilePic = json['profile_pic'];
    gender = json['gender'];
    dob = json['dob'];
    qualification = json['qualification'];
    designation = json['designation'];
    experience = json['experience'];
    joiningDate = json['joining_date'];
    address = json['address'];
    aboutStaff = json['about_staff'];
    schoolName = json['school_name'];
    schoolId = json['school_id'];
    isBlocked = json['is_blocked'];
    subscriptionPlan = json['subscription_plan'];
    isDeleted = json['is_deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['iso_code'] = this.isoCode;
    data['country_code'] = this.countryCode;
    data['mobile_no'] = this.mobileNo;
    data['password'] = this.password;
    data['is_email_verify'] = this.isEmailVerify;
    data['login_type'] = this.loginType;
    data['otp'] = this.otp;
    data['otp_created_at'] = this.otpCreatedAt;
    data['full_name'] = this.fullName;
    data['role'] = this.role;
    data['profile_pic'] = this.profilePic;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['qualification'] = this.qualification;
    data['designation'] = this.designation;
    data['experience'] = this.experience;
    data['joining_date'] = this.joiningDate;
    data['address'] = this.address;
    data['about_staff'] = this.aboutStaff;
    data['school_name'] = this.schoolName;
    data['school_id'] = this.schoolId;
    data['is_blocked'] = this.isBlocked;
    data['subscription_plan'] = this.subscriptionPlan;
    data['is_deleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
