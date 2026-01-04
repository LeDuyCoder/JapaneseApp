import 'package:firebase_auth/firebase_auth.dart';
import 'package:japaneseapp/core/service/Local/local_db_service.dart';
import 'package:japaneseapp/features/word/domain/entities/word_entity.dart';
import 'package:uuid/uuid.dart';

class WordDatasource{

  Future<void> createTopic(String nameTopic, List<WordEntity> wordEntities) async {
    String topicId = const Uuid().v4();
    await LocalDbService.instance.topicDao.insertTopicID(topicId, nameTopic, FirebaseAuth.instance.currentUser!.displayName!);
    final List<Map<String, dynamic>> maps =
    wordEntities.map((e) => e.toMap(topicId)).toList();
    await LocalDbService.instance.topicDao.insertDataTopic(maps);
  }

  Future<bool> isExistName(String nameTopic) async {
    return LocalDbService.instance.topicDao.hasTopicName(nameTopic);
  }
}