import 'package:japaneseapp/features/achivement/domain/repositories/achievement_repository.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/effect_reward.dart';

class TotalLearnTimeRule extends EffectReward {
  final AchievementRepository repository;
  final String achievementKey;
  final int indexDataAchievement;

  TotalLearnTimeRule(this.repository, this.achievementKey, this.indexDataAchievement) : super(indexData:indexDataAchievement);

  Future<bool> evaluate({required int learnedMinutes}) async {
    final total = await repository.addLearnMinutes(learnedMinutes);

    if (total >= 10 * 60) {
      await repository.addAchievement(achievementKey);
      return true;
    }

    return false;
  }
}
