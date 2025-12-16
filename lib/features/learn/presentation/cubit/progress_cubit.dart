import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/progress_state.dart';

class ProgressCubit extends Cubit<ProgressInitial>{
  final int maxQuestion;

  ProgressCubit(this.maxQuestion) : super(ProgressInitial(amount: 0));

  void increase(){
    if(state.amount < maxQuestion-1){
      emit(state.copyWith(amount: state.amount+1));
    }else{
    }
  }
}