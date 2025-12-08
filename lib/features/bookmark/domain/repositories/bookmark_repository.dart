import 'package:japaneseapp/features/bookmark/data/models/word_model.dart';
import 'package:japaneseapp/features/bookmark/domain/entities/word_entity.dart';

abstract class BookmarkRepository {
  Future<void> removeBookmark(WordModel word);
  Future<List<WordEntity>> listBookmarks();
}