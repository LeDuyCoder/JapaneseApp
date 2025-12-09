import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/features/topicdetail/data/models/word_model.dart';

abstract class TopicdetailsLocalDatasource{
  Future<List<WordModel>> loadTopicDetails(String nameTopic);
  Future<void> openQuizCard(WordEntity);
  Future<void> removeTopic(String nameTopic);
}

class TopicdetailsLocalDatasourceImpl implements TopicdetailsLocalDatasource{
  @override
  Future<List<WordModel>> loadTopicDetails(String nameTopic) async {
    final db = LocalDbService.instance;
    List<Map<String, dynamic>> dataWords = await db.topicDao.getAllWordbyTopic(nameTopic);

    List<WordModel> dataWordsModel = dataWords.map((e) => WordModel.fromJson(e)).toList();

    return dataWordsModel;

  }

  @override
  Future<void> openQuizCard(WordEntity) {
    // TODO: implement openQuizCard
    throw UnimplementedError();
  }

  @override
  Future<void> removeTopic(String nameTopic) {
    // TODO: implement removeTopic
    throw UnimplementedError();
  }

}