import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';

abstract class CommunityTopicRepository {
  Future<List<CommunityTopicEntity>> loadCommunityTopics(int limit);
  Future<List<CommunityTopicEntity>> searchTopics(String nameTopic);
}