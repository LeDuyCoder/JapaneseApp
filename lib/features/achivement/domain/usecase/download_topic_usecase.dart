import 'package:japaneseapp/features/achivement/data/datasource/achivements_local_datasource.dart';
import 'package:japaneseapp/features/achivement/data/repositories/achievement_local_repository.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/download_topic_rule.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/effect_reward.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadTopicUsecase{
  Future<EffectReward?> call() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DownloadTopicRule topicRule = DownloadTopicRule(
        AchievementLocalRepository(prefs, AchivementsLocalDatasource()),
        "achivement_6",
        5
    );

    var isAddAchievement = await topicRule.evaluate();

    if(isAddAchievement){
      return topicRule;
    }

    return null;

  }
}