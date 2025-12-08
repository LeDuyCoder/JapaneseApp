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
    on<RefreshScreenEvent>(_onRefresh);
  }

  Future<void> _onLoad(LoadDictionary event, Emitter emit) async {
    emit(DictionaryLoading());
    Future.delayed(const Duration(seconds: 3));
    emit(DictionaryNoData());
  }

  Future<void> _onSearch(SearchChanged event, Emitter emit) async {
    emit(DictionaryLoading());
    try {
      final word = await repo.searchWord(event.query);
      emit(DictionaryLoaded(word));
    } catch (e) {
      emit(DictionaryError("Không Tìm Thấy Từ Này"));
    }
    
  }

  Future<void> _onToggleBookmark(ToggleBookmarkEvent event, Emitter<DictionaryState> emit) async {
    emit(DictionaryLoading());
    emit(DictionaryLoaded(await repo.toggleBookmark(event.wordEntity)));
  }

  Future<void> _onRefresh(RefreshScreenEvent event, Emitter<DictionaryState> emit) async {
    emit(DictionaryLoading());
    if(event.wordEntity != null) {
      event.wordEntity!.isBookmarked = !event.wordEntity!.isBookmarked;
      emit(DictionaryLoaded(event.wordEntity!));
    }
  }
}
