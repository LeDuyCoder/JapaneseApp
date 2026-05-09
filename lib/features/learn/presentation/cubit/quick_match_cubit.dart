import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/quick_match_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/card_entity.dart';

class QuickMatchCubit extends Cubit<QuickMatchState>{
  static const int wrongPenaltySeconds = 3;

  final List<WordEntity> words;
  Timer? _timer;

  QuickMatchCubit({required this.words}) : super(const QuickMatchState(listCompletes: [], listCards: [], timeElapsed: 0, record: 0));

  Future<void> generateCards(String topicId) async {
    final cards = words.expand((word) {
      return [
        CardEntity(
          text: word.word,
          wordEntity: word,
        ),
        CardEntity(
          text: word.mean,
          wordEntity: word,
        ),
      ];
    }).toList();

    cards.shuffle();

    startTimer();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int record = sharedPreferences.getInt("record_$topicId") ?? 0;

    emit(state.copyWith(listCards: cards, record: record));
  }

  Future<void> complete(String topicId, WordEntity word) async {

    final newListCompletes = List<WordEntity>.from(state.listCompletes)
      ..add(word);

    emit(state.copyWith(listCompletes: newListCompletes, clearChosen: true));

    if (newListCompletes.length >= 5) {
      stopTimer();
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      int record = sharedPreferences.getInt("record_$topicId") ?? 0;
      if(_timer!.tick < record || _timer!.tick == 0){
        sharedPreferences.setInt("record_$topicId", _timer!.tick);
      }

    }
  }

  void choseCard(CardEntity card){
    emit(state.copyWith(cardChosen: card));
  }

  void unChoseCard(){
    emit(state.copyWith(cardChosen: null, clearChosen: true));
  }

  void wrong(CardEntity card) async {
    emit(state.copyWith(cardWrong: card, timeElapsed: state.timeElapsed + wrongPenaltySeconds,));
    //addPenaltyTime();
    await Future.delayed(const Duration(milliseconds: 400));
    emit(
      state.copyWith(
        clearChosen: true,
        cardChosen: null,
        cardWrong: null,
      ),
    );
  }

  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(state.copyWith(timeElapsed: state.timeElapsed + 1));
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void addPenaltyTime([int seconds = wrongPenaltySeconds]) {
    emit(state.copyWith(
      timeElapsed: state.timeElapsed + seconds,
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

}