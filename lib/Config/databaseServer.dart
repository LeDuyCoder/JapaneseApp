import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:japaneseapp/Module/topic.dart';
import 'package:japaneseapp/Module/WordModule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseServer {
  final String baseUrl = "https://jpa.landernetwork.io.vn/backendServer";

  Future<List<topic>> getAllDataTopic(int limit) async {
    final url = Uri.parse('$baseUrl/getAllDataTopic.php?limit=$limit');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          return data.map((jsonItem) => topic.fromJson(jsonItem)).toList();
        } else {
          throw Exception('Dữ liệu trả về không hợp lệ');
        }
      } else {
        throw Exception('Lỗi từ server: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi kết nối đến server: $e');
      rethrow; // hoặc return []; nếu bạn muốn tránh app crash
    }
  }

  Future<List<topic>> getTopicsSearch(String keyword) async {
    final url = Uri.parse('$baseUrl/searchTopic.php?nameTopic=$keyword');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          return data.map((jsonItem) => topic.fromJson(jsonItem)).toList();
        } else {
          throw Exception('Dữ liệu trả về không hợp lệ');
        }
      } else {
        throw Exception('Lỗi từ server: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi kết nối đến server: $e');
      rethrow; // hoặc return []; nếu bạn muốn tránh app crash
    }
  }

  /// Fetches a [Topic] object from the server using the given [id].
  ///
  /// Sends an HTTP GET request to the endpoint `/getDataTopicByTopicID.php`
  /// with the query parameter `topic_id` set to [id].
  ///
  /// If the server responds with a 200 status code, the response body is
  /// decoded from JSON and converted into a [Topic] object via `Topic.fromJson`.
  ///
  /// Throws an [Exception] if:
  /// - The response status code is not 200
  /// - The JSON data is invalid
  ///
  /// Any network or decoding errors will be caught, printed to the console,
  /// and rethrown for the caller to handle.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final topic = await databaseServer.getDataTopicByID('abc123');
  ///   // Use the topic object
  /// } catch (e) {
  ///   // Handle the error
  /// }
  /// ```
  Future<topic> getDataTopicbyID(String id) async{
    final url = Uri.parse('$baseUrl/getDataTopicByTopicID.php?topic_id=$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return topic.fromJson(data);
      } else {
        throw Exception('Lỗi từ server: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi kết nối đến server: $e');
      rethrow; // hoặc return []; nếu bạn muốn tránh app crash
    }
  }

  /// Sends a [topic] object to the server via HTTP POST request.
  ///
  /// The topic is inserted into the database via the PHP endpoint.
  /// Returns `true` if insert succeeds, otherwise throws an [Exception].
  Future<bool> insertTopic(topic topicInsert) async {
    final url = Uri.parse('$baseUrl/insertDataTopic.php'); // cập nhật đúng đường dẫn của bạn
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: topicInsert.toJson(),
      );

      if (response.statusCode == 201) {
        print('✅ Insert topic success: ${response.body}');
        return true;
      } else {
        throw Exception('❌ Insert failed: ${response.body}');
      }
    } catch (e) {
      print('⚠️ Error while inserting topic: $e');
      rethrow;
    }
  }

  /// Sends a list of [Word] objects to the server for insertion.
  ///
  /// This method converts the list into JSON and sends it via HTTP POST
  /// to the endpoint `/insertWord.php`.
  ///
  /// Throws an [Exception] if the server response indicates failure.
  Future<bool> insertDataWord(List<Word> words) async {
    final url = Uri.parse('$baseUrl/inseartDataWord.php'); // cập nhật đúng đường dẫn của bạn

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(words.map((w) => w.toJson()).toList()),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("✅ Insert thành công: ${responseData['message']}");
        return true;
      } else {
        return false;

      }
    } catch (e) {
      return false;
    }
  }

  Future<List<Word>> fetchWordsByTopicID(String topicID) async {
    final String apiUrl = '$baseUrl/getDataWord.php?topicID=$topicID';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Word.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load words: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching words: $e');
    }
  }

  Future<void> deleteTopic(String topicID) async {
    final String apiUrl = '$baseUrl/deleteTopic.php'; // thay URL đúng với server của bạn

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'topicID': topicID,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Delete success: ${data['message']}");
      } else {
        final data = jsonDecode(response.body);
        throw Exception('❌ Delete failed: ${data['error']}');
      }
    } catch (e) {
      print("❌ Error calling API: $e");
      rethrow;
    }
  }
}
