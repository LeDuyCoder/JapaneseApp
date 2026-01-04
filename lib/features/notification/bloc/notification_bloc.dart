import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/notification/bloc/notification_event.dart';
import 'package:japaneseapp/features/notification/bloc/notification_state.dart';
import 'package:japaneseapp/features/notification/domain/entities/notification_entity.dart';
import 'package:japaneseapp/features/notification/domain/repositories/notification_repository.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState>{
  final NotificationRepository repository;

  NotificationBloc({required this.repository}) : super(LoadingNotificationState()){
    on<LoadNotificationEvent>(_onLoadNotifcation);
    on<MarkNotificationEvent>(_onMarkNotifcation);
  }

  Future<void> _onLoadNotifcation(LoadNotificationEvent event, Emitter emit) async {
    List<NotificationEntity> notifications = await repository.getAll(event.userId);
    emit(LoadedNotificationState(listNotification: notifications));
  }

  Future<void> _onMarkNotifcation(MarkNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      emit(LoadingNotificationState());
      await repository.markAsRead(event.notificationEntity.id);
      final updatedList = event.notifications.map((n) {
        if (n.id == event.notificationEntity.id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();
      emit(
        LoadedNotificationState(
          listNotification: updatedList,
        ),
      );
    } catch (e) {
      emit(ErrorNotificationState(message: 'Không thể đánh dấu đã đọc'));
    }
  }


}