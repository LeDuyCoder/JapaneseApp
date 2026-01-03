import 'package:japaneseapp/core/service/Server/ServiceLocator.dart';
import 'package:japaneseapp/core/utils/week_utils.dart';
import 'package:japaneseapp/features/rank/domain/entities/leaderboard_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_leaderboard_entity.dart';

class LeaderboardDatasource{
  Future<LeaderboardEntity> load(int limit) async {
    String period = WeekUtils.getCurrentWeekString();
    List<Map<String, dynamic>> data = await ServiceLocator.scoreService.getLeaderboard(period, limit);
    List<UserLeaderboardEnity> userLeaderboardEnities = [];
    for (var entity in data) {
      userLeaderboardEnities.add(
        UserLeaderboardEnity(
            userId: entity["user_id"],
            userName: entity["user_name"],
            score: entity["score"]
        )
      );
    }

    return LeaderboardEntity(listUsers: userLeaderboardEnities);
  }
}