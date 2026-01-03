import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/utils/week_utils.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_entity.dart';
import 'package:japaneseapp/features/rank/bloc/rank_event.dart';
import 'package:japaneseapp/features/rank/bloc/rank_state.dart';
import 'package:japaneseapp/features/rank/domain/entities/leaderboard_entity.dart';
import 'package:japaneseapp/features/rank/domain/repositories/leaderboard_repository.dart';
import 'package:japaneseapp/features/rank/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RankBloc extends Bloc<RankEvent, RankState>{
  final LeaderBoardRepository leaderBoardRepository;
  final UserRepository userRepository;

  RankBloc(this.leaderBoardRepository, this.userRepository) : super(LoadingRankState()) {
    on<LoadRankEvent>(_onLoadRank);
  }

  Future<void> _onLoadRank(LoadRankEvent event, Emitter emit) async {
    try{
      LeaderboardEntity leaderboardEntity = await leaderBoardRepository.load();
      UserEntity userEntity = await userRepository.load(event.userId);
      emit(LoadedRankState(leaderboardEntity: leaderboardEntity, userEntity: userEntity));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String perriorRank = prefs.getString("perrior_rank") ?? "";
      if(perriorRank == "" || perriorRank != WeekUtils.getCurrentWeekString()){
        emit(RewardRankState());
      }
    }catch(e){
      emit(ErrorRankState(msg: e.toString()));
    }
  }
}