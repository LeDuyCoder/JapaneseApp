import '../../Utilities/WeekUtils.dart';
import '../BaseService.dart';

class ScoreService extends BaseService {

  /// Get user score for a period
  Future<Map<String, dynamic>> getScore(String period, String userId) async {
    final data = await get('/controller/score/getScore.php',
        queryParams: {
          'period': period,
          'userId': userId,
        });

    if (data is Map<String, dynamic>) {
      if(data.containsKey("error")){
        await addScore(userId, 0);
        print("data: ${await getScore(period, userId)}");
        return await getScore(period, userId);
      }else {
        return data["score"];
      }
    } else {
      throw Exception('Dữ liệu trả về không hợp lệ');
    }
  }

  /// Get leaderboard for a period
  Future<List<Map<String, dynamic>>> getLeaderboard(String period, int limit) async {
    final data = await get('/controller/score/leaderboard.php',
        queryParams: {
          'period': period,
          'limit': limit.toString(),
        });

    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Dữ liệu trả về không hợp lệ');
    }
  }

  /// Add score for user
  Future<void> addScore(String userId, int score) async {
    final data = await postJson('/controller/score/addScore.php', {
      'userId': userId,
      'points': score,
      'period': WeekUtils.getCurrentWeekString(),
    });
    // Success handled by base class
  }
}