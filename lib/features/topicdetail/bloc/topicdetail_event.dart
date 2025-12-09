import 'package:japaneseapp/features/bookmark/domain/entities/word_entity.dart';

abstract class TopicDetailEvent {}

class LoadTopicDetailEvent extends TopicDetailEvent {
  final String nameTopic;

  LoadTopicDetailEvent(this.nameTopic);
}