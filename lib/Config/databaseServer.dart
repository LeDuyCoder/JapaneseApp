import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:japaneseapp/Module/topic.dart';
import 'package:japaneseapp/Module/WordModule.dart';

import '../Utilities/WeekUtils.dart';

class DatabaseServer {
  final String baseUrl = "http://10.0.2.2/backend";

  Future<List<dynamic>> getAllDataTopic(int limit) async {
    final url = Uri.parse('$baseUrl/controller/topic/getAllDataTopic.php?limit=$limit');

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
      rethrow;
    }
  }

  Future<List<topic>> getTopicsSearch(String keyword) async {
    final url = Uri.parse('$baseUrl/controller/topic/searchTopic.php?nameTopic=$keyword');

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
  Future<topic?> getDataTopicbyID(String id) async{
    final url = Uri.parse('$baseUrl/controller/topic/getDataTopicByTopicID.php?topic_id=$id');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return topic.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Lỗi khi kết nối đến server: $e');
      rethrow;
    }
  }

  /// Sends a [topic] object to the server via HTTP POST request.
  ///
  /// The topic is inserted into the database via the PHP endpoint.
  /// Returns `true` if insert succeeds, otherwise throws an [Exception].
  Future<bool> insertTopic(topic topicInsert) async {
    final url = Uri.parse('$baseUrl/controller/topic/insertDataTopic.php'); // cập nhật đúng đường dẫn của bạn
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
    final url = Uri.parse('$baseUrl/controller/word/inseartDataWord.php'); // cập nhật đúng đường dẫn của bạn

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
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
    final String apiUrl = '$baseUrl/controller/word/getDataWord.php?topicID=$topicID';

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
    final String apiUrl = '$baseUrl/controller/topic/deleteTopic.php'; // thay URL đúng với server của bạn

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
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getScore(String period, String userId) async {
    final url = Uri.parse('$baseUrl/controller/score/getScore.php?period=$period&userId=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          return data["score"];
        } else {
          throw Exception('Dữ liệu trả về không hợp lệ');
        }
      } else {
        throw Exception('Lỗi từ server: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  //http://localhost/backend/controller/score/leaderboard.php?period=week-2025-39
  // [
  //   {
  //     "user_id": "edf7b001-0fbd-4766-a8da-fdde0f72282d",
  //     "score": 100,
  //     "user_name": "Lê Hữu Duy"
  //   }
  // ]
  //get leaderboard
  Future<List<Map<String, dynamic>>> getLeaderboard(String period, int limit) async {
    final url = Uri.parse('$baseUrl/controller/score/leaderboard.php?period=$period&limit=$limit');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else {
          throw Exception('Dữ liệu trả về không hợp lệ');
        }
      } else {
        throw Exception('Lỗi từ server: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  //http://localhost/backend/controller/user/addUser?idUser=10&name=10
  Future<void> addUser(String idUser, String name) async {
    print("demo");
    final url = Uri.parse('$baseUrl/controller/user/addUser.php');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'idUser': idUser,
          'name': name,
        },
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        await addScore(idUser, 0);
      } else {
        throw Exception('Failed to add user: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addScore(String userId, int score) async {
    final url = Uri.parse('$baseUrl/controller/score/addScore.php');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'points': score,
          'period': WeekUtils.getCurrentWeekString(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print("✅ Add score success: ${data['message']}");
      } else {
        final data = jsonDecode(response.body);
        throw Exception('❌ Add score failed: ${data['error']}');
      }
    } catch (e) {
      rethrow;
    }
  }

  //http://localhost/backend/controller/user/getCoin.php
  //idUser in POST
  // {
  //   "coins": 200
  // }
  Future<int> getCoin(String idUser) async {
    final url = Uri.parse('$baseUrl/controller/user/getCoin.php');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'idUser': idUser,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {

        final data = json.decode(response.body);
        return data['coins'];
      } else {
        throw Exception('Lỗi từ server: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<void> addCoin(String idUser, int coin) async {
    final url = Uri.parse('$baseUrl/controller/user/addCoin.php');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'idUser': idUser,
          'coint': "$coin",
        },
      );
      print("check add coin: ${response.statusCode}");
      if (response.statusCode == 200) {
      } else {
        throw Exception('Lỗi từ server: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
