import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/features/bookmark/data/models/word_model.dart';
import 'package:japaneseapp/features/bookmark/domain/entities/word_entity.dart';

abstract class BookmarkLocalDatasourceImpl {
  Future<void> removeBookmark(WordModel word);
  Future<List<WordModel>> getAllBookmarks();
}

class BookmarkLocalDataSource implements BookmarkLocalDatasourceImpl{
  @override
  Future<List<WordModel>> getAllBookmarks() async {
    final db = LocalDbService.instance;
    List<Map<String, dynamic>> data = await db.vocabularyDao.getAllVocabulary();
    List<WordModel> bookmarks = data.map((e) => WordModel.fromJson(e)).toList();
    return bookmarks;
  }

  @override
  Future<void> removeBookmark(WordModel word) async {
    final db = LocalDbService.instance;
    await db.vocabularyDao.removeVocabulary(wordJp: word.word, wordKana: word.reading);
  }

}