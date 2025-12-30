/// Lớp cha (base class) cho tất cả các sự kiện của ProfileBloc.
///
/// Các event đại diện cho **hành động từ UI**
/// hoặc các trigger từ hệ thống (refresh, reload, logout, …).
///
/// ## Tầng kiến trúc
/// - Thuộc **tầng presentation**
/// - Được sử dụng bởi [ProfileBloc]
///
/// ## Nguyên tắc
/// - Event chỉ mô tả *điều gì xảy ra*, KHÔNG xử lý logic
/// - Mỗi event tương ứng với một hành vi cụ thể từ UI
abstract class ProfileEvent {}

/// Sự kiện yêu cầu tải dữ liệu hồ sơ người dùng.
///
/// Event này thường được dispatch khi:
/// - Màn hình Profile được mở lần đầu
/// - Người dùng thực hiện hành động refresh
///
/// Khi nhận được event này, [ProfileBloc] sẽ:
/// - Gọi [ProfileRepository.getProfile]
/// - Emit các state tương ứng (loading / loaded / error)
class LoadProfileEvent extends ProfileEvent {}
