import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/congratulation/bloc/congratulation_event.dart';
import 'package:japaneseapp/features/congratulation/bloc/congratulation_state.dart';
import 'package:japaneseapp/features/congratulation/domain/entities/user_progress.dart';
import 'package:japaneseapp/features/congratulation/domain/repositories/user_progress_repository.dart';
import 'package:japaneseapp/features/congratulation/domain/services/audio_player_service.dart';
import 'package:japaneseapp/features/congratulation/domain/services/reward_calculator.dart';
import 'package:japaneseapp/features/congratulation/domain/usecases/calculate_level_usecase.dart';

class CongratulationBloc extends Bloc<CongratulationEvent, CongratulationState>{
  final UserProgressRepository repo;
  final int correctAnswer;
  final int incorrtAnswer;
  final int totalQuestions;

  AudioPlayerService audioPlayerService = AudioPlayerService();
  RewardCalculator rewardCalculator = RewardCalculator();

  CongratulationBloc(this.repo, this.correctAnswer, this.incorrtAnswer, this.totalQuestions) : super(CongratulationInitial()){
    on<CongratulationStarted>(_onLoad);
  }

  Future<void> _onLoad(CongratulationStarted event, Emitter emit) async {
    emit(CongratulationLoading());
    UserProgress progress = await repo.getProgress();

    int expRankPlus = rewardCalculator.calcExpRank(correct: correctAnswer, incorrect: incorrtAnswer, total: totalQuestions);
    int coin = rewardCalculator.calcCoin(correctAnswer, totalQuestions);
    int expPlus = rewardCalculator.calcLevelExp(progress.level, progress.nextExp - progress.exp);
    
    await repo.saveProgress(CalculateLevelUseCase().call(current: progress, gainedExp: expPlus));
    await repo.addCoin(coin);
    await repo.addExpRank(expRankPlus);
    await audioPlayerService.play("sound/completed.mp3");
    emit(CongratulationLoaded(coin, expRankPlus, expPlus, level: progress.level, exp: progress.exp, nextExp: progress.nextExp));
  }
}