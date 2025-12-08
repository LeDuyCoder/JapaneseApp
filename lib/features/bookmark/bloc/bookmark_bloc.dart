import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/bookmark/bloc/bookmark_event.dart';
import 'package:japaneseapp/features/bookmark/bloc/bookmark_state.dart';
import 'package:japaneseapp/features/bookmark/data/models/word_model.dart';
import 'package:japaneseapp/features/bookmark/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/bookmark/domain/repositories/bookmark_repository.dart';

class BookMarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final BookmarkRepository repo;

  BookMarkBloc(this.repo) : super(BookmarkInitial()) {
    on<LoadBookmarks>(_onLoad);
    on<RemoveBookmarkEvent>(_removeBookmark);
  }

  Future<void> _onLoad(LoadBookmarks event, Emitter emit) async {
    emit(BookmarkLoading());
    await Future.delayed(const Duration(seconds: 2));
    List<WordEntity> listWords = await repo.listBookmarks();
    emit(BookmarkLoaded(bookmarks: listWords));
  }

  Future<void> _removeBookmark(RemoveBookmarkEvent event, Emitter emit) async {
    emit(BookmarkLoading());
    await repo.removeBookmark(
        WordModel(
            word: event.wordEntity.word,
            reading: event.wordEntity.reading,
            meaning: event.wordEntity.meaning,
            exampleJP: event.wordEntity.exampleJP,
            exampleVI: event.wordEntity.exampleVI
        )
    );
    List<WordEntity> listWords = await repo.listBookmarks();
    emit(BookmarkLoaded(bookmarks: listWords));
  }


}