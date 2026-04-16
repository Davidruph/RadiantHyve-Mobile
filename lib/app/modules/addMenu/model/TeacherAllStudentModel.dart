class TeacherAllStudentModel {
  int? status;
  String? message;
  List<TeacherAllStudentData>? data;

  TeacherAllStudentModel({this.status, this.message, this.data});

  TeacherAllStudentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TeacherAllStudentData>[];
      json['data'].forEach((v) {
        data!.add(new TeacherAllStudentData.fromJson(v));
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

class TeacherAllStudentData {
  int? id;
  var fullName;

  TeacherAllStudentData({this.id, this.fullName});

  TeacherAllStudentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    return data;
  }
}
