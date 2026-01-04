import 'package:japaneseapp/features/word/domain/entities/topic_entity.dart';

abstract class WordRepository{
  Future<void> createTopic(TopicEntity topic);
  Future<bool> hasTopic(String nameTopic);
}