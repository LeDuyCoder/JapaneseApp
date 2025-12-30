import 'package:japaneseapp/features/profile/domain/entities/profile_entity.dart';

/// Lớp cha (base class) cho tất cả các trạng thái của ProfileBloc.
///
/// State đại diện cho **trạng thái hiện tại của UI**
/// dựa trên dữ liệu hồ sơ người dùng.
///
/// ## Tầng kiến trúc
/// - Thuộc **tầng presentation**
/// - Được phát (emit) bởi [ProfileBloc]
///
/// ## Nguyên tắc
/// - State là **bất biến** (immutable)
/// - Chỉ chứa dữ liệu cần thiết để render UI
/// - KHÔNG chứa logic nghiệp vụ
abstract class ProfileState {}

/// Trạng thái đang tải dữ liệu hồ sơ.
///
/// UI nên hiển thị:
/// - loading indicator
/// - skeleton / shimmer (nếu có)
class LoadingProfileState extends ProfileState {}

/// Trạng thái tải hồ sơ thành công.
///
/// State này chứa toàn bộ dữ liệu hồ sơ
/// được tổng hợp trong [ProfileEntity].
///
/// UI sử dụng state này để:
/// - hiển thị thông tin người dùng
/// - hiển thị tiến trình, streak, coin, thống kê
class LoadedProfileState extends ProfileState {
  /// Dữ liệu hồ sơ người dùng.
  final ProfileEntity profileEntity;

  /// Tạo một instance mới của [LoadedProfileState].
  ///
  /// [profileEntity] là dữ liệu domain
  /// đã được repository tổng hợp.
  LoadedProfileState({required this.profileEntity});
}

/// Trạng thái xảy ra lỗi khi tải hồ sơ.
///
/// UI có thể:
/// - hiển thị thông báo lỗi
/// - cung cấp nút retry
class ErrorProfileState extends ProfileState {
  /// Thông báo lỗi dùng để hiển thị lên UI.
  final String msg;

  /// Tạo một instance mới của [ErrorProfileState].
  ///
  /// [msg] mô tả nguyên nhân lỗi.
  ErrorProfileState({required this.msg});
}
