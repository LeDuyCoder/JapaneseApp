import 'package:japaneseapp/features/rank/domain/entities/leaderboard_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_leaderboard_entity.dart';

abstract class RankState{}

class LoadingRankState extends RankState{}

class LoadedRankState extends RankState{
  final LeaderboardEntity leaderboardEntity;
  final UserEntity userEntity;

  LoadedRankState({required this.leaderboardEntity, required this.userEntity});
}

class RewardRankState extends RankState{}

class ErrorRankState extends RankState{
  final String msg;

  ErrorRankState({required this.msg});

}