import 'package:flutter/cupertino.dart';
import 'package:japaneseapp/features/achivement/domain/repositories/achievement_repository.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/achivement_rule.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/effect_reward.dart';

class DownloadTopicRule extends EffectReward implements AchievementRule {
  final AchievementRepository repository;
  final String achievementKey;
  final int indexDataAchievement;

  DownloadTopicRule(this.repository, this.achievementKey, this.indexDataAchievement) : super(indexData: indexDataAchievement);

  @override
  Future<bool> evaluate() async {
    final count = await repository.increaseDownloadedTopic();
    if (count >= 50) {
      await repository.addAchievement(achievementKey);
      return true;
    }else{
      return false;
    }
  }
}
