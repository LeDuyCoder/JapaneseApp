import 'package:japaneseapp/features/dictionary/domain/entities/word_entity.dart';

abstract class DictionaryRepository {
  Future<WordEntity> searchWord(String query);
  Future<void> toggleBookmark(String id);
}
