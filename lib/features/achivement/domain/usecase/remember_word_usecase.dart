import 'package:japaneseapp/features/achivement/data/datasource/achivements_local_datasource.dart';
import 'package:japaneseapp/features/achivement/data/repositories/achievement_local_repository.dart';
import 'package:japaneseapp/features/achivement/domain/service/achievement_evaluator.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/effect_reward.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/remember_word_rule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberWordUseccase{
  Future<EffectReward?> call(String word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    RememberWordRule rememberWordRule = RememberWordRule(
        AchievementLocalRepository(
            prefs, AchivementsLocalDatasource()),
        "achivement_5",
        4
    );

    var isAddAchievement = await rememberWordRule.evaluate(word);

    if(isAddAchievement){
      return rememberWordRule;
    }else{
      return null;
    }
  }
}