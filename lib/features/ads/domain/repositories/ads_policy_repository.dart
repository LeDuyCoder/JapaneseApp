/// Repository định nghĩa **chính sách hiển thị quảng cáo** trong ứng dụng.
///
/// Lớp này nằm ở **tầng domain**, chỉ mô tả các hành vi (contract)
/// liên quan đến việc:
/// - Quản lý bộ đếm hành động của người dùng
/// - Quyết định khi nào nên hiển thị quảng cáo Rewarded
///
/// Domain **không quan tâm** dữ liệu được lưu ở đâu
/// (local, remote, SharedPreferences, database…).
/// Chi tiết triển khai sẽ do các lớp ở tầng data đảm nhiệm.
///
/// Repository này thường được sử dụng bởi các UseCase
/// hoặc trực tiếp bởi BLoC/Cubit thông qua dependency injection.
abstract class AdsPolicyRepository {
  /// Tăng bộ đếm hành động của người dùng lên `1`.
  ///
  /// Thường được gọi sau khi người dùng hoàn thành
  /// một hành động hợp lệ có liên quan đến quảng cáo.
  Future<void> increaseCounter();

  /// Kiểm tra xem có nên hiển thị quảng cáo Rewarded hay không.
  ///
  /// Trả về `true` nếu thỏa mãn chính sách quảng cáo hiện tại,
  /// ngược lại trả về `false`.
  ///
  /// Logic cụ thể (ví dụ: mỗi N lần, theo thời gian, theo user)
  /// sẽ được triển khai ở tầng data.
  Future<bool> shouldShowRewardedAd();

  /// Reset bộ đếm hành động của người dùng về `0`.
  ///
  /// Có thể được gọi sau khi:
  /// - Quảng cáo đã được hiển thị thành công
  /// - Reset theo mốc thời gian hoặc yêu cầu nghiệp vụ
  Future<void> resetCounter();
}
