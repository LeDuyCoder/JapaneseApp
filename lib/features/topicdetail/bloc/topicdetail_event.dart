import 'package:japaneseapp/features/bookmark/domain/entities/word_entity.dart';

abstract class TopicDetailEvent {}

class LoadTopicDetailEvent extends TopicDetailEvent {
  final String idTopic;

  LoadTopicDetailEvent(this.idTopic);
}