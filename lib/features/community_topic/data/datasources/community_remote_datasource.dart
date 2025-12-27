import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Service/Server/TopicService.dart';
import 'package:japaneseapp/core/module/topic_module.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';

class CommunityRemoteDataSource {
  Future<List<CommunityTopicEntity>> loadCommunityTopics(int limit) async {
    TopicService topicService = TopicService();
    LocalDbService db = LocalDbService.instance;

    List<CommunityTopicEntity> result = [];
    final List<TopicModule> data = await topicService.getAllDataTopic(limit);
    for (var item in data) {
      bool isExist = await db.topicDao.hasTopicID(item.id);
      result.add(
        CommunityTopicEntity(
            topicId: item.id,
            userId: item.userId??'',
            userName: item.owner??'',
            nameTopic: item.name,
            wordCount: item.count??0,
            isExist: isExist
        )
      );
    }
    return result;
  }

  Future<List<CommunityTopicEntity>> searchTopic(String nameTopic) async {
    TopicService topicService = TopicService();
    LocalDbService db = LocalDbService.instance;

    List<CommunityTopicEntity> result = [];
    final List<TopicModule> data = await topicService.getTopicsSearch(nameTopic);
    for (var item in data) {
      bool isExist = await db.topicDao.hasTopicID(item.id);
      result.add(
          CommunityTopicEntity(
              topicId: item.id,
              userId: item.userId??'',
              userName: item.owner??'',
              nameTopic: item.name,
              wordCount: item.count??0,
              isExist: isExist
          )
      );
    }

    return result;
  }
}