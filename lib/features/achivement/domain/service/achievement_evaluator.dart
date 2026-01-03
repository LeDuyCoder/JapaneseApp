import 'package:japaneseapp/features/achivement/domain/service/evaluators/achivement_rule.dart';

class AchievementEvaluator {
  final List<AchievementRule> rules;

  AchievementEvaluator(this.rules);

  Future<void> evaluateAll() async {
    for (final rule in rules) {
      await rule.evaluate();
    }
  }
}
