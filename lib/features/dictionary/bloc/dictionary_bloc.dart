import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/dictionary/domain/repositories/dictionary_repository.dart';
import 'dictionary_event.dart';
import 'dictionary_state.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final DictionaryRepository repo;

  DictionaryBloc(this.repo) : super(DictionaryInitial()) {
    on<LoadDictionary>(_onLoad);
    on<SearchChanged>(_onSearch);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
  }

  Future<void> _onLoad(LoadDictionary event, Emitter emit) async {
    emit(DictionaryLoading());
    Future.delayed(const Duration(seconds: 3));
    emit(DictionaryNoData());
  }

  Future<void> _onSearch(SearchChanged event, Emitter emit) async {
    emit(DictionaryLoading());
    final words = await repo.searchWord(event.query);
    emit(DictionaryLoaded(words));
  }

  Future<void> _onToggleBookmark(ToggleBookmarkEvent event, Emitter emit) async {
  }
}
