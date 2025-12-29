import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/features/local_topic/domain/entities/page_entity.dart';
import 'package:japaneseapp/features/local_topic/domain/entities/topic_entity.dart';

/// `TopicDatasource` chịu trách nhiệm truy xuất dữ liệu
/// **topic local từ database**.
///
/// Datasource này làm việc trực tiếp với [LocalDbService]
/// để lấy:
/// - Danh sách topic
/// - Số lượng từ trong mỗi topic
/// - Phần trăm tiến độ học (percent)
///
/// Kết quả được map sang các entity:
/// - [TopicEntity]
/// - [PageEntity]
class TopicDatasource{
  final LocalDbService db;

  TopicDatasource({required this.db});


  /// Load **toàn bộ danh sách topic** từ database.
  ///
  /// Với mỗi topic:
  /// - Lấy danh sách word theo topic
  /// - Tính:
  ///   - `amount`: số lượng từ
  ///   - `percent`: phần trăm hoàn thành (làm tròn 2 chữ số)
  ///
  /// Trả về danh sách [TopicEntity].
  Future<List<TopicEntity>> loadAllTopic() async {
    final datas = await db.topicDao.getAllTopics();

    return Future.wait(
      datas.map((topic) async {
        final words = await db.topicDao.getAllWordsByTopic(topic["id"]);
        var sumPercentWords = 0.0;
        for(Map<String, dynamic> word in words){
          sumPercentWords += word["level"] / 28;
        }


        var data = {
          ...topic,
          "amount": words.length,
          "percent": double.parse(((sumPercentWords / words.length) * 100).toStringAsFixed(2))
        };

        print("check: $data");
        return TopicEntity.fromJson(data);
      }),
    );
  }

  /// Load danh sách topic **theo dạng phân trang**.
  ///
  /// [size] xác định số lượng topic trên mỗi page.
  ///
  /// Quy trình:
  /// - Load toàn bộ topic
  /// - Tính `amount` và `percent` cho từng topic
  /// - Chia danh sách thành các page
  ///
  /// Trả về danh sách [PageEntity].
  Future<List<PageEntity>> loadAllTopicByPage(int size) async {
    final datas = await db.topicDao.getAllTopics();

    final topics = await Future.wait(
      datas.map((e) async {
        final words = await db.topicDao.getAllWordsByTopic(e['id']);
        var sumPercentWords = 0.0;
        for(Map<String, dynamic> word in words){
          sumPercentWords += word["level"] / 28;
        }

        return TopicEntity.fromJson({
          ...e,
          'amount': words.length,
          "percent": double.parse(((sumPercentWords / words.length) * 100).toStringAsFixed(2))
        });
      }),
    );


    final List<PageEntity> result = [];

    for (int page = 0; page < (topics.length / size).ceil(); page++) {
      final start = page * size;
      final end = (start + size > topics.length)
          ? topics.length
          : start + size;

      result.add(
        PageEntity(
          page: page,
          topicEntities: topics.sublist(start, end),
        ),
      );
    }

    return result;
  }
}