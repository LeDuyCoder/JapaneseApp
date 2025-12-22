import 'package:shared_preferences/shared_preferences.dart';

/// Data source cục bộ dùng để lưu trữ và quản lý
/// số lần hiển thị quảng cáo (rewarded ads).
///
/// Lớp này sử dụng [SharedPreferences] để persist dữ liệu
/// trên thiết bị, giúp giá trị bộ đếm không bị mất
/// khi người dùng đóng hoặc mở lại ứng dụng.
///
/// Thường được sử dụng trong tầng **data** của kiến trúc
/// Clean Architecture, và được gọi thông qua Repository.
class AdsCounterLocalDataSource {

  /// Key dùng để lưu bộ đếm quảng cáo trong SharedPreferences
  static const key = 'rewarded_ads_counter';

  /// Instance của SharedPreferences dùng để đọc/ghi dữ liệu
  final SharedPreferences prefs;

  /// Khởi tạo [AdsCounterLocalDataSource] với
  /// một instance của [SharedPreferences].
  AdsCounterLocalDataSource(this.prefs);

  /// Lấy số lần quảng cáo đã được hiển thị.
  ///
  /// Nếu chưa từng lưu giá trị, mặc định trả về `0`.
  int getCounter() => prefs.getInt(key) ?? 0;

  /// Tăng bộ đếm quảng cáo lên `1`.
  ///
  /// Thường được gọi sau khi quảng cáo
  /// được hiển thị thành công.
  Future<void> increase() async {
    await prefs.setInt(key, getCounter() + 1);
  }

  /// Reset bộ đếm quảng cáo về `0`.
  ///
  /// Có thể sử dụng khi người dùng đạt mốc nào đó
  /// (ví dụ: sau khi nhận thưởng, hoặc reset theo ngày).
  Future<void> reset() async {
    await prefs.setInt(key, 0);
  }
}
