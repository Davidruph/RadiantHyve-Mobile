class ListUserChatModel {
  int? status;
  String? message;
  int? totalUser;
  int? currentPage;
  int? totalPage;
  List<ListUserChatData>? data;

  ListUserChatModel({this.status, this.message, this.totalUser, this.currentPage, this.totalPage, this.data});

  ListUserChatModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalUser = json['total_user'];
    currentPage = json['current_page'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      data = <ListUserChatData>[];
      json['data'].forEach((v) {
        data!.add(new ListUserChatData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_user'] = this.totalUser;
    data['current_page'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListUserChatData {
  int? id;
  var fullName;
  var profilePic;
  var role;

  ListUserChatData({this.id, this.fullName, this.profilePic, this.role});

  ListUserChatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    profilePic = json['profile_pic'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['profile_pic'] = this.profilePic;
    data['role'] = this.role;
    return data;
  }
}
