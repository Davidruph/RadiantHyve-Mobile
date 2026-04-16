class GetSosModel {
  int? status;
  String? message;
  List<GetSosModelData>? data;

  GetSosModel({this.status, this.message, this.data});

  GetSosModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetSosModelData>[];
      json['data'].forEach((v) {
        data!.add(new GetSosModelData.fromJson(v));
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

class GetSosModelData {
  var id;
  var sosName;
  var createdAt;
  var updatedAt;

  GetSosModelData({this.id, this.sosName, this.createdAt, this.updatedAt});

  GetSosModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sosName = json['sos_name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sos_name'] = this.sosName;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
