import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';

/// Repository trừu tượng dùng để làm việc với **Community Topic**.
///
/// Đóng vai trò là tầng trung gian giữa Domain và Data layer.
/// Lớp này định nghĩa các hành vi liên quan đến việc
/// tải và tìm kiếm các topic cộng đồng.
///
/// Việc implement có thể đến từ:
/// - API (REST / GraphQL)
/// - Local database (SQLite, Hive, v.v.)
/// - Firebase hoặc các nguồn dữ liệu khác
abstract class CommunityTopicRepository {

  /// Tải danh sách các topic cộng đồng.
  ///
  /// [limit] là số lượng topic tối đa cần lấy.
  ///
  /// Trả về:
  /// - `Future<List<CommunityTopicEntity>>` chứa danh sách topic
  ///
  /// Có thể throw exception nếu:
  /// - Lỗi network
  /// - Lỗi parse dữ liệu
  /// - Lỗi từ data source
  Future<List<CommunityTopicEntity>> loadCommunityTopics(int limit);

  /// Tìm kiếm topic cộng đồng theo tên.
  ///
  /// [nameTopic] là từ khóa dùng để tìm kiếm (có thể là tên đầy đủ
  /// hoặc một phần của tên topic).
  ///
  /// Trả về:
  /// - `Future<List<CommunityTopicEntity>>` là danh sách topic phù hợp
  ///
  /// Có thể throw exception nếu:
  /// - Lỗi network
  /// - Lỗi query dữ liệu
  Future<List<CommunityTopicEntity>> searchTopics(String nameTopic);
}