import 'package:japaneseapp/features/profile/data/datasource/profile_local_datasource.dart';
import 'package:japaneseapp/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:japaneseapp/features/profile/domain/entities/profile_entity.dart';
import 'package:japaneseapp/features/profile/domain/repository/profile_repository.dart';

/// Triển khai mặc định của [ProfileRepository].
///
/// Repository này đóng vai trò là **nguồn dữ liệu duy nhất (Single Source of Truth)**
/// cho toàn bộ dữ liệu liên quan đến hồ sơ người dùng, bằng cách
/// điều phối nhiều nguồn dữ liệu khác nhau.
///
/// ## Tầng kiến trúc
/// - Thuộc **tầng data**
/// - Triển khai contract ở tầng domain ([ProfileRepository])
///
/// ## Trách nhiệm
/// - Điều phối việc lấy dữ liệu từ:
///   - [ProfileRemoteDataSource] (thông tin người dùng, ví/coin)
///   - [ProfileLocalDataSource] (tiến trình, streak, thống kê)
/// - Tổng hợp dữ liệu thành một đối tượng duy nhất [ProfileEntity]
/// - Ẩn toàn bộ độ phức tạp của các nguồn dữ liệu khỏi
///   tầng domain và presentation
///
/// ## Luồng dữ liệu
/// ```text
/// UI / Bloc
///     ↓
/// ProfileRepository (interface - domain)
///     ↓
/// ProfileRepositoryImpl (data)
///     ├── ProfileRemoteDataSource
///     └── ProfileLocalDataSource
/// ```
///
/// ## Ghi chú
/// - KHÔNG được đặt business logic tại đây
/// - Có thể bổ sung chiến lược xử lý lỗi
///   (try/catch, Either, Result, …) tại tầng này nếu cần
class ProfileRepositoryImpl implements ProfileRepository {
  /// Nguồn dữ liệu cục bộ cho hồ sơ người dùng
  /// (cache, dữ liệu offline).
  final ProfileLocalDataSource local;

  /// Nguồn dữ liệu từ xa cho hồ sơ người dùng
  /// (xác thực, dữ liệu server).
  final ProfileRemoteDataSource remote;

  /// Khởi tạo một instance mới của [ProfileRepositoryImpl].
  ///
  /// Các data source được inject vào để:
  /// - dễ dàng mock khi viết test
  /// - đảm bảo separation of concerns
  ProfileRepositoryImpl(this.local, this.remote);

  @override
  Future<ProfileEntity> getProfile() async {
    // Lấy thông tin người dùng đã xác thực từ remote
    final user = await remote.getUser();

    // Tổng hợp dữ liệu hồ sơ từ nhiều nguồn
    return ProfileEntity(
      user: user,
      progress: await local.getProgress(),
      streak: await local.getStreak(),
      wallet: await remote.getWallet(user.uid),
      statistic: await local.getStatistic(),
    );
  }
}
