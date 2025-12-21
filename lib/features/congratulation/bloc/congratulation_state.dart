import 'package:japaneseapp/features/congratulation/domain/entities/user_progress.dart';

abstract class CongratulationState {}

class CongratulationInitial extends CongratulationState{}

class CongratulationLoading extends CongratulationState{}

class CongratulationLoadingAds extends CongratulationState{}

class CongratulationLoaded extends CongratulationState{
  final int level;
  final int exp;
  final int nextExp;

  final int coinPlus;
  final int expRankPlus;
  final int expPlus;

  CongratulationLoaded(this.coinPlus, this.expRankPlus, this.expPlus, {required this.level, required this.exp, required this.nextExp});
}