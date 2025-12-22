import 'package:japaneseapp/core/service/check_in/check_in_status.dart';
import 'package:japaneseapp/core/service/check_in/check_in_use_case.dart';

/// Use case của feature Check-in trong app.
///
/// Lớp này gói `CheckInUseCase` từ core lại để sử dụng trực tiếp trong feature.
/// Feature chỉ cần gọi `execute()` mà không cần biết chi tiết core implementation.
class CheckInFeatureUseCase {
  /// Use case check-in từ core
  final CheckInUseCase coreUseCase;

  /// Khởi tạo CheckInFeatureUseCase với [coreUseCase]
  CheckInFeatureUseCase(this.coreUseCase);

  /// Thực hiện check-in cho ngày hiện tại và trả về [CheckInStatus]
  ///
  /// Các trạng thái có thể:
  /// - [CheckInStatus.continued]: tiếp tục streak bình thường
  /// - [CheckInStatus.reset]: streak bị reset
  /// - [CheckInStatus.needRewardAd]: cần xem quảng cáo để cứu streak
  ///
  /// Ví dụ sử dụng:
  /// ```dart
  /// final featureUseCase = CheckInFeatureUseCase(coreUseCase);
  /// final status = await featureUseCase.execute();
  /// if (status == CheckInStatus.needRewardAd) {
  ///   // Trigger reward ad
  /// }
  /// ```
  Future<CheckInStatus> execute() async {
    final now = DateTime.now();
    return await coreUseCase.execute(now);
  }
}
