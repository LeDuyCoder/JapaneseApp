import 'package:japaneseapp/core/config/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInLocalDataSource {
  final SharedPreferences prefs;

  CheckInLocalDataSource(this.prefs);

  /// Lấy ngày check-in cuối cùng
  String? getLastCheckIn() => prefs.getString(PrefKeys.lastCheckIn);

  /// Lấy streak hiện tại
  List<String> getStreak() => prefs.getStringList(PrefKeys.checkInStreak) ?? [];

  /// Lưu ngày hôm nay vào lịch sử check-in
  Future<void> saveToday(String today) async {
    final days = prefs.getStringList(PrefKeys.checkInHistory) ?? [];
    if (!days.contains(today)) {
      days.add(today);
      await prefs.setStringList(PrefKeys.checkInHistory, days);
    }
  }

  /// Reset streak
  Future<void> resetStreak(String today) async {
    await prefs.setString(PrefKeys.lastCheckIn, today);
    await prefs.setStringList(PrefKeys.checkInStreak, [today]);
  }

  /// Tiếp tục streak
  Future<void> continueStreak(String today) async {
    final streak = getStreak();
    if (!streak.contains(today)) {
      streak.add(today);
      await prefs.setStringList(PrefKeys.checkInStreak, streak);
    }
    await prefs.setString(PrefKeys.lastCheckIn, today);
  }
}
