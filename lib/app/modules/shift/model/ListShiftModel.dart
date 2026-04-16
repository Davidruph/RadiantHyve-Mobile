class ListShiftModel {
  int? status;
  String? message;
  int? totalShift;

  int? currentPage;
  int? totalPage;
  List<ListShiftData>? listShiftData;

  ListShiftModel({this.status, this.message, this.totalShift, this.currentPage, this.totalPage, this.listShiftData});

  ListShiftModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalShift = json['total_shift'];
    currentPage = json['current_page'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      listShiftData = <ListShiftData>[];
      json['data'].forEach((v) {
        listShiftData!.add(new ListShiftData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_shift'] = this.totalShift;
    data['current_page'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.listShiftData != null) {
      data['data'] = this.listShiftData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListShiftData {
  int? id;
  String? shiftName;
  int? shiftFee;
  int? adminId;
  int? schoolId;
  var penalty;
  String? createdAt;
  String? updatedAt;


  ListShiftData({
    this.id,
    this.shiftName,
    this.shiftFee,
    this.adminId,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.penalty,
  });

  ListShiftData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shiftName = json['shift_name'];
    shiftFee = json['shift_fee'];
    adminId = json['admin_id'];
    schoolId = json['school_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    penalty = json['penalty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shift_name'] = this.shiftName;
    data['shift_fee'] = this.shiftFee;
    data['admin_id'] = this.adminId;
    data['school_id'] = this.schoolId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['penalty'] = this.penalty;
    return data;
  }
}
