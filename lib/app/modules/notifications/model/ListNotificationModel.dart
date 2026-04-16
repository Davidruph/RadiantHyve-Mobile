class ListNotificationModel {
  String? message;
  int? total;
  String? page;
  int? limit;
  int? totalPages;
    List<ListNotificationData>? notificationdata;

  ListNotificationModel(
      {this.message,
        this.total,
        this.page,
        this.limit,
        this.totalPages,
        this.notificationdata});

  ListNotificationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    if (json['data'] != null) {
      notificationdata = <ListNotificationData>[];
      json['data'].forEach((v) {
        notificationdata!.add(new ListNotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['totalPages'] = this.totalPages;
    if (this.notificationdata != null) {
      data['data'] = this.notificationdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListNotificationData {
  int? id;
  int? notificationBy;
  int? notificationTo;
  String? notificationType;
  String? title;
  String? body;
  String? notificationStatus;
  int? schoolId;
  String? createdAt;
  String? updatedAt;
  Notificationby? notificationby;

  ListNotificationData(
      {this.id,
        this.notificationBy,
        this.notificationTo,
        this.notificationType,
        this.title,
        this.body,
        this.notificationStatus,
        this.schoolId,
        this.createdAt,
        this.updatedAt,
        this.notificationby});

  ListNotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationBy = json['notification_by'];
    notificationTo = json['notification_to'];
    notificationType = json['notification_type'];
    title = json['title'];
    body = json['body'];
    notificationStatus = json['notification_status'];
    schoolId = json['school_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    notificationby = json['notificationby'] != null
        ? new Notificationby.fromJson(json['notificationby'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notification_by'] = this.notificationBy;
    data['notification_to'] = this.notificationTo;
    data['notification_type'] = this.notificationType;
    data['title'] = this.title;
    data['body'] = this.body;
    data['notification_status'] = this.notificationStatus;
    data['school_id'] = this.schoolId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.notificationby != null) {
      data['notificationby'] = this.notificationby!.toJson();
    }
    return data;
  }
}

class Notificationby {
  int? id;
  String? email;
  String? fullName;
  String? profilePic;
  String? role;
  var schoolName;

  Notificationby(
      {this.id,
        this.email,
        this.fullName,
        this.profilePic,
        this.role,
        this.schoolName});

  Notificationby.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['full_name'];
    profilePic = json['profile_pic'];
    role = json['role'];
    schoolName = json['school_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    data['profile_pic'] = this.profilePic;
    data['role'] = this.role;
    data['school_name'] = this.schoolName;
    return data;
  }
}
