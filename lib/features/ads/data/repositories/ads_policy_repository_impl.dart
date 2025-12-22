import 'package:japaneseapp/features/ads/data/datasources/ads_counter_local_ds.dart';
import 'package:japaneseapp/features/ads/domain/repositories/ads_policy_repository.dart';

/// Triển khai (implementation) của [AdsPolicyRepository].
///
/// Repository này chịu trách nhiệm xử lý **chính sách hiển thị quảng cáo**
/// dựa trên số lần người dùng thực hiện một hành động nào đó
/// (ví dụ: hoàn thành bài học, xem màn hình, sử dụng tính năng…).
///
/// Dữ liệu bộ đếm được lưu trữ thông qua [AdsCounterLocalDataSource],
/// giúp đảm bảo trạng thái được persist trên thiết bị.
///
/// Quy ước hiện tại:
/// - Quảng cáo Rewarded sẽ được hiển thị mỗi **3 lần**
/// - Bộ đếm được tăng sau mỗi lần hành động hợp lệ
class AdsPolicyRepositoryImpl implements AdsPolicyRepository {

  /// Data source cục bộ dùng để lưu và đọc bộ đếm quảng cáo
  final AdsCounterLocalDataSource local;

  /// Khởi tạo [AdsPolicyRepositoryImpl] với
  /// một [AdsCounterLocalDataSource].
  AdsPolicyRepositoryImpl(this.local);

  /// Tăng bộ đếm quảng cáo lên `1`.
  ///
  /// Thường được gọi sau khi người dùng hoàn thành
  /// một hành động có thể dẫn đến việc hiển thị quảng cáo.
  @override
  Future<void> increaseCounter() => local.increase();

  /// Kiểm tra xem có nên hiển thị quảng cáo Rewarded hay không.
  ///
  /// Trả về `true` nếu:
  /// - Số lần đếm hiện tại chia hết cho `3`
  ///
  /// Trả về `false` trong các trường hợp còn lại.
  ///
  /// Logic này đại diện cho **chính sách quảng cáo**
  /// và có thể thay đổi mà không ảnh hưởng đến UI hay BLoC.
  @override
  Future<bool> shouldShowRewardedAd() async {
    final count = local.getCounter();
    return count % 3 == 0;
  }

  /// Reset bộ đếm quảng cáo về `0`.
  ///
  /// Có thể được gọi sau khi:
  /// - Người dùng đã xem quảng cáo thành công
  /// - Reset theo mốc thời gian hoặc logic nghiệp vụ khác
  @override
  Future<void> resetCounter() => local.reset();
}
