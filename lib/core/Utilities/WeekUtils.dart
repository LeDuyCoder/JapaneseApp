class WeekUtils {
  static String getCurrentWeekString() {
    final now = DateTime.now();

    // Lấy số tuần theo chuẩn ISO 8601 (tuần bắt đầu từ thứ Hai)
    final weekNumber = _getIsoWeekNumber(now);
    final year = now.year;

    return 'week-$year-$weekNumber';
  }

  /// Tính số tuần ISO 8601
  static int _getIsoWeekNumber(DateTime date) {
    // Điều chỉnh ngày sang thứ Năm cùng tuần để đúng chuẩn ISO
    final adjusted = date.subtract(Duration(days: date.weekday - 1));
    final firstDayOfYear = DateTime(adjusted.year, 1, 1);
    final daysDifference = adjusted.difference(firstDayOfYear).inDays;

    // ISO: tuần đầu tiên có ít nhất 4 ngày trong năm mới
    final firstThursday = firstDayOfYear.weekday <= DateTime.thursday
        ? firstDayOfYear.add(Duration(days: DateTime.thursday - firstDayOfYear.weekday))
        : firstDayOfYear.add(Duration(days: 7 - (firstDayOfYear.weekday - DateTime.thursday)));

    final weekNumber = ((adjusted.difference(firstThursday).inDays) / 7).floor() + 1;
    return weekNumber < 1 ? 1 : weekNumber;
  }
}
