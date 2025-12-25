abstract class AddTopicEvent {}

class AddTopic extends AddTopicEvent {
  final String topicId;
  final int folderId;
  AddTopic(this.topicId, this.folderId);
}

class RemoveTopic extends AddTopicEvent {
  final String topicId;
  final int folderId;
  RemoveTopic(this.topicId, this.folderId);
}

class LoadAllTopics extends AddTopicEvent {
  final int folderId;
  LoadAllTopics(this.folderId);
}