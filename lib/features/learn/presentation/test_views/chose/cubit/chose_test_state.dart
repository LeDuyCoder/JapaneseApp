import 'package:equatable/equatable.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

enum Choses {
  kanjiWayRead,
  kanjiMean,
  wayReadKanji,
  wayReadMean,
  MeanKanji,
  meanWayRead
}

class ChoseTestState extends Equatable{
  final WordEntity currentWord;
  final List<WordEntity> listWords;
  final Choses typeTest;
  WordEntity? chosen;

  ChoseTestState(this.chosen, {required this.currentWord, required this.listWords, required this.typeTest});

  ChoseTestState copyWith({
    WordEntity? currentWord,
    List<WordEntity>? words,
    Choses? typeChose,
    WordEntity? chosen
  }) {
    return ChoseTestState(
      chosen,
      typeTest: typeTest,
      currentWord: currentWord ?? this.currentWord,
      listWords: words ?? listWords,
    );
  }

  @override
  List<Object?> get props => [currentWord, listWords, typeTest, chosen];
}