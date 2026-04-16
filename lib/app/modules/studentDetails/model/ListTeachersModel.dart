class ListTeachersModel {
  int? status;
  String? message;
  List<ListTeachersData>? listTeachersData;

  ListTeachersModel({this.status, this.message, this.listTeachersData});

  ListTeachersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      listTeachersData = <ListTeachersData>[];
      json['data'].forEach((v) {
        listTeachersData!.add(new ListTeachersData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.listTeachersData != null) {
      data['data'] = this.listTeachersData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListTeachersData {
  int? id;
  String? fullName;
  String? profilePic;

  ListTeachersData({this.id, this.fullName, this.profilePic});

  ListTeachersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
