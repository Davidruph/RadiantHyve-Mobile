
class ListStudentsFeesModel {
  int? status;
  String? message;
  List<ListStudentsFeesData>? data;
  String? currentPage;
  int? totalPage;

  ListStudentsFeesModel(
      {this.status, this.message, this.data, this.currentPage, this.totalPage});

  ListStudentsFeesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ListStudentsFeesData>[];
      json['data'].forEach((v) {
        data!.add(new ListStudentsFeesData.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    totalPage = json['total_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['current_page'] = this.currentPage;
    data['total_page'] = this.totalPage;
    return data;
  }
}

class ListStudentsFeesData {
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
  var shiftFee;

  ListStudentsFeesData(
      {this.id,
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
        this.shiftFee});

  ListStudentsFeesData.fromJson(Map<String, dynamic> json) {
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
    shiftFee = json['shift_fee'];
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
    data['shift_fee'] = this.shiftFee;
    return data;
  }
}
