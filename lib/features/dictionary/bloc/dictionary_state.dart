import 'package:japaneseapp/features/dictionary/domain/entities/word_entity.dart';

abstract class DictionaryState {}

class DictionaryInitial extends DictionaryState {}

class DictionaryLoading extends DictionaryState {}

class DictionaryNoData extends DictionaryState{}

class DictionaryLoaded extends DictionaryState {
  final WordEntity word;

  DictionaryLoaded(this.word);
}

class DictionaryError extends DictionaryState {
  final String message;
  DictionaryError(this.message);
}
