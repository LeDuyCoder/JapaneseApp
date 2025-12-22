/// Entity đại diện cho **tiến trình phát triển của người dùng**.
///
/// [UserProgress] là một đối tượng bất biến (immutable),
/// được sử dụng trong tầng **domain** để mô tả:
/// - Level hiện tại
/// - Số exp đang có
/// - Mốc exp cần đạt để lên level tiếp theo
///
/// Entity này **không chứa logic nghiệp vụ**
/// và **không phụ thuộc** vào bất kỳ framework
/// hay tầng triển khai nào (UI, database, API).
class UserProgress {
  /// Level hiện tại của người dùng
  final int level;

  /// Số exp hiện có trong level hiện tại
  final int exp;

  /// Tổng exp cần để đạt level tiếp theo
  final int nextExp;

  /// Khởi tạo một [UserProgress].
  ///
  /// Tất cả các thuộc tính đều là bắt buộc
  /// nhằm đảm bảo trạng thái tiến trình
  /// luôn đầy đủ và hợp lệ.
  const UserProgress({
    required this.level,
    required this.exp,
    required this.nextExp,
  });

  /// Tạo một bản sao mới của [UserProgress]
  /// với các giá trị được thay đổi có chọn lọc.
  ///
  /// Phương thức này thường được dùng
  /// khi cần cập nhật tiến trình người dùng
  /// (ví dụ: cộng exp, lên level),
  /// nhưng vẫn giữ tính bất biến của entity.
  UserProgress copyWith({
    int? level,
    int? exp,
    int? nextExp,
  }) {
    return UserProgress(
      level: level ?? this.level,
      exp: exp ?? this.exp,
      nextExp: nextExp ?? this.nextExp,
    );
  }
}