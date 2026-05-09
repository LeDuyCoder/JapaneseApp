import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/learn_word_state.dart';

class LearnWordCubit extends Cubit<LearnWordState> {
  final List<WordEntity> words;

  LearnWordCubit({required this.words})
      : super(
    LearnWordState(
      currentIndex: 0,
      knownWords: [],
      unknownWords: [],
    ),
  );

  void addKnownWord(WordEntity word) {
    final knownWords = List<WordEntity>.from(state.knownWords)
      ..add(word);

    emit(
      state.copyWith(
        knownWords: knownWords,
        currentIndex: state.currentIndex + 1,
      ),
    );
  }

  void addUnknownWord(WordEntity word) {
    final unknownWords =
    List<WordEntity>.from(state.unknownWords)
      ..add(word);

    emit(
      state.copyWith(
        unknownWords: unknownWords,
        currentIndex: state.currentIndex + 1,
      ),
    );
  }

  void back() {
    if (state.currentIndex <= 0) return;

    final previousWord =
    words[state.currentIndex - 1];

    final knownWords =
    List<WordEntity>.from(state.knownWords)
      ..remove(previousWord);

    final unknownWords =
    List<WordEntity>.from(state.unknownWords)
      ..remove(previousWord);

    emit(
      state.copyWith(
        currentIndex: state.currentIndex - 1,
        knownWords: knownWords,
        unknownWords: unknownWords,
      ),
    );
  }

  void replay(){
    emit(
      state.copyWith(
        currentIndex: 0,
        knownWords: [],
        unknownWords: [],
      ),
    );
  }
}