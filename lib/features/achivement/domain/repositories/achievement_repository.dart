import 'package:flutter/cupertino.dart';
import 'package:japaneseapp/features/achivement/domain/entities/achivement_entity.dart';

abstract class AchievementRepository {
  // Achievement
  Future<void> addAchievement(String key);
  Future<void> showEffectAddAchievement(BuildContext context, int indexData);
  Future<List<String>> getUnlockedAchievements();

  // Progress
  Future<int> addLearnMinutes(int minutes);
  Future<int> increaseFastLearn();
  Future<int> addRememberedWord(String word);
  Future<int> increaseDownloadedTopic();
  Future<int> increaseTopComplete();

  //Load
  Future<AchivementEntity> loadAchivements();
}
