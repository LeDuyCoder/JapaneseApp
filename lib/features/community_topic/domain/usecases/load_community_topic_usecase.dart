import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';
import 'package:japaneseapp/features/community_topic/domain/repositories/community_topic_repository.dart';

class LoadCommunityTopicUseCase {
  final CommunityTopicRepository repository;

  LoadCommunityTopicUseCase(this.repository);

  Future<List<CommunityTopicEntity>> call(int limit) async {
    return await repository.loadCommunityTopics(limit);
  }
}