import 'package:japaneseapp/features/community_topic/data/datasources/community_remote_datasource.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';
import 'package:japaneseapp/features/community_topic/domain/repositories/community_topic_repository.dart';

class CommunityTopicRepositoryImp implements CommunityTopicRepository{
  final CommunityRemoteDataSource remoteDataSource;

  CommunityTopicRepositoryImp({required this.remoteDataSource});

  @override
  Future<List<CommunityTopicEntity>> loadCommunityTopics(int limit) {
    return remoteDataSource.loadCommunityTopics(limit);
  }

  @override
  Future<List<CommunityTopicEntity>> searchTopics(String nameTopic) {
    return remoteDataSource.searchTopic(nameTopic);
  }
}