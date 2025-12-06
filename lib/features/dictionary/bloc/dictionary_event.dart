abstract class DictionaryEvent {}

class LoadDictionary extends DictionaryEvent {}

class SearchChanged extends DictionaryEvent {
  final String query;
  SearchChanged(this.query);
}

class ToggleBookmarkEvent extends DictionaryEvent {
  final String id;
  ToggleBookmarkEvent(this.id);
}