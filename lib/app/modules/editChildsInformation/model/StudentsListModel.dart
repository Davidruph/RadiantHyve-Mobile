class StudentsListModel {
  int? status;
  String? message;
  int? totalStudent;
  int? currentPage;
  int? totalPage;
  List<StudentsListData>? data;

  StudentsListModel(
      {this.status,
        this.message,
        this.totalStudent,
        this.currentPage,
        this.totalPage,
        this.data});

  StudentsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalStudent = json['total_student'];
    currentPage = json['current_page'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = <StudentsListData>[];
      json['data'].forEach((v) {
        data!.add(new StudentsListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_student'] = this.totalStudent;
    data['current_page'] = this.currentPage;
    data['total_page'] = this.totalPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentsListData {
  int? id;
  int? parentId;
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
 var rejectedReason;
 var shiftId;
 var teacherId;
 var schoolId;
 var createdAt;
 var updatedAt;
 var shiftName;
 var teacherName;
 var chatId;
 var teacherProfilePic;

  StudentsListData(
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
        this.rejectedReason,
        this.createdAt,
        this.updatedAt,
        this.shiftName,this.teacherName,this.chatId,this.teacherProfilePic});

  StudentsListData.fromJson(Map<String, dynamic> json) {
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
    rejectedReason = json['rejected_reason'];
    shiftId = json['shift_id'];
    teacherId = json['teacher_id'];
    schoolId = json['school_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    shiftName = json['shift_name'];
    teacherName = json['teacher_name'];
    chatId = json['chat_id'];
    teacherProfilePic = json['teacher_profile_pic'];
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
    data['rejected_reason'] = this.rejectedReason;
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
    data['chat_id'] = this.chatId;
    data['teacher_profile_pic'] = this.teacherProfilePic;
    return data;
  }
}
