import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Config/rank_manager.dart';
import 'package:japaneseapp/features/rank/domain/entities/leaderboard_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_leaderboard_entity.dart';

class OtherRankings extends StatelessWidget{
  final LeaderboardEntity leaderboardEntity;

  const OtherRankings(this.leaderboardEntity);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(leaderboardEntity.listUsers.length >= 4)
          _RankRow(position: 4, userLeaderboardEnity: leaderboardEntity.listUsers[3]),
        if(leaderboardEntity.listUsers.length >= 5)
          _RankRow(position: 5, userLeaderboardEnity: leaderboardEntity.listUsers[4]),
        if(leaderboardEntity.listUsers.length >= 6)
          _RankRow(position: 6, userLeaderboardEnity: leaderboardEntity.listUsers[5]),
      ],
    );
  }
}

class _RankRow extends StatelessWidget {
  final int position;
  final UserLeaderboardEnity userLeaderboardEnity;

  const _RankRow({
    required this.position,
    required this.userLeaderboardEnity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(
            '#$position',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userLeaderboardEnity.userName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${userLeaderboardEnity.score} điểm',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            )
          ),
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
                RankManager.rankMap[RankManager.getRankByScore(userLeaderboardEnity.score)]["image"]
            ),
          )
        ],
      ),
    );
  }
}