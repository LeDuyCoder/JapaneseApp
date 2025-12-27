import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/word_entity.dart';

class DowloadTopicEntity{
  final CommunityTopicEntity communityTopicEntity;
  final List<WordEntity> wordEntities;

  DowloadTopicEntity({required this.communityTopicEntity, required this.wordEntities});
}