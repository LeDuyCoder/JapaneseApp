import 'package:japaneseapp/features/rank/domain/entities/leaderboard_entity.dart';

abstract class LeaderBoardRepository{
  Future<LeaderboardEntity> load();
}