import 'dart:core';

import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

import 'package:equatable/equatable.dart';

class ListenTestState extends Equatable {
  final WordEntity currentWord;
  final List<WordEntity> words;
  final List<String> userAnswer;
  final List<String> listCharacter;

  const ListenTestState({
    required this.userAnswer,
    required this.listCharacter,
    required this.currentWord,
    required this.words,
  });

  ListenTestState copyWith({
    WordEntity? currentWord,
    List<WordEntity>? words,
    List<String>? listCharacter,
    List<String>? userAnswer
  }) {
    return ListenTestState(
      currentWord: currentWord ?? this.currentWord,
      words: words ?? this.words,
      listCharacter: listCharacter ?? this.listCharacter,
      userAnswer: userAnswer ?? this.userAnswer,
    );
  }

  @override
  List<Object> get props => [currentWord, words, listCharacter, words];
}
