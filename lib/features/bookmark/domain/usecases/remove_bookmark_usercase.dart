import 'package:japaneseapp/features/bookmark/data/models/word_model.dart';
import 'package:japaneseapp/features/bookmark/domain/repositories/bookmark_repository.dart';

class RemoveBookmarkUsercase {
  final BookmarkRepository bookmarkRepository;

  RemoveBookmarkUsercase({required this.bookmarkRepository});

  Future<void> call(WordModel wordModel) {
    return bookmarkRepository.removeBookmark(wordModel);
  }
}