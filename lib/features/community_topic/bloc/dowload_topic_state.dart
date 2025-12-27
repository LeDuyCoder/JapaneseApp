import 'package:japaneseapp/features/community_topic/domain/entities/dowload_topic_entity.dart';

abstract class DowloadTopicState{}

class DowloadTopicWaiting extends DowloadTopicState{}

class DowloadTopicLoadState extends DowloadTopicState{
  final DowloadTopicEntity dowloadTopicEntity;

  DowloadTopicLoadState({required this.dowloadTopicEntity});
}

class DowloadingTopic extends DowloadTopicState{}

class DowloadTopicSucces extends DowloadTopicState{}

class DowloadTopicError extends DowloadTopicState{
  final String message;

  DowloadTopicError({required this.message});
}