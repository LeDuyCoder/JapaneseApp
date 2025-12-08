import 'package:japaneseapp/features/bookmark/data/models/word_model.dart';
import 'package:japaneseapp/features/bookmark/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/bookmark/domain/repositories/bookmark_repository.dart';

class GetAllBookmarkUseCase {
  final BookmarkRepository bookmarkRepository;

  GetAllBookmarkUseCase({required this.bookmarkRepository});

  Future<List<WordEntity>> call() {
    return bookmarkRepository.listBookmarks();
  }
}