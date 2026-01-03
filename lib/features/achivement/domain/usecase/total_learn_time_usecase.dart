import 'package:japaneseapp/features/achivement/data/datasource/achivements_local_datasource.dart';
import 'package:japaneseapp/features/achivement/data/repositories/achievement_local_repository.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/effect_reward.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/total_learn_time_rule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TotalLearnTimeUsecase{
  Future<EffectReward?> call(int minuteLearn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TotalLearnTimeRule totalLearnTimeRule = TotalLearnTimeRule(
        AchievementLocalRepository(
            prefs, AchivementsLocalDatasource()),
        "achivement_3",
        2
    );

    bool isAddAchievement = await totalLearnTimeRule.evaluate(learnedMinutes: minuteLearn);
    if(isAddAchievement){
      return totalLearnTimeRule;
    }

    return null;
  }
}