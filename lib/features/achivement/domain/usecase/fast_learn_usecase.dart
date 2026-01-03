import 'package:japaneseapp/features/achivement/data/datasource/achivements_local_datasource.dart';
import 'package:japaneseapp/features/achivement/data/repositories/achievement_local_repository.dart';
import 'package:japaneseapp/features/achivement/domain/service/achievement_evaluator.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/effect_reward.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/fast_learn_rule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FastLearnUsecase{
  Future<EffectReward?> call() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     FastLearnRule fastLearnRule = FastLearnRule(AchievementLocalRepository(
         prefs, AchivementsLocalDatasource()),
         "achivement_4",
         3
     );

    var isAddAchievement = await fastLearnRule.evaluate();

    if(isAddAchievement){
      return fastLearnRule;
    }
    return null;
  }
}