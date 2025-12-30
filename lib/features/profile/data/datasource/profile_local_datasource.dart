import 'package:japaneseapp/core/service/Local/local_db_service.dart';
import 'package:japaneseapp/features/profile/domain/entities/progress_entity.dart';
import 'package:japaneseapp/features/profile/domain/entities/statistic_entity.dart';
import 'package:japaneseapp/features/profile/domain/entities/streak_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalDataSource {
  Future<ProgressEntity> getProgress();
  Future<StreakEntity> getStreak();
  Future<StatisticEntity> getStatistic();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {

  ProfileLocalDataSourceImpl();

  @override
  Future<ProgressEntity> getProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return ProgressEntity(
      level: prefs.getInt("level") ?? 1,
      exp: prefs.getInt("exp") ?? 0,
      nextExp: prefs.getInt("nextExp") ?? 100,
    );
  }

  @override
  Future<StreakEntity> getStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return StreakEntity(
      prefs.getStringList("checkInHistory") ?? [],
      prefs.getStringList("checkInHistoryTreak") ?? [],
      prefs.getString("lastCheckIn") ?? "",
      prefs.getInt("Streak") ?? 0
    );
  }

  @override
  Future<StatisticEntity> getStatistic() async {
    LocalDbService db = LocalDbService.instance;
    return StatisticEntity(
      (await db.topicDao.getAllTopics()).length,
    );
  }
}
