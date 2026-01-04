import 'package:japaneseapp/features/notification/data/datasource/notification_local_datasource.dart';
import 'package:japaneseapp/features/notification/data/datasource/notification_remote_datasource.dart';
import 'package:japaneseapp/features/notification/domain/entities/notification_entity.dart';
import 'package:japaneseapp/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository{
  final NotificationLocalDatasource localDatasource;
  final NotificationRemoteDatasource remoteDatasource;

  NotificationRepositoryImpl({required this.localDatasource, required this.remoteDatasource});

  @override
  Future<List<NotificationEntity>> getAll(String userId) {
    return remoteDatasource.getAll(userId);
  }

  @override
  Future<bool> isRead(String notificationId) {
    return localDatasource.isRead(notificationId);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await localDatasource.markAsRead(notificationId);
  }

}