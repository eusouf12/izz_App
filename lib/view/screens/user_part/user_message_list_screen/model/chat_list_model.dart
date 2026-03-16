// ===================== Chat List Response =====================
class ChatListResponse {
  final bool success;
  final String message;
  final ChatListData data;

  ChatListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    return ChatListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ChatListData.fromJson(json['data'] ?? {}),
    );
  }
}

// ===================== Main Data =====================
class ChatListData {
  final Meta meta;
  final List<ChannelModel> channels;

  ChatListData({
    required this.meta,
    required this.channels,
  });

  factory ChatListData.fromJson(Map<String, dynamic> json) {
    return ChatListData(
      meta: Meta.fromJson(json['meta'] ?? {}),
      channels: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ChannelModel.fromJson(e))
          .toList(),
    );
  }
}

// ===================== Meta =====================
class Meta {
  final int total;
  final int page;
  final int limit;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }
}

// ===================== Channel =====================
class ChannelModel {
  final String id;
  final String channelName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String person1Id;
  final String person2Id;
  final ChannelUser person1;
  final ChannelUser person2;
  final LastMessage lastMessage;

  ChannelModel({
    required this.id,
    required this.channelName,
    required this.createdAt,
    required this.updatedAt,
    required this.person1Id,
    required this.person2Id,
    required this.person1,
    required this.person2,
    required this.lastMessage,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] ?? '',
      channelName: json['channelName'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      person1Id: json['person1Id'] ?? '',
      person2Id: json['person2Id'] ?? '',
      person1: ChannelUser.fromJson(json['person1'] ?? {}),
      person2: ChannelUser.fromJson(json['person2'] ?? {}),
      lastMessage: LastMessage.fromJson(json['lastMessage'] ?? {}),
    );
  }
}

// ===================== Channel User =====================
class ChannelUser {
  final String id;
  final String fullName;
  final String email;
  final String profileImage;

  ChannelUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImage,
  });

  factory ChannelUser.fromJson(Map<String, dynamic> json) {
    return ChannelUser(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}
// ===================== Channel User =====================
class LastMessage {
  final String id;
  final String message;

  LastMessage({
    required this.id,
    required this.message,

  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['id'] ?? '',
      message: json['message'] ?? '',

    );
  }
}
