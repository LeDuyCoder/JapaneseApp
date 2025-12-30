import 'package:firebase_auth/firebase_auth.dart';
import 'package:japaneseapp/core/service/Server/ServiceLocator.dart';
import 'package:japaneseapp/features/profile/domain/entities/user_entity.dart';
import 'package:japaneseapp/features/profile/domain/entities/wallet_entity.dart';

/// Nguồn dữ liệu từ xa cho tính năng hồ sơ người dùng.
///
/// DataSource này chịu trách nhiệm lấy dữ liệu hồ sơ
/// từ các **dịch vụ bên ngoài**, bao gồm:
/// - Firebase Authentication
/// - Backend / API service
///
/// ## Tầng kiến trúc
/// - Thuộc **tầng data**
/// - Chỉ được sử dụng nội bộ bởi các repository
/// - KHÔNG được truy cập trực tiếp từ UI hoặc tầng presentation
///
/// ## Trách nhiệm
/// - Lấy thông tin định danh người dùng từ remote
/// - Lấy thông tin ví / coin từ backend
/// - Chuyển đổi dữ liệu phụ thuộc framework sang **domain entity**
///
/// ## Ghi chú
/// - DataSource này phụ thuộc vào framework bên ngoài
///   (Firebase, API, …)
/// - KHÔNG được chứa business logic
abstract class ProfileRemoteDataSource {
  /// Lấy thông tin người dùng đang đăng nhập hiện tại.
  ///
  /// Trả về một [UserEntity] bao gồm:
  /// - uid người dùng
  /// - tên hiển thị
  /// - email
  ///
  /// Ném ra [Exception] nếu chưa có người dùng đăng nhập.
  Future<UserEntity> getUser();

  /// Lấy thông tin ví (coin) của người dùng từ dịch vụ backend.
  ///
  /// [uid] là định danh duy nhất của người dùng.
  ///
  /// Trả về một [WalletEntity] bao gồm:
  /// - số coin hiện tại
  Future<WalletEntity> getWallet(String uid);
}

/// Triển khai mặc định của [ProfileRemoteDataSource].
///
/// Lớp này lấy dữ liệu từ:
/// - [FirebaseAuth] cho thông tin xác thực người dùng
/// - Backend thông qua [ServiceLocator]
///
/// ## Trách nhiệm
/// - Ánh xạ dữ liệu remote sang **domain entity**
/// - Làm việc trực tiếp với API / SDK của framework
///
/// ## Quan trọng
/// - Lớp này phụ thuộc framework
/// - Chỉ thuộc **tầng data**, không được lan sang domain
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {

  @override
  Future<UserEntity> getUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final u = auth.currentUser!;

    return UserEntity(
      uid: u.uid,
      displayName: u.displayName,
      email: u.email,
    );
  }

  @override
  Future<WalletEntity> getWallet(String uid) async {
    final coin = await ServiceLocator.userService.getCoin(uid);
    return WalletEntity(coin);
  }
}
