import 'package:japaneseapp/features/community_topic/domain/entities/dowload_topic_entity.dart';

abstract class DowloadTopicEvent{}

class DowloadTopicLoad extends DowloadTopicEvent{
  final String topicId;

  DowloadTopicLoad({required this.topicId});
}

class DowloadTopic extends DowloadTopicEvent{
  final DowloadTopicEntity dowloadTopicEntity;

  DowloadTopic({required this.dowloadTopicEntity});
}

