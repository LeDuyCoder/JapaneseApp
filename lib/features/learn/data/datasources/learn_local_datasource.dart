import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/features/learn/data/models/word_model.dart';
import 'package:japaneseapp/features/learn/presentation/pages/learn_page.dart';

abstract class LearnLocalDataSource {
  // load 5 words from topic
  Future<List<WordModel>> loadWordsFromTopic(String topicName);
}

class LearnLocalDataSourceImpl implements LearnLocalDataSource {
  @override
  Future<List<WordModel>> loadWordsFromTopic(String topicName) async {
    final db = LocalDbService.instance;
    List<Map<String, dynamic>> dataWords = await db.topicDao.getAllWordbyTopic(topicName);

    List<WordModel> dataWordsModel = dataWords.map((e) => WordModel.fromJson(e)).toList();
    List<WordModel> dataWordsResults = [];

    // load 5 words randomly
    dataWordsModel.shuffle();
    for (int i = 0; i < dataWordsModel.length && i < LearnPage.amountQuestion; i++) {
      dataWordsResults.add(dataWordsModel[i]);
    }

    return dataWordsResults;
  }
}