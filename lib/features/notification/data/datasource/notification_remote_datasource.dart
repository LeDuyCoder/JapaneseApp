import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/features/notification/domain/entities/notification_entity.dart';

class NotificationRemoteDatasource{
  Future<List<NotificationEntity>> getAll(String userId) async {
    final data = await ServiceLocator
        .notificationservice
        .getAllNotification(userId);

    final readIds = await LocalDbService
        .instance
        .readnotificationDao
        .getAllReadNotificationIds();

    return data.map((n) {
      return NotificationEntity(
        id: n.id,
        title: n.title,
        description: n.description,
        createdAt: n.createdAt,
        isRead: readIds.contains(n.id),
      );
    }).toList();
  }
}