import 'package:flutter/material.dart';

class RankManager {
  static const Map<String, dynamic> rankMap = {
    "Bronze": {
      "min": 0,
      "max": 500,
      "color": Colors.brown,
      "image": "assets/rank/copper.png",
      "name": "Bậc Đồng",
      "next": "Bạc"
    },
    "Silver": {
      "min": 501,
      "max": 1500,
      "color": Colors.grey,
      "image": "assets/rank/silver.png",
      "name": "Bậc Bạc",
      "next": "Vàng"
    },
    "Gold": {
      "min": 1501,
      "max": 3000,
      "color": Colors.orange,
      "image": "assets/rank/gold.png",
      "name": "Bậc Vàng",
      "next": "Kim Cương"
    },
    "Diamond": {
      "min": 3001,
      "max": 5000,
      "color": Colors.blueAccent,
      "image": "assets/rank/diamond.png",
      "name": "Bậc Kim Cương",
      "next": "Ruby"
    },
    "Ruby": {
      "min": 5001,
      "max": 8000,
      "color": Colors.red,
      "image": "assets/rank/ruby.png",
      "name": "Bậc Ruby",
      "next": "Obsidian"
    },
    "Obsidian": {
      "min": 8001,
      "max": double.infinity,
      "color": Colors.purple,
      "image": "assets/rank/Obsidian.png",
      "name": "Bậc Obsidian",
      "next": "Top 1"
    },
  };

  // Phương thức để lấy rank dựa trên điểm số
  static String getRankByScore(int score) {
    for (var entry in rankMap.entries) {
      final min = entry.value['min'] as int;
      final max = entry.value['max'] as double;

      if (score >= min && score <= max) {
        return entry.key;
      }
    }
    return "Bronze"; // Mặc định nếu không tìm thấy
  }

  // Phương thức để lấy thông tin chi tiết của rank
  static Map<String, dynamic> getRankInfo(String rankKey) {
    return rankMap[rankKey] ?? rankMap["Bronze"]!;
  }

  // Phương thức để lấy rank tiếp theo
  static String? getNextRank(String currentRank) {
    final currentRankInfo = rankMap[currentRank];
    if (currentRankInfo != null) {
      final nextRankName = currentRankInfo['next'] as String;
      // Tìm key của rank tiếp theo dựa trên tên
      for (var entry in rankMap.entries) {
        if (entry.value['name'] == nextRankName) {
          return entry.key;
        }
      }
    }
    return null;
  }

  // Phương thức kiểm tra và lấy thông tin rank up
  static Map<String, dynamic>? getRankUpInfo(int currentScore, int newScore) {
    final String oldRankKey = getRankByScore(currentScore);
    final String newRankKey = getRankByScore(newScore);

    if (oldRankKey != newRankKey) {
      return {
        'oldRank': oldRankKey,
        'newRank': newRankKey,
        'oldRankInfo': getRankInfo(oldRankKey),
        'newRankInfo': getRankInfo(newRankKey),
      };
    }
    return null;
  }
}