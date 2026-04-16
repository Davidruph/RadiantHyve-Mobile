class listParentModel {
  int? status;
  String? message;
  int? totalParent;
  int? currentPage;
  int? totalPage;
  List<ParentModelData>? parentsData;

  listParentModel({this.status, this.message, this.totalParent, this.currentPage, this.totalPage, this.parentsData});

  listParentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalParent = json['total_parent'];
    currentPage = json['current_page'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      parentsData = <ParentModelData>[];
      json['data'].forEach((v) {
        parentsData!.add(new ParentModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_parent'] = this.totalParent;
    data['current_page'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.parentsData != null) {
      data['data'] = this.parentsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParentModelData {
  int? id;
  String? email;
  String? password;
  int? mobileNo;
  String? countryCode;
  String? isoCode;
  String? profilePic;
  String? address;
  String? fullName;
  bool? isBlocked;
  bool? isDeleted;
  int? totalStudent;

  ParentModelData({
    this.id,
    this.email,
    this.password,
    this.mobileNo,
    this.countryCode,
    this.isoCode,
    this.profilePic,
    this.address,
    this.fullName,
    this.isBlocked,
    this.isDeleted,
    this.totalStudent,
  });

  ParentModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    mobileNo = json['mobile_no'];
    countryCode = json['country_code'];
    isoCode = json['iso_code'];
    profilePic = json['profile_pic'];
    address = json['address'];
    fullName = json['full_name'];
    isBlocked = json['is_blocked'];
    isDeleted = json['is_deleted'];
    totalStudent = json['total_student'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobile_no'] = this.mobileNo;
    data['country_code'] = this.countryCode;
    data['iso_code'] = this.isoCode;
    data['profile_pic'] = this.profilePic;
    data['address'] = this.address;
    data['full_name'] = this.fullName;
    data['is_blocked'] = this.isBlocked;
    data['is_deleted'] = this.isDeleted;
    data['total_student'] = this.totalStudent;
    return data;
  }
}
