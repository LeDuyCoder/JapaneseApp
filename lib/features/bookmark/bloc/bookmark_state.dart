import 'package:japaneseapp/features/bookmark/domain/entities/word_entity.dart';

abstract class BookmarkState {}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<WordEntity> bookmarks;

  BookmarkLoaded({required this.bookmarks});
}