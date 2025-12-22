import 'package:japaneseapp/features/congratulation/domain/repositories/user_progress_repository.dart';

/// Use case chịu trách nhiệm cộng EXP Rank cho người dùng.
///
/// Vai trò:
/// - Đóng gói hành vi cập nhật EXP Rank
/// - Tách Domain layer khỏi Repository implementation
///
/// Đặc điểm:
/// - Không chứa logic tính toán
/// - Chỉ điều phối hành động ghi dữ liệu
/// - Dễ mock / test
///
/// Thường được gọi khi:
/// - Hoàn thành bài học
/// - Nhận thưởng
/// - Cập nhật bảng xếp hạng
class AddExpRankUsecase{
  final UserProgressRepository repository;

  /// Khởi tạo use case với [UserProgressRepository].
  ///
  /// [repository] chịu trách nhiệm thực hiện cập nhật dữ liệu thực tế
  /// (local hoặc remote tùy implementation).
  AddExpRankUsecase({required this.repository});

  /// Cộng thêm EXP Rank cho người dùng.
  ///
  /// [exp] là số EXP Rank cần cộng thêm.
  Future<void> call(int exp) async {
    return repository.addExpRank(exp);
  }
}