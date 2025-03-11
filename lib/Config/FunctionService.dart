import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FunctionService{

  static DateTime parseDateManual(String dateString) {
    List<String> parts = dateString.split('/');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  // Hàm reset chuỗi điểm danh
  static Future<void> _resetCheckInStreak(SharedPreferences prefs, String today) async {
    prefs.setString("lastCheckIn", today);
    prefs.setStringList("checkInHistoryTreak", [today]);
  }

  // Hàm tiếp tục chuỗi điểm danh (chỉ thêm nếu chưa có)
  static Future<void> _continueCheckInStreak(SharedPreferences prefs, String today) async {
    List<String> streak = prefs.getStringList("checkInHistoryTreak") ?? [];
    if (!streak.contains(today)) {
      streak.add(today);
      prefs.setStringList("checkInHistoryTreak", streak);
    }
    prefs.setString("lastCheckIn", today);
  }

  static Future<void> setDay() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String today = "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}";

    // Lấy danh sách check-in lịch sử, nếu null thì tạo danh sách mới
    List<String> days = prefs.getStringList("checkInHistory") ?? [];
    if (!days.contains(today)) {
      days.add(today);
      prefs.setStringList("checkInHistory", days);
    }

    // Kiểm tra lần check-in gần nhất
    String? lastCheck = prefs.getString("lastCheckIn");
    if (lastCheck == null || lastCheck.isEmpty) {
      await _resetCheckInStreak(prefs, today);
      return;
    }

    // Tính khoảng cách ngày giữa hôm nay và lần check-in trước
    DateTime lastCheckDate = FunctionService.parseDateManual(lastCheck);
    int daysDifference = now.difference(lastCheckDate).inDays;

    // Nếu khoảng cách > 1 ngày, reset streak
    if (daysDifference > 1) {
      await _resetCheckInStreak(prefs, today);
    } else {
      await _continueCheckInStreak(prefs, today);
    }

    // Đánh dấu thành tựu nếu điểm danh vào sáng sớm
    if (now.hour >= 0 && now.hour < 2) {
      await setAchivement("cudemhockhuya");
    }

    if(now.hour >= 4 && now.hour < 6){
      await setAchivement("trithucdaysom");
    }
  }

  static Future<void> setAchivement(String achivement) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> Achivements = prefs.getStringList("achivement")!;
    if(!Achivements.contains(achivement)) {
      Achivements.add(achivement);
      prefs.setStringList("achivement", Achivements);
    }
  }

  static Future<int> getTopicComplite() async {
    DatabaseHelper db = DatabaseHelper.instance;
    return (await db.countCompletedTopics());
  }
}