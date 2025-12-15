import 'package:equatable/equatable.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

enum Sorts {
  kanjiMean,
  wayReadMean,
  meanKanji
}

class SortTestState extends Equatable{
  final WordEntity wordEntity;
  final List<WordEntity> listWordEntities;
  final List<String> userAnswer;
  final List<String> listCharacter;
  final Sorts typeTest;

  const SortTestState({required this.wordEntity, required this.listWordEntities, required this.userAnswer, required this.listCharacter, required this.typeTest});

  SortTestState copyWith({
    WordEntity? wordEntity,
    List<WordEntity>? listWordEntities,
    List<String>? listCharacter,
    List<String>? userAnswer,
    Sorts? typeTest
  }) {
    return SortTestState(
      wordEntity: wordEntity ?? this.wordEntity,
      listWordEntities: listWordEntities ?? this.listWordEntities,
      listCharacter: listCharacter ?? this.listCharacter,
      userAnswer: userAnswer ?? this.userAnswer,
      typeTest: typeTest ?? this.typeTest
    );
  }

  @override
  List<Object?> get props => [wordEntity, listWordEntities, listCharacter, userAnswer];
}