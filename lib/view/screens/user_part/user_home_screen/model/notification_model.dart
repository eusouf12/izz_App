class NotificationModel {
  final bool success;
  final String message;
  final List<NotificationItem> data;

  NotificationModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? []
          : List<NotificationItem>.from(
              (json['data'] as List).map((x) => NotificationItem.fromJson(x)),
            ),
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String createdAt;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? json['body'] ?? '',
      createdAt: json['createdAt'] ?? '',
      isRead: json['isRead'] ?? false,
    );
  }
}
