import 'package:japaneseapp/features/local_topic/domain/entities/page_entity.dart';
import 'package:japaneseapp/features/local_topic/domain/entities/topic_entity.dart';

/// Repository trừu tượng cho các thao tác liên quan đến topic.
///
/// Repository này định nghĩa các API mà domain layer sẽ sử dụng,
/// mà không quan tâm đến cách dữ liệu được lưu trữ (local, remote…).
abstract class TopicRepository{

  /// Lấy **toàn bộ danh sách topic** trên thiết bị.
  ///
  /// Trả về danh sách [TopicEntity].
  /// Thường được dùng khi cần hiển thị tất cả topic mà không phân trang.
  Future<List<TopicEntity>> loadAllTopic();

  /// Lấy danh sách topic **theo dạng phân trang**.
  ///
  /// [pageSize] xác định số lượng topic trên mỗi page.
  ///
  /// Trả về danh sách [PageEntity], mỗi page chứa một tập topic.
  Future<List<PageEntity>> loadTopicByPage(int pageSize);
}