import 'dart:convert';

import '../../Module/WordModule.dart';
import '../BaseService.dart';

class WordService extends BaseService {

  /// Insert multiple words
  Future<bool> insertDataWord(List<Word> words) async {
    try {
      final wordsJson = words.map((w) => w.toJson()).toList();
      await postRaw('/controller/word/inseartDataWord.php',
          jsonEncode(wordsJson), headers: BaseService.jsonHeaders);

      print(jsonEncode(wordsJson));


      print("✅ Insert words thành công");
      return true;
    } catch (e) {
      print("❌ Error inserting words: $e");
      return false;
    }
  }

  /// Fetch words by topic ID
  Future<List<Word>> fetchWordsByTopicID(String topicID) async {
    final data = await get('/controller/word/getDataWord.php',
        queryParams: {'topicID': topicID});

    if (data is List) {
      return data.map((item) => Word.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load words');
    }
  }
}