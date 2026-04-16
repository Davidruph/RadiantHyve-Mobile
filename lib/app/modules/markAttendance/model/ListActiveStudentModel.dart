class ListActiveStudentModel {
  int? status;
  String? message;
  int? totalStudent;
  int? currentPage;
  int? totalPage;
  List<ListActiveStudentData>? data;

  ListActiveStudentModel(
      {this.status,
        this.message,
        this.totalStudent,
        this.currentPage,
        this.totalPage,
        this.data});

  ListActiveStudentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalStudent = json['total_student'];
    currentPage = json['current_page'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = <ListActiveStudentData>[];
      json['data'].forEach((v) {
        data!.add(new ListActiveStudentData.fromJson(v));
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

class ListActiveStudentData {
  int? id;
 var fullName;
 var relationToChild;
 var requestStatus;
 var shiftName;

  ListActiveStudentData(
      {this.id,
        this.fullName,
        this.relationToChild,
        this.requestStatus,
        this.shiftName});

  ListActiveStudentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    relationToChild = json['relation_to_child'];
    requestStatus = json['request_status'];
    shiftName = json['shift_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['relation_to_child'] = this.relationToChild;
    data['request_status'] = this.requestStatus;
    data['shift_name'] = this.shiftName;
    return data;
  }
}
