import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/dowload_topic_entity.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/word_entity.dart';

/// Remote data source dùng để xử lý **Download Topic**.
///
/// Lớp này chịu trách nhiệm:
/// - Gọi API lấy dữ liệu topic và danh sách từ vựng
/// - Mapping dữ liệu sang các entity domain
/// - Lưu topic và word vào local database
///
/// Data source này thường được sử dụng trong
/// `DownloadTopicRepository` implementation.
class DowloadTopicRemoteDataSource{

  /// Tải dữ liệu đầy đủ của một topic để phục vụ download.
  ///
  /// [topicId] là ID định danh duy nhất của topic.
  ///
  /// Quy trình xử lý:
  /// - Gọi API lấy danh sách word theo topic
  /// - Gọi API lấy thông tin topic
  /// - Mapping dữ liệu sang:
  ///   - [CommunityTopicEntity]
  ///   - [WordEntity]
  /// - Kiểm tra topic đã tồn tại trong local database hay chưa
  ///
  /// Trả về:
  /// - `Future<DowloadTopicEntity>` chứa toàn bộ dữ liệu topic
  ///
  /// Có thể throw exception nếu:
  /// - Topic không tồn tại
  /// - Lỗi network
  /// - Lỗi database local
  /// - Lỗi parse dữ liệu
  Future<DowloadTopicEntity> loadDowloadTopicEntity(String topicId) async {
    LocalDbService db = LocalDbService.instance;

    var dataTopic = await ServiceLocator.wordService.fetchWordsByTopicID(topicId);
    var topic = await ServiceLocator.topicService.getDataTopicByID(topicId);

    List<WordEntity> wordEntities = [];
    for(var word in dataTopic){
      wordEntities.add(
          WordEntity(
              word: word.word,
              mean: word.mean,
              wayread: word.wayread
          )
      );
    }

    CommunityTopicEntity communityTopicEntity = CommunityTopicEntity(
        topicId: topic!.id,
        userId: topic.userId??'',
        userName: topic.owner??'',
        nameTopic: topic.name,
        wordCount: wordEntities.length,
        isExist: await db.topicDao.hasTopicID(topicId)
    );

    return DowloadTopicEntity(
        communityTopicEntity: communityTopicEntity,
        wordEntities: wordEntities
    );
  }

  /// Thực hiện download và lưu topic về local database.
  ///
  /// [topic] là entity chứa toàn bộ dữ liệu topic
  /// và danh sách từ vựng cần được lưu.
  ///
  /// Quy trình xử lý:
  /// - Lưu thông tin topic vào bảng topic
  /// - Mapping danh sách word sang dạng Map
  /// - Insert dữ liệu word vào local database
  ///
  /// Trả về:
  /// - `Future<void>` khi quá trình lưu hoàn tất
  ///
  /// Có thể throw exception nếu:
  /// - Không đủ bộ nhớ
  /// - Lỗi ghi database
  /// - Dữ liệu không hợp lệ
  Future<void> dowload(DowloadTopicEntity topic) async{
    LocalDbService db = LocalDbService.instance;
    db.topicDao.insertTopicID(
        topic.communityTopicEntity.topicId,
        topic.communityTopicEntity.nameTopic,
        topic.communityTopicEntity.userName
    );

    List<Map<String, dynamic>> dataInsert = [];
    for(WordEntity wordEntity in topic.wordEntities){
      dataInsert.add(
        {
          "word": wordEntity.word,
          "mean": wordEntity.mean,
          "wayread": wordEntity.wayread,
          "topic": topic.communityTopicEntity.topicId,
          "level": 0
        }
      );
    }

    db.topicDao.insertDataTopic(dataInsert);
  }
}