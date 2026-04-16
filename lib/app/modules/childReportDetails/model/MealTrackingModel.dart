class MealTrackingModel {
  int? status;
  String? message;
  List<MealTrackingData>? data;

  MealTrackingModel({this.status, this.message, this.data});

  MealTrackingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MealTrackingData>[];
      json['data'].forEach((v) {
        data!.add(new MealTrackingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealTrackingData {
  int? id;
  var menuType;
  var menuDate;
  var menuTime;
  var aboutMeal;
  var studentId;
  var isAll;
  var adminId;
  var schoolId;
  var createdAt;
  var updatedAt;
  List<MenuDay>? menuDay;
  var student;

  MealTrackingData(
      {this.id,
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
        this.menuDay,
        this.student});

  MealTrackingData.fromJson(Map<String, dynamic> json) {
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
    if (json['MenuDay'] != null) {
      menuDay = <MenuDay>[];
      json['MenuDay'].forEach((v) {
        menuDay!.add(new MenuDay.fromJson(v));
      });
    }
    student = json['student'];
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
    if (this.menuDay != null) {
      data['MenuDay'] = this.menuDay!.map((v) => v.toJson()).toList();
    }
    data['student'] = this.student;
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
