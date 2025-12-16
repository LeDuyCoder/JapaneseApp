import 'package:japaneseapp/features/topicdetail/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/topicdetail/domain/repositories/topicdetails_repository.dart';

class LoadTopicDetailsUseCase {
  final TopicDetailsRepository repository;

  LoadTopicDetailsUseCase(this.repository);

  Future<List<WordEntity>> call(String nameTopic){
    return repository.loadTopicDetails(nameTopic);
  }
}