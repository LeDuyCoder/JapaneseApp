import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/features/rank/presentation/pages/rank_up_screen.dart';

class ShowUpRankUsecase{
  Future<void> call(BuildContext context, String oldRankImage, String newRankImage, String newRankName, Color color) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => const RankUpScreen(
            oldRankImage: "assets/rank/gold.png",
            newRankImage: "assets/rank/diamond.png",
            newRankName: "Bậc Obsidian",
            glowColor: Colors.blue
        ),
      ),
    );
  }
}