import 'package:flutter/cupertino.dart';
import 'package:japaneseapp/core/Config/achivementJson.dart';
import 'package:japaneseapp/features/achivement/domain/repositories/achievement_repository.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/achivement_rule.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/effect_reward.dart';
import 'package:japaneseapp/features/achivement/presentation/pages/achievement_unlock_page.dart';

class TimeRangeRule extends EffectReward implements AchievementRule {
  final AchievementRepository repository;
  final String achievementKey;
  final int indexData;
  final int startHour;
  final int endHour;
  TimeRangeRule({
    required this.repository,
    required this.achievementKey,
    required this.startHour,
    required this.endHour,
    required this.indexData,
  }) : super(indexData: indexData);

  @override
  Future<void> evaluate() async {
    final now = DateTime.now();
    if (now.hour >= startHour && now.hour < endHour) {
      print("Check here");
      await repository.addAchievement(achievementKey);
    }
  }
}
