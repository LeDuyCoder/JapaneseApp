/// Lớp tiện ích để xử lý định dạng ngày tháng
///
/// Định dạng sử dụng: `dd/MM/yyyy`
/// Ví dụ:
/// ```dart
/// final now = DateTime.now();
/// final str = DateFormatter.format(now); // "22/12/2025"
/// final date = DateFormatter.parse("22/12/2025"); // DateTime(2025,12,22)
/// ```
class DateFormatter {
  /// Chuyển [DateTime] thành chuỗi theo định dạng "dd/MM/yyyy"
  ///
  /// Ví dụ:
  /// ```dart
  /// final now = DateTime(2025, 12, 22);
  /// final str = DateFormatter.format(now); // "22/12/2025"
  /// ```
  static String format(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/"
          "${d.month.toString().padLeft(2, '0')}/"
          "${d.year}";

  /// Chuyển chuỗi [value] theo định dạng "dd/MM/yyyy" thành [DateTime]
  ///
  /// Nếu [value] không hợp lệ (không đúng định dạng hoặc lỗi parse) sẽ ném [FormatException].
  ///
  /// Ví dụ:
  /// ```dart
  /// final date = DateFormatter.parse("22/12/2025"); // DateTime(2025,12,22)
  /// ```
  static DateTime parse(String value) {
    final p = value.split('/');
    return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
  }
}