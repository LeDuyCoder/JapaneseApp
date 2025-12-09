import 'package:japaneseapp/features/topicdetail/domain/entities/word_entity.dart';

abstract class TopicDetailsRepository {
  Future<void> openQuizCard(WordEntity);
  Future<List<WordEntity>> loadTopicDetails(String nameTopic);
  Future<void> removeTopic(String nameTopic);
}