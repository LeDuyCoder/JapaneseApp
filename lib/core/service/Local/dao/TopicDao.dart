import 'package:sqflite/sqflite.dart';
import 'package:uuid/v4.dart';
import '../database_helper.dart';

class TopicDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

    Future<List<Map<String, dynamic>>> getAllTopics() async {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM topic');
      return result;
    }

  Future<Map<String, dynamic>?> getTopicByID(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query('topic', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> insertTopic(String nameTopic, String userName) async {
    final db = await _dbHelper.database;
    UuidV4 uuidV4 = const UuidV4();
    await db.insert("topic", {"id":uuidV4.generate(),"name":nameTopic,"user":userName});
  }

  Future<void> deleteTopic(String id) async {
    final db = await _dbHelper.database;
    await db.delete('topic', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllWordsByTopic(String topic) async {
    final db = await _dbHelper.database;
    return await db.query('words', where: 'topic = ?', whereArgs: [topic]);
  }

  Future<void> insertDataTopic(List<Map<String, dynamic>> dataInsert) async {
    final db = await _dbHelper.database;
    try {
      await db.transaction((txn) async {
        for (var topic in dataInsert) {
          await txn.insert(
            'words', // Tên bảng
            topic, // Dữ liệu cần chèn
            conflictAlgorithm: ConflictAlgorithm.replace, // Ghi đè nếu dữ liệu trùng
          );
        }
      });
    } catch (e) {}
  }

  Future<bool> hasTopicName(String nameTopic) async {
    List<Map<String, dynamic>> dataTopics = await getAllTopics();
    for(Map<String, dynamic> dataTopic in dataTopics){
      if(nameTopic == dataTopic["name"]){
        return true;
      }
    }
    return false;
  }

  Future<void> insertTopicID(String id, String nameTopic, String userName) async {
    final db = await _dbHelper.database;
    await db.insert("topic", {"id":id,"name":nameTopic,"user":userName});
  }

  Future<List<Map<String, dynamic>>> getAllWordbyTopic(String topic) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM words WHERE topic = '$topic'");
    return result;
  }

  Future<bool> hasTopicID(String id) async {
    List<Map<String, dynamic>> dataTopics = await getAllTopics();
    for(Map<String, dynamic> dataTopic in dataTopics){
      if(id == dataTopic["id"]){
        return true;
      }
    }
    return false;
  }

  Future<int> countCompletedTopics() async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.rawQuery("""
    SELECT COUNT(*) as completedTopics FROM topic
    WHERE id IN (
      SELECT topic FROM words
      GROUP BY topic
      HAVING COUNT(*) = SUM(CASE WHEN level = 28 THEN 1 ELSE 0 END)
    )
  """);

    if (result.isNotEmpty) {
      return result[0]["completedTopics"] as int;
    }

    return 0;
  }

  Future<List<Map<String, dynamic>>> getAllTopicByName(String topic) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM topic WHERE name = ?',
      [topic],
    );
    return result;
  }
}
