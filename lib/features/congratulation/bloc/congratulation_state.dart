import 'package:japaneseapp/features/achivement/domain/service/evaluators/achivement_rule.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/effect_reward.dart';

/// Lớp cơ sở (base class) cho tất cả các state
/// được sử dụng trong [CongratulationBloc].
///
/// Các state đại diện cho từng trạng thái
/// của màn hình Chúc mừng trong suốt vòng đời xử lý.
abstract class CongratulationState {}

/// State khởi tạo ban đầu của [CongratulationBloc].
///
/// Được emit khi BLoC vừa được tạo
/// và chưa thực hiện bất kỳ xử lý nào.
class CongratulationInitial extends CongratulationState{}

/// State loading khi BLoC đang:
/// - Tính toán phần thưởng
/// - Cập nhật tiến trình người dùng
/// - Cập nhật tiến trình từ vựng
///
/// UI có thể hiển thị loading indicator
/// hoặc hiệu ứng chờ trong trạng thái này.
class CongratulationLoading extends CongratulationState{}

/// State loading riêng cho quá trình
/// hiển thị quảng cáo Rewarded.
///
/// Thường được emit khi người dùng
/// chọn xem quảng cáo để nhận thêm thưởng.
class CongratulationLoadingAds extends CongratulationState{}

/// State được emit khi toàn bộ xử lý hoàn tất thành công.
///
/// State này chứa đầy đủ:
/// - Thông tin tiến trình người dùng
/// - Phần thưởng nhận được sau khi hoàn thành
///   bài học / bài kiểm tra
class CongratulationLoaded extends CongratulationState {
  /// Level hiện tại của người dùng
  final int level;

  /// Số exp hiện tại trong level
  final int exp;

  /// Mốc exp cần đạt để lên level tiếp theo
  final int nextExp;

  /// Số coin được cộng thêm
  final int coinPlus;

  /// Số exp rank được cộng thêm
  final int expRankPlus;

  /// Số exp level được cộng thêm
  final int expPlus;

  final List<EffectReward> effectRewards;


  /// Khởi tạo [CongratulationLoaded] với:
  /// - Thông tin tiến trình người dùng
  /// - Phần thưởng nhận được
  CongratulationLoaded(
      this.effectRewards,
      this.coinPlus,
      this.expRankPlus,
      this.expPlus, {
        required this.level,
        required this.exp,
        required this.nextExp,
      });
}
