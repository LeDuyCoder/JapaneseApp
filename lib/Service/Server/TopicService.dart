import '../../Module/topic.dart';
import '../BaseService.dart';

class TopicService extends BaseService {

  /// Get all topics with limit
  Future<List<topic>> getAllDataTopic(int limit) async {
    final data = await get(
      '/controller/topic/getAllDataTopic.php',
      queryParams: {'limit': limit.toString()},
    );


    if (data["topics"] is List) {
      final List<topic> topics = (data["topics"] as List)
          .map((jsonItem) => topic.fromJson(jsonItem as Map<String, dynamic>))
          .toList();

      print(topics);
      return topics; // ✅ Trả về List<topic>
    } else {
      throw Exception('Dữ liệu trả về không hợp lệ');
    }
  }


  /// Search topics by keyword
  Future<List<topic>> getTopicsSearch(String keyword) async {
    final data = await get('/controller/topic/searchTopic.php',
        queryParams: {'nameTopic': keyword});

    print(data);

    if (data["data"] is List) {
      final List<topic> topics = (data["data"] as List)
          .map((jsonItem) => topic.fromJson(jsonItem as Map<String, dynamic>))
          .toList()
          .cast<topic>(); // ép kiểu rõ ràng sang List<topic>

      print(topics);
      return topics;
    } else {
      throw Exception('Dữ liệu trả về không hợp lệ');
    }
  }


  /// Get topic by ID
  Future<topic?> getDataTopicByID(String id) async {
    try {
      final data = await get('/controller/topic/getDataTopicByTopicID.php',
          queryParams: {'topic_id': id});
      print(data);
      if (data != null) {
        return topic.fromJson(data["data"]);
      }
      return null;
    } catch (e) {
      //print('Lỗi khi kết nối đến server: $e');
      return null;
    }
  }

  /// Insert new topic
  Future<bool> insertTopic(topic topicInsert) async {
    try {
      // Gửi dữ liệu dạng form đến API
      final response = await postForm(
        '/controller/topic/insertDataTopic.php',
        topicInsert.toJson(),
      );

      print('📨 Response from API: $response');

      // Kiểm tra dữ liệu phản hồi hợp lệ
      if (response is Map<String, dynamic>) {
        final message = response['message'] ?? '';
        final status = response['status'] ?? '';

        // So khớp với thông báo PHP thật ("✅ Topic created successfully.")
        if (status == 'success' && message.contains('Topic created successfully')) {
          print('✅ Insert topic success');
          return true;
        } else if (response.containsKey('error')) {
          print('⚠️ API Error: ${response['error']}');
          return false;
        } else {
          print('⚠️ Unexpected API response: $response');
        }
      } else {
        print('⚠️ Invalid response type: $response');
      }

      return false;
    } catch (e, stackTrace) {
      print('❌ Exception while inserting topic: $e');
      print(stackTrace);
      return false;
    }
  }



  /// Delete topic by ID
  Future<void> deleteTopic(String topicID) async {
    final data = await postJson('/controller/topic/deleteTopic.php', {
      'topicID': topicID,
    });
    print(data);
    print("✅ Delete success: ${data['message']}");
  }
}