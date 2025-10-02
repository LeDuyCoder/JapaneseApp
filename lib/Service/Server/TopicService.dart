import '../../Module/topic.dart';
import '../BaseService.dart';

class TopicService extends BaseService {

  /// Get all topics with limit
  Future<List<topic>> getAllDataTopic(int limit) async {
    final data = await get('/controller/topic/getAllDataTopic.php',
        queryParams: {'limit': limit.toString()});

    if (data is List) {
      return data.map((jsonItem) => topic.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Dữ liệu trả về không hợp lệ');
    }
  }

  /// Search topics by keyword
  Future<List<topic>> getTopicsSearch(String keyword) async {
    final data = await get('/controller/topic/searchTopic.php',
        queryParams: {'nameTopic': keyword});

    if (data is List) {
      return data.map((jsonItem) => topic.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Dữ liệu trả về không hợp lệ');
    }
  }

  /// Get topic by ID
  Future<topic?> getDataTopicByID(String id) async {
    try {
      final data = await get('/controller/topic/getDataTopicByTopicID.php',
          queryParams: {'topic_id': id});

      if (data != null) {
        return topic.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Lỗi khi kết nối đến server: $e');
      return null;
    }
  }

  /// Insert new topic
  Future<bool> insertTopic(topic topicInsert) async {
    try {
      final response = await postForm('/controller/topic/insertDataTopic.php',
          topicInsert.toJson());
      print('✅ Insert topic success');
      return true;
    } catch (e) {
      print('⚠️ Error while inserting topic: $e');
      return false;
    }
  }

  /// Delete topic by ID
  Future<void> deleteTopic(String topicID) async {
    final data = await postJson('/controller/topic/deleteTopic.php', {
      'topicID': topicID,
    });
    print("✅ Delete success: ${data['message']}");
  }
}