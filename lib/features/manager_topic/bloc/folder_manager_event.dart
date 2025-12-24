abstract class FolderManagerEvent {}

class LoadTopics extends FolderManagerEvent {}

class RemoveTopic extends FolderManagerEvent {
  final String topicId;
  RemoveTopic(this.topicId);
}

class DeleteFolderEvent extends FolderManagerEvent {}
