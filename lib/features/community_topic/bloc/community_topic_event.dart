abstract class CommynityTopicEvent {}

class LoadTopics extends CommynityTopicEvent {
  final int limit;

  LoadTopics({required this.limit});
}

class searchTopics extends CommynityTopicEvent {
  final String nameTopic;

  searchTopics({required this.nameTopic});
}