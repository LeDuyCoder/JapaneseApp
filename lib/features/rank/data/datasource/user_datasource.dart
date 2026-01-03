import 'package:japaneseapp/core/service/Server/ServiceLocator.dart';
import 'package:japaneseapp/core/utils/week_utils.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_entity.dart';

class UserDatasource{
  Future<UserEntity> load(String userId) async {
    String period = WeekUtils.getCurrentWeekString();
    Map<String, dynamic> data = (await ServiceLocator.scoreService.getScore(period, userId));

    return UserEntity(
      userId: userId,
      score: data["score"],
      userName: data["user_name"],
      rank: data["rank"]
    );
  }
}