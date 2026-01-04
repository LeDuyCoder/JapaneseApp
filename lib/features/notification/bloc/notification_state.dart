import 'package:japaneseapp/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationState{}

class LoadingNotificationState extends NotificationState{}

class LoadedNotificationState extends NotificationState{
  final List<NotificationEntity> listNotification;

  LoadedNotificationState({required this.listNotification});
}

class ErrorNotificationState extends NotificationState{
  final String message;

  ErrorNotificationState({required this.message});
}