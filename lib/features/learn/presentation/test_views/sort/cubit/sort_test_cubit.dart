import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:japaneseapp/core/Service/GoogleTTSService.dart';
import 'package:japaneseapp/core/Widget/learnWidget/sortText.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/sort/cubit/sort_test_state.dart';

import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/widget/result_popup_widget.dart';

class SortTestCubit extends Cubit<SortTestState>{

  SortTestCubit(
      WordEntity wordEntity,
      List<WordEntity> wordEntities,
      Sorts typeTest
      ) : super(_init(wordEntity, wordEntities, typeTest));

  GoogleTTSService googleTTSService = GoogleTTSService();
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> readText(String text, double speed) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.speak(text);
  }

  static List<String> handleJapaneseString(String input) {
    final characters = input
        .split('')
        .where((e) => e.trim().isNotEmpty)
        .toList();

    characters.shuffle(Random());
    return characters;
  }

  static List<String> handleVietnameseString(String mean) {
    List<String> newListString = mean
        .split(" ")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    newListString.shuffle();
    return newListString;
  }
  
  static SortTestState _init(
      WordEntity wordEntity,
      List<WordEntity> words,
      Sorts typeTest
      ) {

    List<WordEntity> listWordsFrom = List.from(words);
    listWordsFrom.remove(wordEntity);
    List<String> listCharacters = [];
    
    if(typeTest == Sorts.meanKanji){
      listCharacters.addAll(handleJapaneseString(wordEntity.word));
      listCharacters.addAll(handleJapaneseString(listWordsFrom[Random().nextInt(listWordsFrom.length)].word));
    }else{
      listCharacters.addAll(handleVietnameseString(wordEntity.mean));
      listCharacters.addAll(handleVietnameseString(listWordsFrom[Random().nextInt(listWordsFrom.length)].mean));
    }

    listCharacters.shuffle();

    return SortTestState(
        wordEntity: wordEntity,
        listWordEntities: words,
        typeTest: typeTest,
        userAnswer: [],
        listCharacter: listCharacters
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

  void checkAnswer(BuildContext context, VoidCallback onComplete) {
    String answer = state.userAnswer.join();
    String correct = state.wordEntity.word;

    switch(state.typeTest){
      case Sorts.kanjiMean:
        answer = state.userAnswer.join(" ");
        correct = state.wordEntity.mean;
        break;
      case Sorts.wayReadMean:
        answer = state.userAnswer.join(" ");
        correct = state.wordEntity.mean;
        break;
      case Sorts.meanKanji:
        answer = state.userAnswer.join();
        correct = state.wordEntity.word;
        break;
    }


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // để custom full UI
      builder: (sheetContext) {
        return ResultPopupWidget(
            isCorrect: answer == correct,
            wordEntity: state.wordEntity,
            onPressButton: (){
              onComplete();
            },
            tryAgain: false
        );
      },
    );
  }

  Future<void> speak(WordEntity wordEnity) async{
    String? textSpeak;
    if(state.typeTest == Sorts.kanjiMean || state.typeTest == Sorts.wayReadMean){
      textSpeak = wordEnity.wayread;
    }

    if(textSpeak != null){
      if(await googleTTSService.speak(textSpeak) == false){
        await readText(textSpeak, 0.5);
      }
    }

  }

}