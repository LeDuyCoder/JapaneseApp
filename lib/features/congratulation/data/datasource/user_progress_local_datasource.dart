import 'package:japaneseapp/features/congratulation/domain/entities/user_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lớp chịu trách nhiệm lưu và đọc tiến độ người dùng (UserProgress) từ
/// SharedPreferences tại máy.
///
/// Sử dụng các khóa tĩnh `_levelKey`, `_expKey`, `_nextExpKey` để lưu trữ
/// thông tin cơ bản: level, exp, nextExp.
/// Không phụ thuộc trực tiếp vào phần presentation; có thể được gọi từ
/// repository hoặc usecase.
class UserProgressLocalDataSource {
  static const _levelKey = 'level';
  static const _expKey = 'exp';
  static const _nextExpKey = 'next_exp';

  /// Đọc tiến độ người dùng từ SharedPreferences.
  ///
  /// Trả về một đối tượng `UserProgress` với các giá trị:
  /// - `level`: nếu không tồn tại trong prefs sẽ mặc định là `1`
  /// - `exp`: nếu không tồn tại sẽ mặc định là `0`
  /// - `nextExp`: nếu không tồn tại sẽ mặc định là `100`
  ///
  /// Không ném ngoại lệ nếu SharedPreferences hoạt động bình thường.
  /// Nếu có lỗi IO/khởi tạo SharedPreferences, ngoại lệ sẽ được truyền lên caller.
  Future<UserProgress> getProgress() async {
    final prefs = await SharedPreferences.getInstance();


    return UserProgress(
      level: prefs.getInt(_levelKey) ?? 1,
      exp: prefs.getInt(_expKey) ?? 0,
      nextExp: prefs.getInt(_nextExpKey) ?? 100,
    );
  }

  /// Lưu tiến độ người dùng vào SharedPreferences.
  ///
  /// Tham số:
  /// - `progress`: đối tượng `UserProgress` chứa `level`, `exp`, `nextExp`.
  ///
  /// Hành động:
  /// - Ghi các giá trị vào SharedPreferences tương ứng với các khóa.
  /// - Trả về `Future<void>` khi hoàn thành.
  ///
  /// Lưu ý: nếu việc ghi gặp lỗi (ví dụ không gian lưu trữ), ngoại lệ sẽ được
  /// phát sinh và cần được xử lý ở caller.
  Future<void> saveProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_levelKey, progress.level);
    await prefs.setInt(_expKey, progress.exp);
    await prefs.setInt(_nextExpKey, progress.nextExp);
  }
}