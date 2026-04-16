class GetLessonChatMessageModel {
  int? status;
  String? message;
  int? totalMember;
  List<GetLessonChatMessageData>? getlessonchatmessagedata;
  int? currentPage;
  int? totalPages;
  int? totalMessages;

  GetLessonChatMessageModel({
    this.status,
    this.message,
    this.totalMember,
    this.getlessonchatmessagedata,
    this.currentPage,
    this.totalPages,
    this.totalMessages,
  });

  GetLessonChatMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalMember = json['total_member'];
    if (json['data'] != null) {
      getlessonchatmessagedata = <GetLessonChatMessageData>[];
      json['data'].forEach((v) {
        getlessonchatmessagedata!.add(new GetLessonChatMessageData.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalMessages = json['totalMessages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['total_member'] = totalMember;
    if (this.getlessonchatmessagedata != null) {
      data['data'] = this.getlessonchatmessagedata!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['totalMessages'] = totalMessages;
    return data;
  }
}

class GetLessonChatMessageData {
  int? id;
  int? messageBy;
  var messageTo;
  var chatId;
  int? schoolId;
  String? messageType;
  String? messageStatus;
  var fileName;
  String? messageText;
  String? readAt;
  var thumbnail;
  var mediaText;
  bool? isDeleteTo;
  bool? isDeleteBy;
  String? createdAt;
  String? updatedAt;
  Sendermessage? sendermessage;
  List<MessageStatus>? messageStatusModel;

  GetLessonChatMessageData({
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
    this.isDeleteTo,
    this.isDeleteBy,
    this.createdAt,
    this.updatedAt,
    this.sendermessage,
    this.messageStatusModel,
  });

  GetLessonChatMessageData.fromJson(Map<String, dynamic> json) {
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
    isDeleteTo = json['is_delete_to'];
    isDeleteBy = json['is_delete_by'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sendermessage = json['sendermessage'] != null ? new Sendermessage.fromJson(json['sendermessage']) : null;
    if (json['MessageStatus'] != null) {
      messageStatusModel = <MessageStatus>[];
      json['MessageStatus'].forEach((v) {
        messageStatusModel!.add(new MessageStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message_by'] = messageBy;
    data['message_to'] = messageTo;
    data['chat_id'] = chatId;
    data['school_id'] = schoolId;
    data['message_type'] = messageType;
    data['message_status'] = messageStatus;
    data['file_name'] = fileName;
    data['message_text'] = messageText;
    data['read_at'] = readAt;
    data['thumbnail'] = thumbnail;
    data['media_text'] = mediaText;
    data['is_delete_to'] = isDeleteTo;
    data['is_delete_by'] = isDeleteBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (sendermessage != null) {
      data['sendermessage'] = sendermessage!.toJson();
    }
    if (messageStatusModel != null) {
      data['MessageStatus'] = messageStatusModel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sendermessage {
  int? id;
  String? fullName;
  String? profilePic;
  String? role;
  String? schoolName;

  Sendermessage({this.id, this.fullName, this.profilePic, this.role, this.schoolName});

  Sendermessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    profilePic = json['profile_pic'];
    role = json['role'];
    schoolName = json['school_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['profile_pic'] = profilePic;
    data['role'] = role;
    data['school_name'] = schoolName;
    return data;
  }
}

class MessageStatus {
  int? messageTo;

  MessageStatus({this.messageTo});

  MessageStatus.fromJson(Map<String, dynamic> json) {
    messageTo = json['message_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message_to'] = messageTo;
    return data;
  }
}
