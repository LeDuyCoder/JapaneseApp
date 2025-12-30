import 'package:japaneseapp/features/profile/domain/entities/profile_entity.dart';

/// Hợp đồng (interface) để lấy dữ liệu hồ sơ người dùng.
///
/// Repository này thuộc **tầng domain** và định nghĩa
/// các hành vi cần thiết để truy xuất hồ sơ người dùng.
///
/// ## Trách nhiệm
/// - Cung cấp dữ liệu hồ sơ dưới dạng **entity thuần domain** ([ProfileEntity])
/// - Ẩn toàn bộ chi tiết triển khai
///   (Firebase, SharedPreferences, Database, API, …)
/// - Đóng vai trò ranh giới giữa **tầng presentation** và **tầng data**
///
/// ## Lưu ý
/// - Các lớp triển khai repository phải nằm trong **tầng data**
///   (ví dụ: `ProfileRepositoryImpl`)
/// - Tầng domain **không được phụ thuộc** vào bất kỳ nguồn dữ liệu cụ thể nào
/// - Repository này thường được sử dụng bởi **BLoC / Cubit** hoặc **UseCase**
///
/// ## Ví dụ
/// ```dart
/// final profile = await profileRepository.getProfile();
/// print(profile.user.displayName);
/// ```
///
/// Tham khảo thêm:
/// - [ProfileEntity] – Aggregate root chứa toàn bộ dữ liệu hồ sơ
/// - ProfileBloc / ProfileCubit – Các lớp thuộc tầng presentation
abstract class ProfileRepository {
  /// Lấy toàn bộ thông tin hồ sơ của người dùng hiện tại.
  ///
  /// Trả về một [ProfileEntity] tổng hợp các dữ liệu:
  /// - thông tin người dùng
  /// - tiến trình học (level, exp)
  /// - thông tin streak / check-in
  /// - ví (coin)
  /// - thống kê
  ///
  /// Ném ra [Exception] nếu không thể tải dữ liệu hồ sơ.
  Future<ProfileEntity> getProfile();
}
