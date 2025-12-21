import 'package:japaneseapp/core/Service/Local/dao/VocabularyDao.dart';
import 'package:japaneseapp/features/congratulation/data/repositories/vocabulary_repository.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  final VocabularyDao dao;

  VocabularyRepositoryImpl(this.dao);

  @override
  Future<void> updateWordLevel({
    required String word,
    required String topic,
    required int level,
  }) {
    return dao.update(
      "words",
      {"level": level},
      "word = '$word' AND topic = '$topic'",
    );
  }
}
