import 'package:japaneseapp/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationEvent{}

class LoadNotificationEvent extends NotificationEvent{
  final String userId;

  LoadNotificationEvent({required this.userId});
}

class MarkNotificationEvent extends NotificationEvent{
  final NotificationEntity notificationEntity;
  final List<NotificationEntity> notifications;

  MarkNotificationEvent({required this.notificationEntity, required this.notifications});
}