import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Service/Local/dao/VocabularyDao.dart';
import 'package:japaneseapp/core/ads/ad_result.dart';
import 'package:japaneseapp/core/ads/rewarded_ad_service_impl.dart';
import 'package:japaneseapp/features/congratulation/data/repositories/vocabulary_repository.dart';
import 'package:japaneseapp/features/congratulation/data/repositories/vocabulary_repository_impl.dart';
import 'package:japaneseapp/features/congratulation/domain/usecases/update_vocabulary_progress_usecase.dart';
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
    on<ShowAdsRewardEvent>(_onShowAdsReward);
  }

  Future<void> _onLoad(CongratulationStarted event, Emitter emit) async {
    emit(CongratulationLoading());
    UserProgress progress = await repo.getProgress();

    int expRankPlus = rewardCalculator.calcExpRank(correct: correctAnswer, incorrect: incorrtAnswer, total: totalQuestions);
    int coin = rewardCalculator.calcCoin(correctAnswer, totalQuestions);
    int expPlus = rewardCalculator.calcLevelExp(progress.level, progress.nextExp - progress.exp);

    VocabularyRepository vocabularyRepository = VocabularyRepositoryImpl(VocabularyDao());
    await UpdateVocabularyProgressUseCase(vocabularyRepository).execute(event.words);

    await repo.saveProgress(CalculateLevelUseCase().call(current: progress, gainedExp: expPlus));
    await repo.addCoin(coin);
    await repo.addExpRank(expRankPlus);
    await audioPlayerService.play("sound/completed.mp3");

    emit(CongratulationLoaded(coin, expRankPlus, expPlus, level: progress.level, exp: progress.exp, nextExp: progress.nextExp));
  }

  Future<void> _onShowAdsReward(ShowAdsRewardEvent event, Emitter emit) async {
    emit(CongratulationLoadingAds());
    AdResult watched = await RewardedAdServiceImpl().show();
    print("check watched ad result: $watched");
    UserProgress progress = await repo.getProgress();

    if(watched == AdResult.watched){
      repo.addCoin(event.coin);
      emit(CongratulationLoaded(event.coin * 2, event.expPlus, event.expRankPlus, level: progress.level, exp: progress.exp, nextExp: progress.nextExp));
    }
  }
}