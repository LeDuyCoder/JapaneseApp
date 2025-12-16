import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/domain/repositories/learn_repository.dart';

class LoadWordsFromTopicUsecase {
  final LearnRepository repository;

  LoadWordsFromTopicUsecase(this.repository);

  Future<List<WordEntity>> call(String topicName) async {
    return repository.loadWordsFromTopic(topicName);
  }
}