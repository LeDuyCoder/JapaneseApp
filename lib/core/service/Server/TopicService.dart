import '../../module/topic_module.dart';
import '../BaseService.dart';

class TopicService extends BaseService {

  /// Get all topics with limit
  Future<List<TopicModule>> getAllDataTopic(int limit) async {
    final data = await get(
      '/controller/topic/getAllDataTopic.php',
      queryParams: {'limit': limit.toString()},
    );

    if (data["topics"] is List) {
      final List<TopicModule> topics = (data["topics"] as List)
          .map((jsonItem) => TopicModule.fromJson(jsonItem as Map<String, dynamic>))
          .toList();

      return topics; // ✅ Trả về List<topic>
    } else {
      throw Exception('Dữ liệu trả về không hợp lệ');
    }
  }


  /// Search topics by keyword
  Future<List<TopicModule>> getTopicsSearch(String keyword) async {
    final data = await get('/controller/topic/searchTopic.php',
        queryParams: {'nameTopic': keyword});

    if (data["data"] is List) {
      if((data["data"] as List).isEmpty){
        print("cm chung may");
        return [];
      }else{
        final List<TopicModule> topics = (data["data"] as List)
            .map((jsonItem) => TopicModule.fromJson(jsonItem as Map<String, dynamic>))
            .toList()
            .cast<TopicModule>(); // ép kiểu rõ ràng sang List<topic>

        return topics;
      }
    } else {
      throw Exception('Dữ liệu trả về không hợp lệ');
    }
  }


  /// Get topic by ID
  Future<TopicModule?> getDataTopicByID(String id) async {
    try {
      final data = await get('/controller/topic/getDataTopicByTopicID.php',
          queryParams: {'topic_id': id});
      if (data != null) {
        return TopicModule.fromJson(data["data"]);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Insert new topic
  Future<bool> insertTopic(TopicModule topicInsert) async {

    print("check data: ${topicInsert.toMap()}");

    try {
      // Gửi dữ liệu dạng form đến API
      final response = await postForm(
        '/controller/topic/insertDataTopic.php',
        topicInsert.toMap(),
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
    print("✅ Delete success: ${data['message']}");
  }
}