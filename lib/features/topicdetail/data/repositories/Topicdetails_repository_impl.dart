import 'package:japaneseapp/features/topicdetail/data/models/word_model.dart';
import 'package:japaneseapp/features/topicdetail/data/datasources/topicdetail_local_datasource.dart';
import 'package:japaneseapp/features/topicdetail/domain/repositories/topicdetails_repository.dart';

class TopicdetailsRepositoryImpl implements TopicDetailsRepository{
  final TopicdetailsLocalDatasourceImpl dataSource;

  TopicdetailsRepositoryImpl({required this.dataSource});

  @override
  Future<List<WordModel>> loadTopicDetails(String nameTopic) {
    return dataSource.loadTopicDetails(nameTopic);
  }

  @override
  Future<void> openQuizCard(WordEntity) {
    return dataSource.openQuizCard(WordEntity);
  }

  @override
  Future<void> removeTopic(String nameTopic) {
    return dataSource.removeTopic(nameTopic);
  }
}