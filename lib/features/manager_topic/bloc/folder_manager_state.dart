import 'package:japaneseapp/features/manager_topic/domain/entities/topic_entity.dart';

abstract class FolderManagerState {}

class FolderManagerLoading extends FolderManagerState {}

class FolderManagerLoaded extends FolderManagerState {
  final List<TopicEntity> topics;
  FolderManagerLoaded(this.topics);
}

class FolderManagerError extends FolderManagerState {
  final String message;
  FolderManagerError(this.message);
}
