/// Utility class dùng để format [Duration] thành chuỗi thời gian
/// theo định dạng **giờ : phút : giây**.
///
/// ### Quy tắc format:
/// - **Có giờ** → `H:MM:SS`
///   - Ví dụ: `2:00:14`
///
/// - **Không có giờ nhưng có phút** → `MM:SS`
///   - Ví dụ: `02:25`
///
/// - **Chỉ có giây** → `00:SS`
///   - Ví dụ: `00:25`
///
/// ### Lưu ý:
/// - Giờ **không pad 2 chữ số** (2 thay vì 02)
/// - Phút và giây **luôn pad 2 chữ số**
/// - Không hiển thị phần thời gian bằng `0` không cần thiết
///
/// ### Ví dụ:
/// ```dart
/// DurationFormatter.format(
///   const Duration(hours: 2, minutes: 0, seconds: 14),
/// ); // 2:00:14
///
/// DurationFormatter.format(
///   const Duration(minutes: 2, seconds: 25),
/// ); // 02:25
///
/// DurationFormatter.format(
///   const Duration(seconds: 25),
/// ); // 00:25
/// ```
class DurationFormatter {
  /// Private constructor để ngăn việc khởi tạo class này
  DurationFormatter._();

  /// Format một [Duration] thành chuỗi thời gian.
  ///
  /// Trả về chuỗi theo các định dạng:
  /// - `H:MM:SS` nếu có giờ
  /// - `MM:SS` nếu không có giờ nhưng có phút
  /// - `00:SS` nếu chỉ có giây
  static String format(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }

    if (minutes > 0) {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }

    return '00:${twoDigits(seconds)}';
  }
}
