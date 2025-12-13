import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/progress_state.dart';

class ProgressCubit extends Cubit<ProgressInitial>{
  ProgressCubit() : super(ProgressInitial(amount: 0));

  void increase(){
    emit(state.copyWith(amount: state.amount+1));
  }
}