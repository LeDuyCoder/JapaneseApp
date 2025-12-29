import 'package:japaneseapp/features/congratulation/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/congratulation/domain/enum/type_congratulation.dart';
import 'package:japaneseapp/features/learn/domain/enum/type_test.dart';

/// Lớp cơ sở (base class) cho tất cả các event
/// được sử dụng trong [CongratulationBloc].
///
/// Các event đại diện cho những hành động
/// mà UI hoặc hệ thống có thể kích hoạt
/// trong màn hình Chúc mừng.
abstract class CongratulationEvent {}

/// Event được phát khi màn hình Chúc mừng được khởi tạo.
///
/// Event này dùng để:
/// - Bắt đầu load dữ liệu
/// - Tính toán phần thưởng
/// - Cập nhật tiến trình người dùng
/// - Cập nhật tiến trình từ vựng
class CongratulationStarted extends CongratulationEvent {

  /// Số câu trả lời đúng
  final int correctAnswers;

  /// Số câu trả lời sai
  final int incorrectAnsers;

  /// Danh sách từ vựng đã tham gia trong bài học / bài kiểm tra
  /// dùng để cập nhật tiến trình học từ vựng
  final List<WordEntity> words;

  /// Loại congratylation để hiện
  /// [TypeCongratulation] - vocabylary, character
  final TypeCongratulation type;

  ///than số khi truyền type congratulation là character
  ///mục đích:
  /// - tính toán và tăng tiếng trình trong database, sharedfile
  TypeTest typeTest;

  /// Khởi tạo [CongratulationStarted] với kết quả làm bài
  /// và danh sách từ vựng liên quan.
  CongratulationStarted(this.correctAnswers, this.incorrectAnsers, this.words, this.type, {this.typeTest = TypeTest.hiragana});
}

/// Event được phát khi người dùng chọn xem quảng cáo Rewarded
/// để nhận thêm phần thưởng.
///
/// Event này mang theo thông tin phần thưởng hiện tại
/// để BLoC có thể tính toán và emit lại state tương ứng
/// sau khi quảng cáo được xem thành công.
class ShowAdsRewardEvent extends CongratulationEvent {

  /// Số exp rank cộng thêm
  final int expRankPlus;

  /// Số exp level cộng thêm
  final int expPlus;

  /// Số coin nhận được
  final int coin;

  /// Khởi tạo [ShowAdsRewardEvent] với
  /// thông tin phần thưởng hiện tại.
  ShowAdsRewardEvent(this.coin, this.expRankPlus, this.expPlus);
}