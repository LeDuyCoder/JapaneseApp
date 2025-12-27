import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Service/Server/TopicService.dart';
import 'package:japaneseapp/core/module/topic_module.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';

/// Remote data source dùng để làm việc với **Community Topic** từ server.
///
/// Lớp này chịu trách nhiệm:
/// - Gọi API thông qua [TopicService]
/// - Kết hợp dữ liệu local từ [LocalDbService]
/// - Mapping dữ liệu sang [CommunityTopicEntity]
///
/// Data source này **chỉ xử lý dữ liệu**, không chứa business logic.
/// Thường được sử dụng trong Repository implementation.
class CommunityRemoteDataSource {

  /// Tải danh sách topic cộng đồng từ server.
  ///
  /// [limit] là số lượng topic tối đa cần lấy.
  ///
  /// Quy trình xử lý:
  /// - Gọi API lấy danh sách topic
  /// - Kiểm tra từng topic đã tồn tại trong local database hay chưa
  /// - Mapping dữ liệu sang [CommunityTopicEntity]
  ///
  /// Trả về:
  /// - `Future<List<CommunityTopicEntity>>`
  ///
  /// Có thể throw exception nếu:
  /// - Lỗi network
  /// - Lỗi database local
  /// - Lỗi parse dữ liệu
  Future<List<CommunityTopicEntity>> loadCommunityTopics(int limit) async {
    TopicService topicService = TopicService();
    LocalDbService db = LocalDbService.instance;

    List<CommunityTopicEntity> result = [];
    final List<TopicModule> data = await topicService.getAllDataTopic(limit);
    for (var item in data) {
      bool isExist = await db.topicDao.hasTopicID(item.id);
      result.add(
        CommunityTopicEntity(
            topicId: item.id,
            userId: item.userId??'',
            userName: item.owner??'',
            nameTopic: item.name,
            wordCount: item.count??0,
            isExist: isExist
        )
      );
    }
    return result;
  }

  /// Tìm kiếm topic cộng đồng theo tên.
  ///
  /// [nameTopic] là từ khóa dùng để tìm kiếm.
  ///
  /// Quy trình xử lý:
  /// - Gọi API tìm kiếm topic
  /// - Kiểm tra trạng thái tồn tại trong local database
  /// - Mapping dữ liệu sang [CommunityTopicEntity]
  ///
  /// Trả về:
  /// - `Future<List<CommunityTopicEntity>>` là danh sách topic phù hợp
  ///
  /// Có thể throw exception nếu:
  /// - Lỗi network
  /// - Lỗi database local
  /// - Lỗi query dữ liệu
  Future<List<CommunityTopicEntity>> searchTopic(String nameTopic) async {
    TopicService topicService = TopicService();
    LocalDbService db = LocalDbService.instance;

    List<CommunityTopicEntity> result = [];
    final List<TopicModule> data = await topicService.getTopicsSearch(nameTopic);
    for (var item in data) {
      bool isExist = await db.topicDao.hasTopicID(item.id);
      result.add(
          CommunityTopicEntity(
              topicId: item.id,
              userId: item.userId??'',
              userName: item.owner??'',
              nameTopic: item.name,
              wordCount: item.count??0,
              isExist: isExist
          )
      );
    }

    return result;
  }
}