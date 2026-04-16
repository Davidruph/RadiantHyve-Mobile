class GetMenuModel {
  int? status;
  String? message;
  GetMenuData? data;

  GetMenuModel({this.status, this.message, this.data});

  GetMenuModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new GetMenuData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GetMenuData {
  int? id;
  var menuType;
  var menuDate;
  var menuTime;
  var aboutMeal;
  int? studentId;
  bool? isAll;
  int? adminId;
  int? schoolId;
  var createdAt;
  var updatedAt;
  var studentMenuId;
  List<MenuDay>? menuDay;
  Student? student;

  GetMenuData({
    this.id,
    this.menuType,
    this.menuDate,
    this.menuTime,
    this.aboutMeal,
    this.studentId,
    this.isAll,
    this.adminId,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.studentMenuId,
    this.menuDay,
    this.student,
  });

  GetMenuData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuType = json['menu_type'];
    menuDate = json['menu_date'];
    menuTime = json['menu_time'];
    aboutMeal = json['about_meal'];
    studentId = json['student_id'];
    isAll = json['is_all'];
    adminId = json['admin_id'];
    schoolId = json['school_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    studentMenuId = json['studentMenuId'];
    if (json['MenuDay'] != null) {
      menuDay = <MenuDay>[];
      json['MenuDay'].forEach((v) {
        menuDay!.add(new MenuDay.fromJson(v));
      });
    }
    student = json['student'] != null ? new Student.fromJson(json['student']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['menu_type'] = this.menuType;
    data['menu_date'] = this.menuDate;
    data['menu_time'] = this.menuTime;
    data['about_meal'] = this.aboutMeal;
    data['student_id'] = this.studentId;
    data['is_all'] = this.isAll;
    data['admin_id'] = this.adminId;
    data['school_id'] = this.schoolId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['studentMenuId'] = this.studentMenuId;
    if (this.menuDay != null) {
      data['MenuDay'] = this.menuDay!.map((v) => v.toJson()).toList();
    }
    if (this.student != null) {
      data['student'] = this.student!.toJson();
    }
    return data;
  }
}

class MenuDay {
  int? id;
  String? menuDay;
  int? menuId;
  String? createdAt;
  String? updatedAt;

  MenuDay({this.id, this.menuDay, this.menuId, this.createdAt, this.updatedAt});

  MenuDay.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuDay = json['menu_day'];
    menuId = json['menu_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['menu_day'] = this.menuDay;
    data['menu_id'] = this.menuId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Student {
  int? id;
  String? fullName;
  int? mobileNo;
  String? countryCode;
  String? isoCode;
  String? shiftName;

  Student({this.id, this.fullName, this.mobileNo, this.countryCode, this.isoCode, this.shiftName});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    mobileNo = json['mobile_no'];
    countryCode = json['country_code'];
    isoCode = json['iso_code'];
    shiftName = json['shift_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['mobile_no'] = this.mobileNo;
    data['country_code'] = this.countryCode;
    data['iso_code'] = this.isoCode;
    data['shift_name'] = this.shiftName;
    return data;
  }
}
