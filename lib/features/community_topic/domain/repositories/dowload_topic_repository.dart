import 'package:japaneseapp/features/community_topic/domain/entities/dowload_topic_entity.dart';

abstract class DowloadTopicRepository{
  Future<DowloadTopicEntity> loadData(String topicId);
  Future<void> dowload(DowloadTopicEntity dowloadTopicEntity);
}