abstract class TopicPrivacyEvent {}

class LoadTopicPrivacyEvent extends TopicPrivacyEvent {
  final String idTopic;

  LoadTopicPrivacyEvent(this.idTopic);
}

class SetTopicPrivateEvent extends TopicPrivacyEvent {
  final String idTopic;
  final String nameTopic;

  SetTopicPrivateEvent(this.idTopic, this.nameTopic);
}