import 'package:japaneseapp/features/community_topic/data/datasources/dowload_topic_remote_datasource.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/dowload_topic_entity.dart';
import 'package:japaneseapp/features/community_topic/domain/repositories/dowload_topic_repository.dart';

/// Implementation của [DowloadTopicRepository].
///
/// Lớp này đóng vai trò:
/// - Điều phối dữ liệu giữa Domain layer và Data source
/// - Che giấu chi tiết việc lấy và lưu dữ liệu topic
///
/// Hiện tại repository này sử dụng:
/// - [DowloadTopicRemoteDataSource] để tải và lưu dữ liệu topic
///
/// Trong tương lai có thể mở rộng:
/// - Tách Remote / Local data source
/// - Thêm xử lý cache
/// - Bổ sung xử lý lỗi (Failure / Either)
class DowloadTopicRepositoryImpl implements DowloadTopicRepository{
  final DowloadTopicRemoteDataSource dataSource;

  /// Khởi tạo repository với [dataSource].
  ///
  /// [dataSource] là data source chịu trách nhiệm
  /// tải dữ liệu topic và lưu về local database.
  DowloadTopicRepositoryImpl({required this.dataSource});

  /// Thực hiện download và lưu topic về local.
  ///
  /// Chuyển tiếp yêu cầu xuống [DowloadTopicRemoteDataSource].
  ///
  /// [dowloadTopicEntity] là entity chứa dữ liệu topic
  /// cần được lưu trữ.
  ///
  /// Trả về:
  /// - `Future<void>` khi quá trình download hoàn tất
  @override
  Future<void> dowload(DowloadTopicEntity dowloadTopicEntity) {
    return dataSource.dowload(dowloadTopicEntity);
  }

  /// Tải dữ liệu đầy đủ của topic theo [topicId].
  ///
  /// Chuyển tiếp yêu cầu xuống [DowloadTopicRemoteDataSource].
  ///
  /// Trả về:
  /// - `Future<DowloadTopicEntity>`
  @override
  Future<DowloadTopicEntity> loadData(String topicId) {
    return dataSource.loadDowloadTopicEntity(topicId);
  }

}