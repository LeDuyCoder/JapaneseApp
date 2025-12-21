import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/congratulation/presentation/pages/congratulation_page.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/progress_state.dart';

import 'package:japaneseapp/features/congratulation/domain/entities/word_entity.dart';

class ProgressCubit extends Cubit<ProgressInitial>{
  final int maxQuestion;

  ProgressCubit(this.maxQuestion) : super(ProgressInitial(amount: 0));

  void increase(BuildContext context, List words){
    if(state.amount < maxQuestion-1){
      emit(state.copyWith(amount: state.amount+1));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CongratulationPage(correctAnswer: 3, inCorrectAnswer: 2, totalQuestion: 5, words: words.map((word) => WordEntity.fromJson(word.toJson())).toList(),)));
    }
  }
}