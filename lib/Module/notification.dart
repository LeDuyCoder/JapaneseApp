class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String createdAt;
  final String type;
  final bool isRead;

  NotificationModel(
      this.id,
      this.title,
      this.description,
      this.createdAt,
      this.type, {
        this.isRead = false,
      });

  /// Factory tạo từ JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      json['id'] ?? '',
      json['title'] ?? '',
      json['content'] ?? '',      // map content → description
      json['created_at'] ?? '',
      json['type'] ?? '',
      isRead: (json['is_read'] == 1), // convert int → bool
    );
  }

  /// Convert object → JSON (nếu cần gửi lại server)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': description,
      'created_at': createdAt,
      'type': type,
      'is_read': isRead ? 1 : 0,
    };
  }
}
