import 'package:japaneseapp/features/ads/domain/repositories/ads_policy_repository.dart';
import 'package:japaneseapp/features/ads/services/interstitial_ad_service_impl.dart';

/// UseCase dùng để **kiểm tra và hiển thị quảng cáo Rewarded**
/// dựa trên chính sách quảng cáo hiện tại.
///
/// Luồng xử lý của use case này:
/// 1. Tăng bộ đếm hành động của người dùng
/// 2. Kiểm tra xem đã thỏa điều kiện hiển thị quảng cáo hay chưa
/// 3. Nếu thỏa điều kiện:
///    - Hiển thị quảng cáo Rewarded
///    - Reset bộ đếm quảng cáo
///    - Trả về `true`
/// 4. Nếu không thỏa:
///    - Không hiển thị quảng cáo
///    - Trả về `false`
///
/// UseCase này thường được gọi từ tầng presentation
/// (BLoC/Cubit) sau một hành động quan trọng của người dùng,
/// ví dụ: hoàn thành bài học, kết thúc level, sử dụng tính năng.
///
/// Lưu ý:
/// - UseCase **không quyết định** khi nào được phép hiển thị quảng cáo,
///   mà chỉ thực thi chính sách thông qua [AdsPolicyRepository].
/// - Việc hiển thị quảng cáo hiện tại được thực hiện
///   thông qua `InterstitialAdServiceImpl`.
class CheckAndShowRewardedAd {

  /// Repository chịu trách nhiệm quản lý
  /// chính sách hiển thị quảng cáo
  final AdsPolicyRepository policyRepo;

  /// Khởi tạo [CheckAndShowRewardedAd]
  /// với một [AdsPolicyRepository].
  CheckAndShowRewardedAd(this.policyRepo,);

  /// Thực thi use case kiểm tra và hiển thị quảng cáo Rewarded.
  ///
  /// Trả về:
  /// - `true` nếu quảng cáo đã được hiển thị
  /// - `false` nếu không hiển thị quảng cáo
  Future<bool> call() async {
    await policyRepo.increaseCounter();

    if (await policyRepo.shouldShowRewardedAd()) {
      await InterstitialAdServiceImpl().show();
      await policyRepo.resetCounter();
      return true;
    }
    return false;
  }
}
