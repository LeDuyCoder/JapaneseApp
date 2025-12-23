import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/congratulation/presentation/pages/congratulation_page.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/progress_state.dart';

import 'package:japaneseapp/features/congratulation/domain/entities/word_entity.dart';

class ProgressCubit extends Cubit<ProgressInitial>{
  final int maxQuestion;
  int correctAnswer = 0;
  int inCorrectAnswer = 0;

  ProgressCubit(this.maxQuestion) : super(ProgressInitial(amount: 0));

  void calculateCorrectAnswer(bool isCorrect){
    if(isCorrect){
      correctAnswer++;
    }else{
      inCorrectAnswer++;
    }
  }

  void increase(BuildContext context, bool isCorrect, List words, Duration elapsed){
    if(state.amount < maxQuestion-1){
      calculateCorrectAnswer(isCorrect);
      emit(state.copyWith(amount: state.amount+1));
    }else{
      calculateCorrectAnswer(isCorrect);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CongratulationPage(
        correctAnswer: correctAnswer,
        inCorrectAnswer: inCorrectAnswer,
        totalQuestion: maxQuestion,
        words: words.map((word) => WordEntity.fromJson(word.toJson())).toList(),
        elapsed: elapsed,
      ),));
    }
  }
}