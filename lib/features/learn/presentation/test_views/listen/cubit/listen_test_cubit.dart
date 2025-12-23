import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:japaneseapp/core/Service/GoogleTTSService.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/listen/cubit/listen_test_state.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/widget/result_popup_widget.dart';


class ListenTestCubit extends Cubit<ListenTestState> {
  final Function(bool isCorrect) onComplete;

  GoogleTTSService googleTTSService = GoogleTTSService();
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> readText(String text, double speed) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.speak(text);
  }

  ListenTestCubit(
      WordEntity wordEntity,
      List<WordEntity> wordEntities,
      this.onComplete,
      ) : super(_init(wordEntity, wordEntities));

  static List<String> handleJapaneseString(String input) {
    final characters = input
        .split('')
        .where((e) => e.trim().isNotEmpty)
        .toList();

    characters.shuffle(Random());
    return characters;
  }

  static ListenTestState _init(
      WordEntity wordEntity,
      List<WordEntity> words,
      ) {
    final listCharacters = handleJapaneseString(wordEntity.word);
    WordEntity wordEntityAnother = wordEntity;
    while(wordEntityAnother==wordEntity){
      wordEntityAnother = words[Random().nextInt(words.length)];
    }

    listCharacters.addAll(handleJapaneseString(wordEntityAnother.word));

    return ListenTestState(
        userAnswer: [],
        listCharacter: listCharacters,
        currentWord: wordEntity,
        words: words
    );
  }



  void selectCharacter(String char, int index) {
    final characters = List<String>.from(state.listCharacter);
    final userAnswer = List<String>.from(state.userAnswer);

    final removedChar = characters.removeAt(index);
    userAnswer.add(removedChar);

    emit(state.copyWith(
      listCharacter: characters,
      userAnswer: userAnswer,
    ));
  }


  void removeCharacter(String char, int index) {
    final characters = List<String>.from(state.listCharacter);
    final userAnswer = List<String>.from(state.userAnswer);

    final removedChar = userAnswer.removeAt(index);
    characters.add(removedChar);

    emit(state.copyWith(
      userAnswer: userAnswer,
      listCharacter: characters,
    ));
  }

  Future<void> speak(WordEntity wordEnity) async{
    if(await googleTTSService.speak(wordEnity.wayread) == false){
      await readText(wordEnity.wayread, 0.5);
    }

  }

  /// Kiểm tra đáp án
  void checkAnswer(BuildContext context, Function(bool isCorrect) onComplete) {
    final answer = state.userAnswer.join();
    final correct = state.currentWord.word;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // để custom full UI
      builder: (sheetContext) {
        return ResultPopupWidget(
            isCorrect: answer == correct,
            wordEntity: state.currentWord,
            onPressButton: (){
              onComplete(answer == correct);
            },
            tryAgain: false
        );
      },
    );
  }

  /// Thử lại
  void retry() {
    // emit(state.copyWith(
    //   listCharacter: handleJapaneseString(state.currentWord.word),
    //   userAnswer: const [],
    //   status: ListenTestStatus.answering,
    //   canRetry: false,
    // ));
  }
}
