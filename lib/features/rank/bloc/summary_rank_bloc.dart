import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/core/config/reward_config.dart';
import 'package:japaneseapp/core/utils/week_utils.dart';
import 'package:japaneseapp/features/rank/bloc/summary_rank_event.dart';
import 'package:japaneseapp/features/rank/bloc/summary_rank_state.dart';
import 'package:japaneseapp/features/rank/domain/entities/summary_rank_entity.dart';
import 'package:japaneseapp/features/rank/domain/repositories/rank_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummaryRankBloc extends Bloc<SummaryRankEvent, SummaryRankState>{
  final RankRepository repository;

  SummaryRankBloc({required this.repository}) : super(LoadingSummaryRankState()) {
    on<LoadSummaryRankEvent>(_onSummaryLoadRank);
    on<RewardSummaryRankEvent>(_onRewardRank);
  }

  Future<void> _onSummaryLoadRank(LoadSummaryRankEvent event, Emitter emit) async {
    SummaryRankEntity summaryRankEntity = await repository.load(event.userId);
    emit(LoadedSummaryRankState(summaryRankEntity: summaryRankEntity));
  }

  Future<void> _onRewardRank(RewardSummaryRankEvent event, Emitter emit) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("perrior_rank", WeekUtils.getCurrentWeekString());
    int rank = event.summaryRankEntity.rankEntity.userEntity.rank;
    if(rank <= 3){
      int coin = 100;
      if(rank == 1){
        coin = RewardConfig.top_1;
      }else if(rank == 2){
        coin = RewardConfig.top_2;
      }

      ServiceLocator.userService.addCoin(event.summaryRankEntity.rankEntity.userEntity.userId, coin);
    }else if(event.summaryRankEntity.rankEntity.userEntity.rank <= 6){
      ServiceLocator.userService.addCoin(event.summaryRankEntity.rankEntity.userEntity.userId, RewardConfig.topOther);
    }

    emit(RewardCompletedState());
  }
}