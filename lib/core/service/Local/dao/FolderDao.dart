import 'package:intl/intl.dart';
import 'package:japaneseapp/features/dashboard/domain/models/topic_model.dart';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class FolderDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

    Future<List<Map<String, dynamic>>> getAllFolders() async {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.rawQuery(
          '''SELECT f.id, f.namefolder, f.datefolder, COUNT(ft.topic_id) as amountTopic
            FROM folders f
            LEFT JOIN folder_topics ft ON f.id = ft.folder_id
            GROUP BY f.id, f.namefolder, f.datefolder;
            '''
      );
      return result;
  }

  Future<void> insertFolder(String name) async {
    final db = await _dbHelper.database;
    await db.insert("folders", {"namefolder":name, "datefolder":getFormattedDateTime()});
  }

  Future<void> deleteFolder(int id) async {
    final db = await _dbHelper.database;
    await db.delete('folders', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> addTopicToFolder(int folderID, String topicID) async {
    final db = await _dbHelper.database;
    await db.insert(
      'folder_topics',
      {'folder_id': folderID, 'topic_id': topicID},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeTopicFromFolder(int folderID, String topicID) async {
    final db = await _dbHelper.database;
    await db.delete(
      'folder_topics',
      where: 'folder_id = ? AND topic_id = ?',
      whereArgs: [folderID, topicID],
    );
  }

  Future<bool> hasFolderName(String nameFolder) async {
    List<Map<String, dynamic>> dataFolderTable = await getAllFolders();
    for(Map<String, dynamic> dataFolder in dataFolderTable){
      if(nameFolder == dataFolder["namefolder"]){
        return true;
      }
    }

    return false;
  }

  Future<bool> hasTopicInFolder(int folderID, String topicID) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM folder_topics WHERE folder_id = ? AND topic_id = ?',
      [folderID, topicID],
    );
    return result.isNotEmpty;
  }


  String getFormattedDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(now);
    return formattedDate;
  }

  Future<void> insertNewFolder(String nameFolder) async{
    final db = await _dbHelper.database;
    await db.insert("folders", {"namefolder":nameFolder, "datefolder":getFormattedDateTime()});
  }

  Future<List<TopicEntity>> getAllTopicInFolder(int folderID) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT
          topic.id,
          topic.name AS nameTopic,
          topic.user AS owner,
          COUNT(words.word) AS word_count
      FROM folder_topics t
      JOIN topic
          ON t.topic_id = topic.id
      LEFT JOIN words
          ON topic.name = words.topic
      WHERE t.folder_id = ?
      GROUP BY topic.id, topic.name, topic.user;

    ''', [folderID]);
    print(result);
    return result.map((e) => TopicEntity.fromJson(e)).toList();
  }

  /// Deletes a topic from a folder.<br>
  /// [folderID] is the ID of the folder from which the topic will be removed<br>
  /// [topicID] is the ID of the topic to be removed.<br>
  /// This function uses the `delete` method of the database to remove the topic from the<br>
  /// `folder_topics` table based on the provided folder ID and topic ID.<br>
  Future<void> deleteTopicFromFolder(int folderID, String topicID) async {
    final db = await _dbHelper.database;
    await db.delete(
      'folder_topics',
      where: 'folder_id = ? AND topic_id = ?',
      whereArgs: [folderID, topicID],
    );
  }
}


