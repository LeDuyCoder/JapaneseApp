import 'package:japaneseapp/features/congratulation/domain/entities/user_progress.dart';

/// Repository cung cấp và quản lý tiến trình học của người dùng.
///
/// Đóng vai trò là **contract** giữa Domain layer và Data layer.
/// Domain layer (Bloc / UseCase) **không quan tâm** dữ liệu đến từ đâu
/// (local storage, database, API, cache…).
///
/// Trách nhiệm chính:
/// - Cung cấp tiến trình học hiện tại của người dùng
/// - Lưu lại tiến trình sau khi học
/// - Cập nhật phần thưởng (coin, EXP rank)
///
/// Lưu ý:
/// - Repository **không chứa logic UI**
/// - Repository **không quyết định luật thưởng**
/// - Chỉ chịu trách nhiệm truy xuất và lưu trữ dữ liệu
abstract class UserProgressRepository {

  /// Lấy tiến trình học hiện tại của người dùng.
  ///
  /// Thường được gọi khi:
  /// - Mở app
  /// - Hoàn thành bài học
  /// - Cần tính toán EXP / level mới
  ///
  /// Trả về:
  /// - [UserProgress] chứa level, EXP, EXP cần cho level tiếp theo
  Future<UserProgress> getProgress();

  /// Lưu lại tiến trình học của người dùng.
  ///
  /// Được gọi sau khi:
  /// - Cộng EXP
  /// - Lên level
  /// - Cập nhật tiến trình học
  ///
  /// [progress] là trạng thái tiến trình mới cần lưu.
  Future<void> saveProgress(UserProgress progress);

  /// Cộng thêm Kujicoin cho người dùng.
  ///
  /// Thường dùng làm phần thưởng sau bài học hoặc nhiệm vụ.
  /// Không ảnh hưởng đến EXP level.
  ///
  /// [coin] là số coin cần cộng thêm.
  Future<void> addCoin(int coin);

  /// Cộng EXP Rank cho người dùng.
  ///
  /// EXP Rank dùng cho:
  /// - Hệ thống xếp hạng
  /// - Leaderboard
  /// - So sánh thành tích giữa người chơi
  ///
  /// [exp] là số EXP Rank cần cộng thêm.
  Future<void> addExpRank(int exp);
}
