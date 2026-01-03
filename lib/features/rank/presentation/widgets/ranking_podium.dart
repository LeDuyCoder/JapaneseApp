import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Config/rank_manager.dart';
import 'package:japaneseapp/core/utils/name_formatter.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_leaderboard_entity.dart';

class RankingPodium extends StatelessWidget {
  final UserLeaderboardEnity? top1;
  final UserLeaderboardEnity? top2;
  final UserLeaderboardEnity? top3;

  const RankingPodium({
    super.key,
    required this.top1,
    required this.top2,
    required this.top3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PodiumItem(
          user: top2,
          height: 140,
          color: const Color(0xFFC0C0C0), // bạc
          position: 2,
        ),
        const SizedBox(width: 12),
        _PodiumItem(
          user: top1,
          height: 180,
          color: const Color(0xFFFFD700), // vàng
          position: 1,
          isChampion: true,
        ),
        const SizedBox(width: 12),
        _PodiumItem(
          user: top3,
          height: 120,
          color: const Color(0xFFCD7F32), // đồng
          position: 3,
        ),
      ],
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final UserLeaderboardEnity? user;
  final double height;
  final Color color;
  final int position;
  final bool isChampion;

  const _PodiumItem({
    required this.user,
    required this.height,
    required this.color,
    required this.position,
    this.isChampion = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        Stack(
          alignment: Alignment.topCenter,
          children: [
            CircleAvatar(
              backgroundColor: Colors.red.withOpacity(0.1),
              radius: isChampion ? 34 : 30,
              child: Text(NameFormatter.formatName(user?.userName ?? "N/a")),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(
                    RankManager.rankMap[RankManager.getRankByScore(user?.score ?? 0)]["image"]
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),


        Text(
          user?.userName ?? "N/A",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Bục
        Container(
          width: 90,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                position.toString(),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${user?.score ?? 0} score',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
