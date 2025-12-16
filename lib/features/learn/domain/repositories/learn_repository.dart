import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

abstract class LearnRepository {
  // load 5 words from topic
  Future<List<WordEntity>> loadWordsFromTopic(String topicName);
}