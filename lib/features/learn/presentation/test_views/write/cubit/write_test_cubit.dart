import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/write/cubit/write_test_state.dart';

import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/widget/result_popup_widget.dart';

class WriteTestCubit extends Cubit<WriteTestState>{
  WriteTestCubit(WordEntity wordEntity) : super(_init(wordEntity));

  static WriteTestState _init(WordEntity wordEntity) {
    return WriteTestState(
      wordEntity: wordEntity,
    );
  }


  void checkAnwser(BuildContext context, String answer, WordEntity wordEntity, VoidCallback onComplete){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // để custom full UI
      builder: (sheetContext) {
        return ResultPopupWidget(
            isCorrect: answer == wordEntity.word,
            wordEntity: state.wordEntity,
            onPressButton: (){
              onComplete();
            },
            tryAgain: false
        );
      },
    );
  }
}