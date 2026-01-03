import 'package:japaneseapp/features/rank/domain/entities/leaderboard_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/rank_entity.dart';

class SummaryRankEntity{
  final RankEntity rankEntity;
  final LeaderboardEntity leaderboardEntity;

  SummaryRankEntity({required this.rankEntity, required this.leaderboardEntity});
}