import 'package:japaneseapp/features/bookmark/data/datasources/bookmark_local_datasource.dart';
import 'package:japaneseapp/features/bookmark/data/models/word_model.dart';
import 'package:japaneseapp/features/bookmark/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/bookmark/domain/repositories/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDataSource repository;

  BookmarkRepositoryImpl({required this.repository});

  @override
  Future<void> removeBookmark(WordModel word) {
    return repository.removeBookmark(word);
  }

  @override
  Future<List<WordEntity>> listBookmarks() {
    return repository.getAllBookmarks();
  }
  
  
  
}