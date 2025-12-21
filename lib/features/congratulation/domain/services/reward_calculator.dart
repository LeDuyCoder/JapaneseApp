import 'dart:math';

class RewardCalculator {

  /// Tính EXP Rank thưởng sau khi hoàn thành bài học.
  ///
  /// Quy tắc:
  /// - Mỗi câu trả lời đúng nhận từ **10 → 15 EXP Rank**
  /// - Tổng EXP Rank là tổng của tất cả câu đúng
  /// - Nếu số câu sai > 50% tổng số câu:
  ///   → EXP Rank bị giảm **20%** (phạt hiệu suất kém)
  ///
  /// Mục đích:
  /// - Khuyến khích trả lời đúng
  /// - Tránh spam học ẩu vẫn lên rank nhanh
  ///
  /// Trả về:
  /// - Số EXP Rank nhận được (int)
  int calcExpRank({
    required int correct,
    required int incorrect,
    required int total,
  }) {
    int exp = 0;
    for (int i = 0; i < correct; i++) {
      exp += 10 + Random().nextInt(6);
    }

    if (incorrect > total / 2) {
      exp = (exp * 0.8).round();
    }
    return exp;
  }

  /// Tính số Kujicoin nhận được dựa trên độ chính xác bài làm.
  ///
  /// Quy tắc:
  /// - Accuracy = correctAnswer / totalQuestions
  /// - Coin = accuracy * 10
  /// - Coin được giới hạn trong khoảng **1 → 10**
  ///
  /// Ví dụ:
  /// - 100% đúng → 10 coin
  /// - 50% đúng → 5 coin
  /// - Rất thấp → vẫn nhận tối thiểu 1 coin
  ///
  /// Mục đích:
  /// - Thưởng ổn định theo hiệu suất
  /// - Không để người chơi "trắng tay"
  ///
  /// Trả về:
  /// - Số Kujicoin nhận được (int)
  int calcCoin(int correct, int total) {
    final accuracy = correct / total;
    return (accuracy * 10).clamp(1, 10).round();
  }

  /// Tính EXP Level nhận được sau mỗi lượt học.
  ///
  /// Tham số:
  /// - [level]: level hiện tại của người dùng
  /// - [expNeed]: số EXP còn thiếu để lên level tiếp theo
  ///
  /// Quy tắc:
  /// - Mỗi level cần khoảng **5–10 lượt học** để lên level
  /// - EXP mỗi lượt = expNeed / targetTurns
  /// - EXP được làm tròn theo bội số của 5 cho đẹp số
  /// - Có thêm một chút random để tránh nhàm chán
  /// - EXP tối thiểu luôn >= 5
  ///
  /// Mục đích:
  /// - Giữ tốc độ lên level ổn định
  /// - Level cao → EXP thưởng mỗi lượt cao hơn
  /// - Dễ cân bằng game về lâu dài
  ///
  /// Trả về:
  /// - EXP Level nhận được cho lượt học này (int)
  int calcLevelExp(int level, int expNeed) {
    final targetTurns = 5 + (level % 6);
    final xp = expNeed / targetTurns;
    final rounded = (xp / 5).round() * 5;
    final variation = Random().nextInt(5) - 10;
    return max(5, rounded + variation);
  }
}
