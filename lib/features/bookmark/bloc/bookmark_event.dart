import 'package:japaneseapp/features/bookmark/domain/entities/word_entity.dart';

abstract class BookmarkEvent {}

class LoadBookmarks extends BookmarkEvent {}

class ReturnToSearch extends BookmarkEvent {}

class RemoveBookmarkEvent extends BookmarkEvent {
  final WordEntity wordEntity;

  RemoveBookmarkEvent({required this.wordEntity});
}