import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String createdAt;
  bool isRead;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isRead = false
  });

  @override
  List<Object?> get props => [id, title, description, createdAt, isRead];

  NotificationEntity copyWith({bool? isRead}) {
    return NotificationEntity(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}