import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Config/rank_manager.dart';
import 'package:japaneseapp/features/rank/domain/entities/leaderboard_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_leaderboard_entity.dart';

class RankLeaderboard extends StatelessWidget {
  final LeaderboardEntity users;

  const RankLeaderboard({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: users.listUsers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = users.listUsers[index];
        return _RankItem(user: user, rank: index+1);
      },
    );
  }
}

class _RankItem extends StatelessWidget {
  final UserLeaderboardEnity user;
  final int rank;

  const _RankItem({required this.user, required this.rank});

  String formatName(String fullname) {
    if (fullname.trim().isEmpty) return "";

    List<String> parts = fullname.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      String first = parts[parts.length - 2][0].toUpperCase();
      String second = parts.last[0].toUpperCase();
      return first + second;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isTop3 = rank <= 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isTop3 ? const Color(0xFFFFF3E0) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          /// TOP
          SizedBox(
            width: 32,
            child: Text(
              "$rank",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isTop3 ? Colors.orange : Colors.grey,
              ),
            ),
          ),

          const SizedBox(width: 12),
          /// AVATAR
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.red.withOpacity(0.2),
            child: Text(formatName(user.userName)),
          ),
          const SizedBox(width: 12),
          /// NAME + POINT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.userName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${user.score} điểm rank',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          /// RANK
          SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(RankManager.rankMap[RankManager.getRankByScore(user.score)]["image"]),
          )
        ],
      ),
    );
  }
}
