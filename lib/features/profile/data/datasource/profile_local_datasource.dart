import 'package:japaneseapp/core/service/Local/local_db_service.dart';
import 'package:japaneseapp/features/profile/domain/entities/progress_entity.dart';
import 'package:japaneseapp/features/profile/domain/entities/statistic_entity.dart';
import 'package:japaneseapp/features/profile/domain/entities/streak_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Nguồn dữ liệu cục bộ cho tính năng hồ sơ người dùng.
///
/// DataSource này chịu trách nhiệm lấy các dữ liệu hồ sơ
/// được lưu trữ **trên thiết bị**, bao gồm:
/// - tiến trình học tập (level, exp)
/// - thông tin streak / check-in
/// - các thống kê cục bộ
///
/// ## Tầng kiến trúc
/// - Thuộc **tầng data**
/// - KHÔNG được truy cập trực tiếp từ UI hoặc BLoC
/// - Chỉ được sử dụng nội bộ bởi các lớp repository
///
/// ## Nguồn dữ liệu sử dụng
/// - [SharedPreferences] cho dữ liệu nhỏ, lưu trữ đơn giản
/// - [LocalDbService] để truy cập cơ sở dữ liệu cục bộ
///
/// ## Ghi chú
/// - Interface này định nghĩa **CÓ THỂ lấy dữ liệu gì**
/// - Lớp triển khai cụ thể sẽ quyết định **lấy dữ liệu NHƯ THẾ NÀO**
abstract class ProfileLocalDataSource {
  /// Lấy dữ liệu tiến trình học tập của người dùng từ bộ nhớ cục bộ.
  ///
  /// Trả về một [ProgressEntity] bao gồm:
  /// - level hiện tại
  /// - số exp hiện có
  /// - exp cần thiết cho level tiếp theo
  Future<ProgressEntity> getProgress();

  /// Lấy thông tin streak và lịch sử check-in của người dùng.
  ///
  /// Trả về một [StreakEntity] bao gồm:
  /// - lịch sử check-in
  /// - lịch sử streak
  /// - ngày check-in gần nhất
  /// - số streak hiện tại
  Future<StreakEntity> getStreak();

  /// Lấy dữ liệu thống kê cục bộ liên quan đến người dùng.
  ///
  /// Trả về một [StatisticEntity] bao gồm:
  /// - số lượng topic được lưu trong database cục bộ
  Future<StatisticEntity> getStatistic();
}

/// Triển khai mặc định của [ProfileLocalDataSource].
///
/// Lớp này lấy dữ liệu từ:
/// - [SharedPreferences] cho tiến trình và streak
/// - [LocalDbService] cho các thống kê trong database
///
/// ## Trách nhiệm
/// - Chuyển đổi dữ liệu thô từ local storage sang **domain entity**
/// - Xử lý giá trị mặc định khi dữ liệu chưa tồn tại
///
/// ## Quan trọng
/// - Lớp này **phụ thuộc framework**
///   (SharedPreferences, SQLite, …)
/// - KHÔNG được chứa business logic
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  /// Khởi tạo một instance mới của [ProfileLocalDataSourceImpl].
  ///
  /// Các dependency hiện được resolve trực tiếp bên trong.
  /// Có thể refactor để inject dependency nhằm
  /// hỗ trợ test dễ dàng hơn.
  ProfileLocalDataSourceImpl();

  @override
  Future<ProgressEntity> getProgress() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return ProgressEntity(
      level: prefs.getInt("level") ?? 1,
      exp: prefs.getInt("exp") ?? 0,
      nextExp: prefs.getInt("nextExp") ?? 100,
    );
  }

  @override
  Future<StreakEntity> getStreak() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return StreakEntity(
      prefs.getStringList("checkInHistory") ?? [],
      prefs.getStringList("checkInHistoryTreak") ?? [],
      prefs.getString("lastCheckIn") ?? "",
      prefs.getInt("Streak") ?? 0,
    );
  }

  @override
  Future<StatisticEntity> getStatistic() async {
    final LocalDbService db = LocalDbService.instance;

    return StatisticEntity(
      (await db.topicDao.getAllTopics()).length,
    );
  }
}
