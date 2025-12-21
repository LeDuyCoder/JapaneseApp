import 'package:japaneseapp/features/congratulation/domain/repositories/user_progress_repository.dart';

/// Use case chịu trách nhiệm cộng Kujicoin cho người dùng.
///
/// Vai trò:
/// - Đóng gói hành vi cập nhật coin
/// - Giữ Domain layer độc lập với tầng data
/// - Cho phép thay đổi cách lưu coin mà không ảnh hưởng Bloc / UI
///
/// Đặc điểm:
/// - Không chứa logic tính toán
/// - Chỉ điều phối hành động ghi dữ liệu
/// - Dễ mock và unit test
///
/// Thường được gọi khi:
/// - Hoàn thành bài học
/// - Nhận thưởng
/// - Thực hiện nhiệm vụ
class AddCoinUsecase{
  final UserProgressRepository repository;

  /// Khởi tạo use case với [UserProgressRepository].
  ///
  /// [repository] chịu trách nhiệm xử lý việc cập nhật coin thực tế
  /// (local hoặc remote tùy implementation).
  AddCoinUsecase({required this.repository});

  /// Cộng thêm Kujicoin cho người dùng.
  ///
  /// [coin] là số Kujicoin cần cộng thêm.
  /// Nếu coin <= 0, implementation có thể bỏ qua.
  Future<void> call(int coin) async{
    repository.addCoin(coin);
  }
}