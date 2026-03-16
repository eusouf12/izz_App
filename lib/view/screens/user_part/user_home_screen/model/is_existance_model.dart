class ChannelResponse {
  final bool success;
  final String message;
  final ChannelData data;

  ChannelResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChannelResponse.fromJson(Map<String, dynamic> json) {
    return ChannelResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ChannelData.fromJson(json['data'] ?? {}),
    );
  }
}

class ChannelData {
  final String id;
  final String channelName;
  final ChannelUser person1;
  final ChannelUser person2;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChannelData({
    required this.id,
    required this.channelName,
    required this.person1,
    required this.person2,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChannelData.fromJson(Map<String, dynamic> json) {
    return ChannelData(
      id: json['id'] ?? '',
      channelName: json['channelName'] ?? '',
      person1: ChannelUser.fromJson(json['person1'] ?? {}),
      person2: ChannelUser.fromJson(json['person2'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ChannelUser {
  final String id;
  final String fullName;
  final String email;
  final String profileImage;
  final String role;
  final String status;

  ChannelUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImage,
    required this.role,
    required this.status,
  });

  factory ChannelUser.fromJson(Map<String, dynamic> json) {
    return ChannelUser(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

