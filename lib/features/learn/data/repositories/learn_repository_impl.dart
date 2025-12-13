import 'package:japaneseapp/features/learn/data/datasources/learn_local_datasource.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/domain/repositories/learn_repository.dart';

class LearnRepositoryImpl implements LearnRepository{
  final LearnLocalDataSourceImpl dataSource;

  LearnRepositoryImpl({required this.dataSource});

  @override
  Future<List<WordEntity>> loadWordsFromTopic(String topicName) async {
    return dataSource.loadWordsFromTopic(topicName);
  }




}