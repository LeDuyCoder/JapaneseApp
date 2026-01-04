import 'package:japaneseapp/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getAll(String userId);
  Future<bool> isRead(String notificationId);
  Future<void> markAsRead(String notificationId);
}
