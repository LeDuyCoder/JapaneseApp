import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

class LearnWordState{
  final int currentIndex;
  final List<WordEntity> knownWords;
  final List<WordEntity> unknownWords;

  LearnWordState(
      {
        required this.currentIndex,
        required this.knownWords,
        required this.unknownWords
      }
  );

  LearnWordState copyWith({int? currentIndex, List<WordEntity>? knownWords, List<WordEntity>? unknownWords}){
    return LearnWordState(
      currentIndex: currentIndex ?? this.currentIndex,
      knownWords: knownWords ?? this.knownWords,
      unknownWords: unknownWords ?? this.unknownWords
    );
  }

}