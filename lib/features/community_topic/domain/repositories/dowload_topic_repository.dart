import 'package:japaneseapp/features/community_topic/domain/entities/dowload_topic_entity.dart';

/// Repository trừu tượng dùng để xử lý **Download Topic**.
///
/// Chịu trách nhiệm:
/// - Tải dữ liệu chi tiết của topic từ data source
/// - Lưu / download topic về local storage
///
/// Repository này là cầu nối giữa Domain layer và Data layer.
/// Việc implement có thể đến từ:
/// - Remote API
/// - Local database
/// - File system
abstract class DowloadTopicRepository{

  /// Tải dữ liệu của một topic theo [topicId].
  ///
  /// [topicId] là ID định danh duy nhất của topic.
  ///
  /// Trả về:
  /// - `Future<DowloadTopicEntity>` chứa toàn bộ dữ liệu topic
  ///
  /// Có thể throw exception nếu:
  /// - Topic không tồn tại
  /// - Lỗi network
  /// - Lỗi parse dữ liệu
  Future<DowloadTopicEntity> loadData(String topicId);

  /// Thực hiện download và lưu topic về local.
  ///
  /// [dowloadTopicEntity] là entity chứa dữ liệu topic
  /// cần được lưu trữ.
  ///
  /// Trả về:
  /// - `Future<void>` khi quá trình download hoàn tất
  ///
  /// Có thể throw exception nếu:
  /// - Không đủ bộ nhớ
  /// - Lỗi ghi file / database
  /// - Dữ liệu không hợp lệ
  Future<void> dowload(DowloadTopicEntity dowloadTopicEntity);
}