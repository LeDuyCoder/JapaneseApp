import 'package:japaneseapp/features/dictionary/data/models/word_model.dart';

import '../domain/entities/word_entity.dart';

abstract class DictionaryEvent {}

class LoadDictionary extends DictionaryEvent {}

class SearchChanged extends DictionaryEvent {
  final String query;
  SearchChanged(this.query);
}

class ToggleBookmarkEvent extends DictionaryEvent {
  final WordEntity wordEntity;

  ToggleBookmarkEvent(this.wordEntity);
}

class RefreshScreenEvent extends DictionaryEvent {
  final WordEntity? wordEntity;

  RefreshScreenEvent({required this.wordEntity});
}