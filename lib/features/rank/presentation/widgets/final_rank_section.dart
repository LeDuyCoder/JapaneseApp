/* ================= FINAL RANK ================= */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Config/rank_manager.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_entity.dart';

class FinalRankSection extends StatelessWidget {
  final UserEntity userEntity;

  const FinalRankSection({super.key, required this.userEntity});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> rankInfo = RankManager.getRankInfo(RankManager.getRankByScore(userEntity.score));

    return Column(
      children: [
        SizedBox(
          width: 180,
          height: 180,
          child: Image.asset(rankInfo["image"])
        ),
        const SizedBox(height: 5),
        Text(
          rankInfo["name"],
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: rankInfo["color"]
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Bậc rank mùa trước',
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}