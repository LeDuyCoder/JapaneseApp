import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Config/achivementJson.dart';
import 'package:japaneseapp/features/achivement/presentation/pages/achievement_unlock_page.dart';

class EffectReward{
  final int indexData;

  EffectReward({required this.indexData});

  Future<void> showEffectReward(BuildContext context) async {
    Map<String, String> dataAchivement = achivementJson.instance.data[indexData];

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => AchievementUnlockPage(
          imagePath: dataAchivement["img"] ?? "",
          title: dataAchivement["title"] ?? "",
          description: dataAchivement["description"] ?? "",
        ),
      ),
    );
  }
}