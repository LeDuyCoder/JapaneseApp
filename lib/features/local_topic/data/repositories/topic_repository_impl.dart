import 'package:japaneseapp/features/local_topic/data/datasources/topic_datasource.dart';
import 'package:japaneseapp/features/local_topic/domain/entities/page_entity.dart';
import 'package:japaneseapp/features/local_topic/domain/entities/topic_entity.dart';
import 'package:japaneseapp/features/local_topic/domain/repositories/topic_repository.dart';

/// Implementation của [TopicRepository].
///
/// `TopicRepositoryImpl` đóng vai trò là tầng trung gian
/// giữa **domain layer** và **data layer**.
///
/// Repository này:
/// - Nhận dữ liệu từ [TopicDatasource]
/// - Chuyển dữ liệu thô thành entity domain
/// - Cung cấp API cho Bloc / UseCase sử dụng
class TopicRepositoryImpl implements TopicRepository{
  final TopicDatasource resource;

  TopicRepositoryImpl({required this.resource});

  /// Load **toàn bộ danh sách topic** trên thiết bị.
  ///
  /// Dữ liệu được lấy từ datasource và trả về
  /// dưới dạng danh sách [TopicEntity].
  @override
  Future<List<TopicEntity>> loadAllTopic() {
    return resource.loadAllTopic();
  }

  /// Load danh sách topic **theo dạng phân trang**.
  ///
  /// [pageSize] xác định số lượng topic trên mỗi trang.
  ///
  /// Trả về danh sách các [PageEntity].
  @override
  Future<List<PageEntity>> loadTopicByPage(int pageSize) {
    return resource.loadAllTopicByPage(pageSize);
  }
}