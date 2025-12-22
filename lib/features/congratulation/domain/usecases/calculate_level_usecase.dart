import '../entities/user_progress.dart';

/// Use case chịu trách nhiệm tính toán level và EXP mới của người dùng.
///
/// Quy tắc:
/// - EXP mới = EXP hiện tại + EXP nhận được
/// - Khi EXP >= EXP cần cho level tiếp theo:
///   - Trừ EXP cần
///   - Tăng level lên 1
///   - Tăng EXP cần cho level tiếp theo (x1.2)
/// - Có thể lên **nhiều level trong một lần** nếu EXP đủ lớn
///
/// Nguyên tắc thiết kế:
/// - Không phụ thuộc UI
/// - Không gọi repository / API
/// - Chỉ xử lý **business logic**
///
/// Dùng trong:
/// - Sau khi hoàn thành bài học
/// - Sau khi nhận EXP thưởng
class CalculateLevelUseCase {

  /// Thực hiện tính toán level mới cho người dùng.
  ///
  /// Tham số:
  /// - [current]: tiến trình hiện tại của người dùng
  /// - [gainedExp]: EXP vừa nhận được từ bài học / nhiệm vụ
  ///
  /// Trả về:
  /// - [UserProgress] mới sau khi đã cộng EXP và xử lý lên level
  UserProgress call({
    required UserProgress current,
    required int gainedExp,
  }) {
    int level = current.level;
    int exp = current.exp + gainedExp;
    int nextExp = current.nextExp;


    while (exp >= nextExp) {
      exp -= nextExp;
      level++;
      nextExp = (nextExp * 1.2).round();
    }


    return UserProgress(
      level: level,
      exp: exp,
      nextExp: nextExp,
    );
  }
}