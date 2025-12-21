import 'package:japaneseapp/features/congratulation/data/datasource/user_progress_local_datasource.dart';
import 'package:japaneseapp/features/congratulation/data/datasource/user_remote_datasource.dart';
import 'package:japaneseapp/features/congratulation/domain/entities/user_progress.dart';
import 'package:japaneseapp/features/congratulation/domain/repositories/user_progress_repository.dart';

/// Implementation của [UserProgressRepository].
///
/// Chịu trách nhiệm:
/// - Cung cấp dữ liệu tiến trình người dùng (UserProgress)
/// - Quyết định nguồn dữ liệu:
///   - Local: đọc / ghi tiến trình học
///   - Remote: cập nhật coin và EXP rank lên server
///
/// Nguyên tắc:
/// - **Read / Write progress** → Local Data Source
/// - **Reward (coin, exp rank)** → Remote Data Source
///
/// Class này đóng vai trò trung gian giữa:
/// - Domain layer (Bloc / UseCase)
/// - Data layer (Local & Remote DataSource)
class UserProgressRepositoryImpl implements UserProgressRepository {
  final UserProgressLocalDataSource local;
  final UserRemoteDatasource remote;

  /// Khởi tạo repository với local và remote data source.
  ///
  /// [local] dùng để lưu và lấy tiến trình học trên thiết bị
  /// [remote] dùng để đồng bộ coin và EXP rank lên server
  UserProgressRepositoryImpl(this.local, this.remote);

  /// Lấy tiến trình học hiện tại của người dùng từ local storage.
  ///
  /// Không gọi API.
  @override
  Future<UserProgress> getProgress() => local.getProgress();

  /// Lưu lại tiến trình học của người dùng vào local storage.
  ///
  /// Thường được gọi sau khi:
  /// - Cộng EXP
  /// - Lên level
  /// - Hoàn thành bài học
  @override
  Future<void> saveProgress(UserProgress progress) => local.saveProgress(progress);

  /// Cộng thêm Kujicoin cho người dùng trên server.
  ///
  /// Chỉ cập nhật remote, không lưu local.
  @override
  Future<void> addCoin(int coin) => remote.addCoin(coin);

  /// Cộng EXP Rank cho người dùng trên server.
  ///
  /// Dùng cho hệ thống xếp hạng / leaderboard.
  /// Không ảnh hưởng đến EXP level local.
  @override
  Future<void> addExpRank(int exp) => remote.addExpRank(exp);
}