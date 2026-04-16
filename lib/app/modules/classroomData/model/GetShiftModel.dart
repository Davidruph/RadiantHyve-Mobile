class GetShiftModel {
  int? status;
  String? message;
  List<GetShiftData>? data;

  GetShiftModel({this.status, this.message, this.data});

  GetShiftModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetShiftData>[];
      json['data'].forEach((v) {
        data!.add(new GetShiftData.fromJson(v));
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

class GetShiftData {
  int? id;
  var shiftName;
  var shiftFee;
  var adminId;
  var schoolId;
  var createdAt;
  var updatedAt;

  GetShiftData(
      {this.id,
        this.shiftName,
        this.shiftFee,
        this.adminId,
        this.schoolId,
        this.createdAt,
        this.updatedAt});

  GetShiftData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shiftName = json['shift_name'];
    shiftFee = json['shift_fee'];
    adminId = json['admin_id'];
    schoolId = json['school_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    return data;
  }
}
