class ListStudentsInvoiceModel {
  int? status;
  String? message;
  List<ListStudentsInvoiceData>? data;
  String? currentPage;
  int? totalPage;

  ListStudentsInvoiceModel(
      {this.status, this.message, this.data, this.currentPage, this.totalPage});

  ListStudentsInvoiceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ListStudentsInvoiceData>[];
      json['data'].forEach((v) {
        data!.add(new ListStudentsInvoiceData.fromJson(v));
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

class ListStudentsInvoiceData {
  var id;
  var studentId;
  var parentId;
  var schoolId;
  var totalFees;
  var penaltyFees;
  var shiftFee;
  var month;
  var year;
  var createdAt;
  var updatedAt;
  var studentName;

  ListStudentsInvoiceData(
      {this.id,
        this.studentId,
        this.parentId,
        this.schoolId,
        this.totalFees,
        this.month,
        this.year,
        this.shiftFee,
        this.createdAt,
        this.penaltyFees,
        this.updatedAt,
        this.studentName});

  ListStudentsInvoiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    parentId = json['parent_id'];
    schoolId = json['school_id'];
    totalFees = json['total_fees'];
    shiftFee = json['shift_fee'];
    penaltyFees = json['penalty_fees'];
    month = json['month'];
    year = json['year'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    studentName = json['student_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['parent_id'] = this.parentId;
    data['school_id'] = this.schoolId;
    data['total_fees'] = this.totalFees;
    data['shift_fee'] = this.shiftFee;
    data['penalty_fees'] = this.penaltyFees;
    data['month'] = this.month;
    data['year'] = this.year;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['student_name'] = this.studentName;
    return data;
  }
}
