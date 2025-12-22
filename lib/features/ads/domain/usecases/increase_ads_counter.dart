import 'package:japaneseapp/features/ads/domain/repositories/ads_policy_repository.dart';

/// UseCase dùng để **tăng bộ đếm hành động liên quan đến quảng cáo**.
///
/// Lớp này đại diện cho một nghiệp vụ đơn lẻ trong domain:
/// mỗi khi người dùng hoàn thành một hành động hợp lệ
/// (ví dụ: hoàn thành bài học, kết thúc màn chơi, sử dụng tính năng…),
/// bộ đếm quảng cáo sẽ được tăng lên.
///
/// UseCase này đóng vai trò trung gian giữa
/// tầng presentation (BLoC/Cubit) và [AdsPolicyRepository],
/// giúp tách biệt logic nghiệp vụ khỏi UI.
///
/// Không chứa logic hiển thị quảng cáo
/// và không phụ thuộc vào cách dữ liệu được lưu trữ.
class IncreaseAdsCounter {

  /// Repository chịu trách nhiệm xử lý chính sách quảng cáo
  final AdsPolicyRepository policyRepo;

  /// Khởi tạo [IncreaseAdsCounter] với một [AdsPolicyRepository].
  IncreaseAdsCounter(this.policyRepo);

  /// Thực thi use case tăng bộ đếm quảng cáo.
  ///
  /// Thường được gọi từ BLoC/Cubit
  /// sau khi một hành động hợp lệ của người dùng xảy ra.
  Future<void> call() async {
    await policyRepo.increaseCounter();
  }
}