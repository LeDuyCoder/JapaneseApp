import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/topicdetail/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/topicdetail/cubit/chose_type_state.dart';

class ChoseTypeCubit extends Cubit<ChoseTypeState> {
  ChoseTypeCubit(List<WordEntity> choseWords)
      : super(ChoseTypeState(choseWords: choseWords));

  void addChoseWord(WordEntity wordEntity) {
    final updatedList = List<WordEntity>.from(state.choseWords)
      ..add(wordEntity);

    emit(ChoseTypeState(choseWords: updatedList));
  }

  void removeChoseWord(WordEntity wordEntity) {
    final updatedList = List<WordEntity>.from(state.choseWords)
      ..remove(wordEntity);

    emit(ChoseTypeState(choseWords: updatedList));
  }

  bool isContain(WordEntity wordEntity) {
    return state.choseWords.contains(wordEntity);
  }
}