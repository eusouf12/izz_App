// ================= MAIN RESPONSE =================
class ChatMessagesResponse {
  final bool success;
  final String message;
  final ChatMessagesData data;

  ChatMessagesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChatMessagesResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessagesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ChatMessagesData.fromJson(json['data'] ?? {}),
    );
  }
}

// ================= DATA =================
class ChatMessagesData {
  final MetaInbox meta;
  final List<MessageModel> data;

  ChatMessagesData({
    required this.meta,
    required this.data,
  });

  factory ChatMessagesData.fromJson(Map<String, dynamic> json) {
    return ChatMessagesData(
      meta: MetaInbox.fromJson(json['meta'] ?? {}),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => MessageModel.fromJson(e))
          .toList(),
    );
  }
}

// ================= META =================
class MetaInbox {
  final int total;
  final int page;
  final int limit;

  MetaInbox({
    required this.total,
    required this.page,
    required this.limit,
  });

  factory MetaInbox.fromJson(Map<String, dynamic> json) {
    return MetaInbox(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }
}

// ================= MESSAGE =================
class MessageModel {
  final String id;
  final String? subject;
  final String message;
  final List<String> files;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String senderId;
  final String channelName;
  final Sender sender;

  MessageModel({
    required this.id,
    this.subject,
    required this.message,
    required this.files,
    required this.createdAt,
    required this.updatedAt,
    required this.senderId,
    required this.channelName,
    required this.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      subject: json['subject'],
      message: json['message'] ?? '',
      files: (json['files'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      createdAt:
      DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt:
      DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      senderId: json['senderId'] ?? '',
      channelName: json['channelName'] ?? '',
      sender: Sender.fromJson(json['sender'] ?? {}),
    );
  }
}

// ================= SENDER =================
class Sender {
  final String id;
  final String fullName;
  final String profileImage;

  Sender({
    required this.id,
    required this.fullName,
    required this.profileImage,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}
