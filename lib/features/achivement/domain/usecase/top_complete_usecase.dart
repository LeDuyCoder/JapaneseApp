import 'package:japaneseapp/features/achivement/data/datasource/achivements_local_datasource.dart';
import 'package:japaneseapp/features/achivement/data/repositories/achievement_local_repository.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/effect_reward.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/top_complete_rule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopCompleteUsecase{
  Future<EffectReward?> call() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TopCompleteRule topCompleteRule = TopCompleteRule(
        AchievementLocalRepository(
            prefs, AchivementsLocalDatasource()),
        "achivement_7",
        6
    );

    var isAddAchievement = await topCompleteRule.evaluate();
    if(isAddAchievement){
      return topCompleteRule;
    }

    return null;
  }
}