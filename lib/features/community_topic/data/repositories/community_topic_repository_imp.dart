import 'package:japaneseapp/features/community_topic/data/datasources/community_remote_datasource.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';
import 'package:japaneseapp/features/community_topic/domain/repositories/community_topic_repository.dart';

/// Implementation của [CommunityTopicRepository].
///
/// Lớp này đóng vai trò:
/// - Điều phối dữ liệu từ data source
/// - Che giấu chi tiết implementation khỏi Domain layer
///
/// Hiện tại repository này sử dụng:
/// - [CommunityRemoteDataSource] để lấy dữ liệu từ server
///
/// Trong tương lai có thể mở rộng:
/// - Kết hợp thêm LocalDataSource
/// - Cache dữ liệu
/// - Xử lý error (Failure / Either)
class CommunityTopicRepositoryImp implements CommunityTopicRepository{
  final CommunityRemoteDataSource remoteDataSource;

  /// Khởi tạo repository với [remoteDataSource].
  ///
  /// [remoteDataSource] là data source chịu trách nhiệm
  /// lấy dữ liệu topic từ server.
  CommunityTopicRepositoryImp({required this.remoteDataSource});

  /// Tải danh sách topic cộng đồng.
  ///
  /// Chuyển tiếp yêu cầu xuống [CommunityRemoteDataSource].
  ///
  /// [limit] là số lượng topic tối đa cần lấy.
  ///
  /// Trả về:
  /// - `Future<List<CommunityTopicEntity>>`
  @override
  Future<List<CommunityTopicEntity>> loadCommunityTopics(int limit) {
    return remoteDataSource.loadCommunityTopics(limit);
  }

  /// Tìm kiếm topic cộng đồng theo tên.
  ///
  /// Chuyển tiếp yêu cầu xuống [CommunityRemoteDataSource].
  ///
  /// [nameTopic] là từ khóa tìm kiếm.
  ///
  /// Trả về:
  /// - `Future<List<CommunityTopicEntity>>`
  @override
  Future<List<CommunityTopicEntity>> searchTopics(String nameTopic) {
    return remoteDataSource.searchTopic(nameTopic);
  }
}