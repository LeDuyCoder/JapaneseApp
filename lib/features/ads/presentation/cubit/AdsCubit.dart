import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/ads/domain/usecases/should_show_rewarded_ad.dart';

/// Cubit chịu trách nhiệm **điều phối việc hiển thị quảng cáo Rewarded**
/// ở tầng presentation.
///
/// [AdsCubit] đóng vai trò trung gian giữa UI và các UseCase
/// liên quan đến quảng cáo. UI chỉ cần gọi Cubit,
/// không cần biết chi tiết về chính sách quảng cáo
/// hay cách quảng cáo được hiển thị.
///
/// Cubit này không quản lý state phức tạp,
/// mà chỉ cung cấp một API để UI
/// thử hiển thị quảng cáo khi cần thiết.
class AdsCubit extends Cubit<void> {

  /// UseCase kiểm tra điều kiện và hiển thị quảng cáo Rewarded
  final CheckAndShowRewardedAd checkAndShow;

  /// Khởi tạo [AdsCubit] với một [CheckAndShowRewardedAd].
  AdsCubit(this.checkAndShow) : super(null);

  /// Thử hiển thị quảng cáo Rewarded.
  ///
  /// Cubit sẽ gọi UseCase tương ứng để:
  /// - Tăng bộ đếm hành động
  /// - Kiểm tra chính sách quảng cáo
  /// - Hiển thị quảng cáo nếu đủ điều kiện
  ///
  /// Trả về:
  /// - `true` nếu quảng cáo đã được hiển thị
  /// - `false` nếu không hiển thị quảng cáo
  ///
  /// UI có thể dựa vào giá trị trả về
  /// để thực hiện các hành động tiếp theo
  /// (ví dụ: hiển thị reward, chuyển màn hình…).
  Future<bool> tryShowRewarded() {
    return checkAndShow();
  }
}
