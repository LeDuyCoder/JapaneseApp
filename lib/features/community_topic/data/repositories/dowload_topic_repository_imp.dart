import 'package:japaneseapp/features/community_topic/data/datasources/dowload_topic_remote_datasource.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/dowload_topic_entity.dart';
import 'package:japaneseapp/features/community_topic/domain/repositories/dowload_topic_repository.dart';

class DowloadTopicRepositoryImpl implements DowloadTopicRepository{
  final DowloadTopicRemoteDataSource dataSource;

  DowloadTopicRepositoryImpl({required this.dataSource});

  @override
  Future<void> dowload(DowloadTopicEntity dowloadTopicEntity) {
    return dataSource.dowload(dowloadTopicEntity);
  }

  @override
  Future<DowloadTopicEntity> loadData(String topicId) {
    return dataSource.loadDowloadTopicEntity(topicId);
  }

}