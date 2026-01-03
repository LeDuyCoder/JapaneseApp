import 'package:japaneseapp/features/achivement/data/datasource/achivements_local_datasource.dart';
import 'package:japaneseapp/features/achivement/data/repositories/achievement_local_repository.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/effect_reward.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/time_range_rule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeRangeUsecase{
  Future<EffectReward?> callAchievementOne() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> achievements = prefs.getStringList("achivement") ?? [];
    if(!achievements.contains("achivement_1")) {
      TimeRangeRule timeRangeRule = TimeRangeRule(
          repository: AchievementLocalRepository(
              prefs, AchivementsLocalDatasource()),
          achievementKey: "achivement_1",
          startHour: 5,
          endHour: 6,
          indexData: 0
      );

      timeRangeRule.evaluate();

      return timeRangeRule;
    }else{
      return null;
    }
  }

  Future<EffectReward?> callAchievementTwo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> achievements = prefs.getStringList("achivement") ?? [];

    if(!achievements.contains("achivement_2")) {
      TimeRangeRule timeRangeRule = TimeRangeRule(
          repository: AchievementLocalRepository(
              prefs, AchivementsLocalDatasource()),
          achievementKey: "achivement_2",
          startHour: 0,
          endHour: 5,
          indexData: 1,
      );

      timeRangeRule.evaluate();

      return timeRangeRule;
    }else{
      return null;
    }
  }
}