import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/dowload_topic_entity.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/word_entity.dart';

class DowloadTopicRemoteDataSource{
  Future<DowloadTopicEntity> loadDowloadTopicEntity(String topicId) async {
    LocalDbService db = LocalDbService.instance;

    var dataTopic = await ServiceLocator.wordService.fetchWordsByTopicID(topicId);
    var topic = await ServiceLocator.topicService.getDataTopicByID(topicId);

    List<WordEntity> wordEntities = [];
    for(var word in dataTopic){
      wordEntities.add(
          WordEntity(
              word: word.word,
              mean: word.mean,
              wayread: word.wayread
          )
      );
    }

    CommunityTopicEntity communityTopicEntity = CommunityTopicEntity(
        topicId: topic!.id,
        userId: topic.userId??'',
        userName: topic.owner??'',
        nameTopic: topic.name,
        wordCount: wordEntities.length,
        isExist: await db.topicDao.hasTopicID(topicId)
    );

    return DowloadTopicEntity(
        communityTopicEntity: communityTopicEntity,
        wordEntities: wordEntities
    );
  }
  
  Future<void> dowload(DowloadTopicEntity topic) async{
    LocalDbService db = LocalDbService.instance;
    db.topicDao.insertTopicID(
        topic.communityTopicEntity.topicId,
        topic.communityTopicEntity.nameTopic,
        topic.communityTopicEntity.userName
    );

    List<Map<String, dynamic>> dataInsert = [];
    for(WordEntity wordEntity in topic.wordEntities){
      dataInsert.add(
        {
          "word": wordEntity.word,
          "mean": wordEntity.mean,
          "wayread": wordEntity.wayread,
          "topic": topic.communityTopicEntity.topicId,
          "level": 0
        }
      );
    }

    db.topicDao.insertDataTopic(dataInsert);
  }
}