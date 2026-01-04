import 'package:japaneseapp/features/word/domain/entities/topic_entity.dart';

abstract class WordEvent{}

class CreateTopicEvent extends WordEvent{
  final TopicEntity topicEntity;

  CreateTopicEvent({required this.topicEntity});
}