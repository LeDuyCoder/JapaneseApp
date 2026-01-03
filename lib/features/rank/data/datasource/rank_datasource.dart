import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/core/utils/week_utils.dart';
import 'package:japaneseapp/features/rank/domain/entities/leaderboard_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/rank_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/summary_rank_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_leaderboard_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RankDatasource{
  Future<SummaryRankEntity> load(String userId) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();

     String? perriorRank = prefs.getString("perrior_rank");
     UserEntity userEntity = await loadRankUser(userId);

     RankEntity rankEntity = RankEntity(perriorRank: perriorRank, userEntity: userEntity);
     List<Map<String, dynamic>> data = await ServiceLocator.scoreService.getLeaderboard(WeekUtils.getLastWeekString(), 6);
     List<UserLeaderboardEnity> userEntities = [];

     for(Map<String, dynamic> user in data){
       userEntities.add(
         UserLeaderboardEnity(
             userId: user["user_id"],
             userName: user["user_name"],
             score: user["score"]
         )
       );
     }

     LeaderboardEntity leaderboardEntity = LeaderboardEntity(listUsers: userEntities);

     return SummaryRankEntity(
         rankEntity: rankEntity,
         leaderboardEntity: leaderboardEntity
     );

  }

  Future<UserEntity> loadRankUser(String userId) async {
    Map<String, dynamic> userScore = await ServiceLocator.scoreService.getScore(WeekUtils.getLastWeekString(), userId);
    return UserEntity(
        userId: userId,
        score: userScore["score"],
        userName: userScore["user_name"],
        rank: userScore["rank"]
    );
  }
}