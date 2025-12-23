import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/widget/result_popup_widget.dart';
import 'combination_test_state.dart';

class CombinationTestCubit extends Cubit<CombinationTestState> {
  final Function(bool isCorrect) onComplete;

  CombinationTestCubit(List<WordEntity> words, {required this.onComplete})
      : super(_init(words));

  static CombinationTestState _init(List<WordEntity> words) {
    final copy = List<WordEntity>.from(words)..shuffle();
    final selected = copy.take(4).toList();

    return CombinationTestState(
      columA: List<WordEntity>.from(selected)..shuffle(),
      columB: List<WordEntity>.from(selected)..shuffle(),
      typeCombination: Combinations.values[Random().nextInt(1)],
    );
  }

  void selectA(BuildContext context, WordEntity word) {
    if(!state.completes.contains(word)) {
      emit(state.copyWith(selectedA: word, selectedB: state.selectedB));
      if (state.selectedA != null && state.selectedB != null) {
        checkAnwser(context);
      }
    }
  }

  void selectB(BuildContext context, WordEntity word) {
    if(!state.completes.contains(word)) {
      emit(state.copyWith(selectedA: state.selectedA ,selectedB: word));
      if(state.selectedA != null && state.selectedB != null){
        checkAnwser(context);
      }
    }
  }

  void checkAnwser(BuildContext context){
    if(isCorrect()){
      emit(state.copyWith(
        selectedA: null,
        selectedB: null,
        completes: [...state.completes, state.selectedA!],
      ));

      if(state.completes.length == 4){
        onComplete(true);
      }
    }else{
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent, // để custom full UI
        builder: (sheetContext) {
          return ResultPopupWidget(
              isCorrect: false,
              wordEntity: state.selectedA!,
              onPressButton: (){
                clearSelection();
              },
              tryAgain: true
          );
        },
      );
    }
  }

  bool isCorrect() {
    return state.selectedA == state.selectedB;
  }

  void clearSelection() {
    emit(state.copyWith(selectedA: null, selectedB: null));
  }

  bool isExist(WordEntity wordEntity){
    return state.completes.contains(wordEntity);
  }

}
