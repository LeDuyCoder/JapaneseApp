import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:japaneseapp/core/Config/achivementJson.dart';
import 'package:japaneseapp/features/achivement/data/datasource/achivements_local_datasource.dart';
import 'package:japaneseapp/features/achivement/domain/entities/achivement_entity.dart';
import 'package:japaneseapp/features/achivement/domain/repositories/achievement_repository.dart';
import 'package:japaneseapp/features/achivement/presentation/pages/achievement_unlock_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementLocalRepository implements AchievementRepository {
  final SharedPreferences prefs;
  final AchivementsLocalDatasource datasource;

  AchievementLocalRepository(this.prefs, this.datasource);

  // ===== ACHIEVEMENT =====

  @override
  Future<void> addAchievement(String key) async {
    print("demo");
    final list = prefs.getStringList('achivement') ?? [];

    if (!list.contains(key)) {
      list.add(key);
      await prefs.setStringList('achivement', list);
    }
  }

  @override
  Future<List<String>> getUnlockedAchievements() async {
    return prefs.getStringList('achievements') ?? [];
  }

  // ===== PROGRESS =====

  @override
  Future<int> addLearnMinutes(int minutes) async {
    final total = (prefs.getInt('timeLearn') ?? 0) + minutes;
    await prefs.setInt('timeLearn', total);
    return total;
  }

  @override
  Future<int> increaseFastLearn() async {
    final count = (prefs.getInt('timeLearnFast') ?? 0) + 1;
    await prefs.setInt('timeLearnFast', count);
    return count;
  }

  @override
  Future<int> addRememberedWord(String word) async {
    final words = prefs.getStringList('wordsRemember') ?? [];

    if (!words.contains(word)) {
      words.add(word);
      await prefs.setStringList('wordsRemember', words);
    }

    return words.length;
  }

  @override
  Future<int> increaseDownloadedTopic() async {
    final count = (prefs.getInt('topicDownload') ?? 0) + 1;
    await prefs.setInt('topicDownload', count);
    return count;
  }

  @override
  Future<int> increaseTopComplete() async {
    final count = (prefs.getInt('amountTop') ?? 0) + 1;
    await prefs.setInt('amountTop', count);
    return count;
  }

  @override
  Future<AchivementEntity> loadAchivements() async {
    return datasource.loadAchivements();
  }

  @override
  Future<void> showEffectAddAchievement(BuildContext context, int indexData) async {
    Map<String, String> dataAchievement = achivementJson.instance.data[indexData];

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => AchievementUnlockPage(
          imagePath: dataAchievement["img"] ?? "",
          title: dataAchievement["title"] ?? "",
          description: dataAchievement["description"] ?? "",
        ),
      ),
    );
  }
}
