import 'package:shared_preferences/shared_preferences.dart';

/// Use case xử lý achievement liên quan đến check-in.
///
/// Lớp này kiểm tra thời gian hiện tại và set các achievement tương ứng:
/// - `cudemhockhuya`: check-in vào lúc 00:00 - 01:59
/// - `trithucdaysom`: check-in vào lúc 04:00 - 05:59
///
/// Achievements được lưu trữ trong SharedPreferences với key [_achievementKey].
class CheckInAchievementUseCase {

  /// Key dùng để lưu danh sách achievement trong SharedPreferences
  static const _achievementKey = 'achivement';

  /// Kiểm tra thời gian [now] và set achievement tương ứng nếu chưa có
  ///
  /// Ví dụ sử dụng:
  /// ```dart
  /// final now = DateTime.now();
  /// await CheckInAchievementUseCase.execute(now);
  /// ```
  static Future<void> execute(DateTime now) async {
    final prefs = await SharedPreferences.getInstance();
    final achievements = prefs.getStringList(_achievementKey) ?? [];

    if (now.hour >= 0 && now.hour < 2 && !achievements.contains('cudemhockhuya')) {
      achievements.add('cudemhockhuya');
    }

    if (now.hour >= 4 && now.hour < 6 && !achievements.contains('trithucdaysom')) {
      achievements.add('trithucdaysom');
    }

    await prefs.setStringList(_achievementKey, achievements);
  }
}
