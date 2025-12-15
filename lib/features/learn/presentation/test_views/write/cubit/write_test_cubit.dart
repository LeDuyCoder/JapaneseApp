import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/write/cubit/write_test_state.dart';

import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

class WriteTestCubit extends Cubit<WriteTestState>{
  WriteTestCubit(WordEntity wordEntity) : super(_init(wordEntity));

  static WriteTestState _init(WordEntity wordEntity) {
    return WriteTestState(
      "",
      wordEntity: wordEntity,
    );
  }

  void updateAnwser(String text) {
    emit(state.copyWith(
      userAnswer: state.userAnswer + text
    ));
  }
}