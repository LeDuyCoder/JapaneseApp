abstract class VocabularyRepository {
  Future<void> updateWordLevel({
    required String word,
    required String topic,
    required int level,
  });
}
