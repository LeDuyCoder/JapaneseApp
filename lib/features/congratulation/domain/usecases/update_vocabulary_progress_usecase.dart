import 'package:japaneseapp/features/congratulation/data/repositories/vocabulary_repository.dart';

import 'package:japaneseapp/features/congratulation/domain/entities/word_entity.dart';

class UpdateVocabularyProgressUseCase {
  final VocabularyRepository repository;

  UpdateVocabularyProgressUseCase(this.repository);

  Future<void> execute(List<WordEntity> words) async {
    for (final word in words) {
      final nextLevel = word.level < 28 ? word.level + 1 : word.level;
      await repository.updateWordLevel(
        word: word.word,
        topic: word.topic,
        level: nextLevel,
      );
    }
  }
}
