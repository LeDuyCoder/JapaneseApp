import 'package:japaneseapp/features/word/data/data/word_datasource.dart';
import 'package:japaneseapp/features/word/domain/entities/topic_entity.dart';
import 'package:japaneseapp/features/word/domain/repositories/word_repository.dart';

class WordRepositoryImpl extends WordRepository{
  final WordDatasource datasource;

  WordRepositoryImpl({required this.datasource});

  @override
  Future<void> createTopic(TopicEntity topic) {
    return datasource.createTopic(topic.name, topic.words);
  }

  @override
  Future<bool> hasTopic(String nameTopic) {
    return datasource.isExistName(nameTopic);
  }

}