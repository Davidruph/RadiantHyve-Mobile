class GetPersonalChatMessageModel {
  int? status;
  String? message;
  int? totalMessages;
  int? totalPages;
  int? currentPage;
  List<GetPersonalChatMessageData>? data;

  GetPersonalChatMessageModel({
    this.status,
    this.message,
    this.totalMessages,
    this.totalPages,
    this.currentPage,
    this.data,
  });

  GetPersonalChatMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalMessages = json['totalMessages'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    if (json['data'] != null) {
      data = <GetPersonalChatMessageData>[];
      json['data'].forEach((v) {
        data!.add(new GetPersonalChatMessageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['totalMessages'] = this.totalMessages;
    data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetPersonalChatMessageData {
  int? id;
  int? messageBy;
  int? messageTo;
  int? chatId;
  var schoolId;
  String? messageType;
  String? messageStatus;
  var fileName;
  String? messageText;
  String? readAt;
  var thumbnail;
  var mediaText;
  String? createdAt;
  String? updatedAt;
  Sendermessage? sendermessage;

  GetPersonalChatMessageData({
    this.id,
    this.messageBy,
    this.messageTo,
    this.chatId,
    this.schoolId,
    this.messageType,
    this.messageStatus,
    this.fileName,
    this.messageText,
    this.readAt,
    this.thumbnail,
    this.mediaText,
    this.createdAt,
    this.updatedAt,
    this.sendermessage,
  });

  GetPersonalChatMessageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    messageBy = json['message_by'];
    messageTo = json['message_to'];
    chatId = json['chat_id'];
    schoolId = json['school_id'];
    messageType = json['message_type'];
    messageStatus = json['message_status'];
    fileName = json['file_name'];
    messageText = json['message_text'];
    readAt = json['read_at'];
    thumbnail = json['thumbnail'];
    mediaText = json['media_text'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sendermessage =
        json['sendermessage'] != null ? new Sendermessage.fromJson(json['sendermessage']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message_by'] = this.messageBy;
    data['message_to'] = this.messageTo;
    data['chat_id'] = this.chatId;
    data['school_id'] = this.schoolId;
    data['message_type'] = this.messageType;
    data['message_status'] = this.messageStatus;
    data['file_name'] = this.fileName;
    data['message_text'] = this.messageText;
    data['read_at'] = this.readAt;
    data['thumbnail'] = this.thumbnail;
    data['media_text'] = this.mediaText;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.sendermessage != null) {
      data['sendermessage'] = this.sendermessage!.toJson();
    }
    return data;
  }
}

class Sendermessage {
  int? id;
  String? fullName;
  String? profilePic;
  String? role;

  Sendermessage({this.id, this.fullName, this.profilePic, this.role});

  Sendermessage.fromJson(Map<String, dynamic> json) {
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
