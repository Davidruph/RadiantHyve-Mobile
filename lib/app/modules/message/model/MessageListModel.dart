class GetPersonalChatsModel {
  int? status;
  String? message;
  var lessonChatId;
  var lessonChatUnreadCount;
  var totalChats;
  var totalPages;
  var currentPage;
  List<GetPersonalChatsData>? data;

  GetPersonalChatsModel({
    this.status,
    this.message,
    this.lessonChatId,
    this.totalChats,
    this.totalPages,
    this.currentPage,
    this.data,
    this.lessonChatUnreadCount,
  });

  GetPersonalChatsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    lessonChatId = json['lesson_chat_id'];
    totalChats = json['totalChats'];
    totalPages = json['totalPages'];
    lessonChatUnreadCount = json['lesson_chat_unread_count'];
    currentPage = json['currentPage'];
    if (json['chats'] != null) {
      data = <GetPersonalChatsData>[];
      json['chats'].forEach((v) {
        data!.add(new GetPersonalChatsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['lesson_chat_id'] = this.lessonChatId;
    data['totalChats'] = this.totalChats;
    data['totalPages'] = this.totalPages;
    data['lesson_chat_unread_count'] = this.lessonChatUnreadCount;
    data['currentPage'] = this.currentPage;
    if (this.data != null) {
      data['chats'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetPersonalChatsData {
  int? id;
  int? chatBy;
  int? chatTo;
  var schoolId;
  String? createdAt;
  String? updatedAt;
  int? unreadMessagesCount;
  String? latestMessageCreatedAt;
  int? otherId;
  String? otherUserFullName;
  String? otherUserProfileImage;
  List<Messages>? messages;

  GetPersonalChatsData({
    this.id,
    this.chatBy,
    this.chatTo,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.unreadMessagesCount,
    this.latestMessageCreatedAt,
    this.otherId,
    this.otherUserFullName,
    this.otherUserProfileImage,
    this.messages,
  });

  GetPersonalChatsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatBy = json['chat_by'];
    chatTo = json['chat_to'];
    schoolId = json['school_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    unreadMessagesCount = json['unreadMessagesCount'];
    latestMessageCreatedAt = json['latestMessageCreatedAt'];
    otherId = json['other_id'];
    otherUserFullName = json['otherUserFullName'];
    otherUserProfileImage = json['otherUserProfileImage'];
    if (json['Messages'] != null) {
      messages = <Messages>[];
      json['Messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chat_by'] = this.chatBy;
    data['chat_to'] = this.chatTo;
    data['school_id'] = this.schoolId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['unreadMessagesCount'] = this.unreadMessagesCount;
    data['latestMessageCreatedAt'] = this.latestMessageCreatedAt;
    data['other_id'] = this.otherId;
    data['otherUserFullName'] = this.otherUserFullName;
    data['otherUserProfileImage'] = this.otherUserProfileImage;
    if (this.messages != null) {
      data['Messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int? id;
  int? messageBy;
  int? messageTo;
  int? chatId;
  var schoolId;
  String? messageType;
  String? messageStatus;
  var fileName;
  var messageText;
  String? readAt;
  var thumbnail;
  var mediaText;
  bool? isDeleteTo;
  bool? isDeleteBy;
  String? createdAt;
  String? updatedAt;

  Messages({
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
  });

  Messages.fromJson(Map<String, dynamic> json) {
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
    data['is_delete_to'] = this.isDeleteTo;
    data['is_delete_by'] = this.isDeleteBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
