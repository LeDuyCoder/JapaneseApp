import 'package:japaneseapp/features/achivement/domain/repositories/achievement_repository.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/effect_reward.dart';

class RememberWordRule extends EffectReward {
  final AchievementRepository repository;
  final String achievementKey;
  final int indexDataAchievement;

  RememberWordRule(this.repository, this.achievementKey, this.indexDataAchievement) : super(indexData: indexDataAchievement);

  Future<bool> evaluate(String word) async {
    final count = await repository.addRememberedWord(word);
    if (count >= 200) {
      await repository.addAchievement(achievementKey);
      return true;
    }

    return false;
  }
}
