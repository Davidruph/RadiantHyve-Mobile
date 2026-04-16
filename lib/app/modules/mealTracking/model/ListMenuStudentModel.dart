class ListMenuStudentModel {
  int? status;
  String? message;
  int? totalMenu;
  int? currentPage;
  int? totalPage;
  List<ListMenuStudentData>? data;

  ListMenuStudentModel({this.status, this.message, this.totalMenu, this.currentPage, this.totalPage, this.data});

  ListMenuStudentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalMenu = json['total_menu'];
    currentPage = json['current_page'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      data = <ListMenuStudentData>[];
      json['data'].forEach((v) {
        data!.add(new ListMenuStudentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_menu'] = this.totalMenu;
    data['current_page'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListMenuStudentData {
  int? id;
  var menuType;
  var menuDate;
  var menuTime;
  var aboutMeal;
  int? studentId;
  bool? isAll;
  int? adminId;
  int? schoolId;
  String? createdAt;
  String? updatedAt;
  var studentMenuId;
  String? studentName;

  ListMenuStudentData({
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
    this.studentName,
  });

  ListMenuStudentData.fromJson(Map<String, dynamic> json) {
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
    studentName = json['student_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['student_name'] = this.studentName;
    return data;
  }
}
