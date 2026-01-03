/* ================= LEADERBOARD ================= */

import 'package:flutter/material.dart';
import 'package:japaneseapp/features/rank/domain/entities/leaderboard_entity.dart';
import 'package:japaneseapp/features/rank/presentation/widgets/other_rankings.dart';
import 'package:japaneseapp/features/rank/presentation/widgets/ranking_podium.dart';

class LeaderboardSection extends StatelessWidget {
  final LeaderboardEntity leaderboardEntity;

  const LeaderboardSection({super.key, required this.leaderboardEntity});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BXH MÙA TRƯỚC',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),

        RankingPodium(
            top1: leaderboardEntity.listUsers.isNotEmpty ? leaderboardEntity.listUsers[0] : null,
            top2: leaderboardEntity.listUsers.length >= 2 ? leaderboardEntity.listUsers[1] : null,
            top3: leaderboardEntity.listUsers.length >= 3 ? leaderboardEntity.listUsers[2] : null,
        ),
        SizedBox(height: 24),

        OtherRankings(leaderboardEntity)
      ],
    );
  }
}