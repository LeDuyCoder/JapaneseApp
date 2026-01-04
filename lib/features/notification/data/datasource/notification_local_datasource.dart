import 'package:japaneseapp/core/service/Local/local_db_service.dart';

class NotificationLocalDatasource{
  Future<bool> isRead(String notificationId) async {
    return LocalDbService.instance.readnotificationDao.isNotificationRead(notificationId);
  }

  Future<void> markAsRead(String notificationId) async {
    await LocalDbService.instance.readnotificationDao.insertReadNotification(notificationId);
  }
}