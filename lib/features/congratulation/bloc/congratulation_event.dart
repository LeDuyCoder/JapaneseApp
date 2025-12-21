import 'package:japaneseapp/features/congratulation/domain/entities/word_entity.dart';

abstract class CongratulationEvent {}

class CongratulationStarted extends CongratulationEvent {
  final int correctAnswers;
  final int incorrectAnsers;
  final List<WordEntity> words;

  CongratulationStarted(this.correctAnswers, this.incorrectAnsers, this.words);
}

class ShowAdsRewardEvent extends CongratulationEvent {
  final int expRankPlus;
  final int expPlus;
  final int coin;

  ShowAdsRewardEvent(this.coin, this.expRankPlus, this.expPlus);
}