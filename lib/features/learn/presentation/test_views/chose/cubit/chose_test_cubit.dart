import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/chose/cubit/chose_test_state.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/widget/result_popup_widget.dart';

class ChoseTestCubit extends Cubit<ChoseTestState> {

  ChoseTestCubit(List<WordEntity> words, WordEntity word)
      : super(_init(words, word));

  static ChoseTestState _init(List<WordEntity> words, WordEntity word) {
    final copy = List<WordEntity>.from(words)
      ..remove(word)
      ..shuffle();
    final selected = copy.take(3).toList()..add(word);

    return ChoseTestState(
      null,
      currentWord: word,
      listWords: selected,
      typeTest: Choses.values[Random().nextInt(Choses.values.length)]
    );
  }

  void select(WordEntity wordEntity){
    emit(state.copyWith(
      chosen: wordEntity
    ));
  }

  void unselect(){
    emit(state.copyWith(chosen: null));
  }

  void checkAnswer(BuildContext context, VoidCallback onComplete){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // để custom full UI
      builder: (sheetContext) {
        return ResultPopupWidget(
            isCorrect: state.currentWord == state.chosen!,
            wordEntity: state.currentWord,
            onPressButton: (){
              onComplete();
            },
            tryAgain: false
        );
      },
    );

    if(state.chosen != null && state.chosen == state.currentWord){

    }else{


    }
  }
}