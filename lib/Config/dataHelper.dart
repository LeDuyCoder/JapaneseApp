import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:japaneseapp/Module/topic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/v4.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    // Đảm bảo rằng phiên bản đã được tăng lên để gọi lại onCreate nếu cần thiết
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }


  Future<void> _createDB(Database db, int version) async {
    print("Creating tables...");

    try {
      // Tạo bảng characterjp
      await db.execute('''
      CREATE TABLE IF NOT EXISTS characterjp (
        charName TEXT NOT NULL,
        level INTEGER,
        setLevel INTEGER,
        typeword TEXT NOT NULL
      );
    ''');

      // Tạo bảng topic
      await db.execute('''
      CREATE TABLE IF NOT EXISTS topic (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        user Text NOT NULL
      );
    ''');

      // Tạo bảng words
      await db.execute('''
      CREATE TABLE IF NOT EXISTS words (
        word TEXT NOT NULL,
        mean TEXT NOT NULL,
        wayread TEXT NOT NULL,
        topic TEXT NOT NULL,
        level INTEGER
      );
    ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS folders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          namefolder TEXT NOT NULL,
          datefolder TEXT
        );
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS folder_topics (
          folder_id INTEGER NOT NULL,
          topic_id INTEGER NOT NULL,
          FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE CASCADE,
          FOREIGN KEY (topic_id) REFERENCES topic(id) ON DELETE CASCADE,
          PRIMARY KEY (folder_id, topic_id)
        );
      ''');

      var tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
      print(tables);
      print("Tables created/updated successfully.");
    } catch (e) {
      print("Error creating/updating tables: $e");
    }
  }


  Future<List<Map<String, dynamic>>> getAllFolder() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
        '''SELECT f.id, f.namefolder, f.datefolder, COUNT(ft.topic_id) as amountTopic
          FROM folders f
          LEFT JOIN folder_topics ft ON f.id = ft.folder_id
          GROUP BY f.id, f.namefolder, f.datefolder;
          '''
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllTopic() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM topic');
    return result;
  }

  Future<Map<String, dynamic>> getTopicByID(String id) async{
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM topic WHERE id = ?',
      [id],
    );
    return result[0];
  }

  Future<List<Map<String, dynamic>>> getAllTopicByName(String topic) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM topic WHERE name = ?',
      [topic],
    );
    return result;
  }

  Future<bool> hasFolderName(String nameFolder) async {
    List<Map<String, dynamic>> dataFolderTable = await getAllFolder();
    for(Map<String, dynamic> dataFolder in dataFolderTable){
      if(nameFolder == dataFolder["namefolder"]){
        return true;
      }
    }

    return false;
  }

  Future<bool> hasTopicName(String nameTopic) async {
    List<Map<String, dynamic>> dataTopics = await getAllTopic();
    for(Map<String, dynamic> dataTopic in dataTopics){
      if(nameTopic == dataTopic["name"]){
        return true;
      }
    }
    return false;
  }

  Future<bool> hasTopicID(String id) async {
    List<Map<String, dynamic>> dataTopics = await getAllTopic();
    for(Map<String, dynamic> dataTopic in dataTopics){
      if(id == dataTopic["id"]){
        return true;
      }
    }
    return false;
  }

  String getFormattedDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(now);
    return formattedDate;
  }


  Future<void> insertNewFolder(String nameFolder) async{
    final db = await instance.database;
    await db.insert("folders", {"namefolder":nameFolder, "datefolder":getFormattedDateTime()});
  }

  Future<List<Map<String, dynamic>>> getAllWordbyTopic(String topic) async {
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM words WHERE topic = '$topic'");
    return result;
  }

  Future<void> deleteData(String nameTable, String whereUpdate) async {
    final db = await instance.database;

    // Xóa dữ liệu từ bảng dựa trên điều kiện (where)
    await db.delete(
      nameTable,      // Tên bảng
      where: whereUpdate,  // Điều kiện xóa (ví dụ: "id = 1")
    );
  }


  Future<void> insertDataTopic(List<Map<String, dynamic>> dataInsert) async {
    final db = await instance.database;
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
    } catch (e) {
    }
  }

  Future<void> insertTopic(String nameTopic, String userName) async {
    final db = await instance.database;
    UuidV4 uuidV4 = const UuidV4();
    await db.insert("topic", {"id":uuidV4.generate(),"name":nameTopic,"user":userName});
  }

  Future<void> insertTopicID(String id, String nameTopic, String userName) async {
    final db = await instance.database;
    await db.insert("topic", {"id":id,"name":nameTopic,"user":userName});
  }

  Future<List<Map<String, dynamic>>> getDataTopicbyNameFolder(String nameFolder) async {
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM folders WHERE namefolder = '$nameFolder'");
    return result;
  }

  Future<void> updateDatabase(String nameTable, Map<String, dynamic> data, String whereUpdate) async {
    final db = await instance.database;
    await db.update(nameTable, data, where: whereUpdate);
  }

  Future<String> getAllSynchronyData() async {
    final db = await instance.database;

    // Lấy danh sách tất cả các bảng (trừ bảng hệ thống)
    final List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';"
    );

    Map<String, dynamic> allData = {};

    for (var table in tables) {
      String tableName = table['name'];
      List<Map<String, dynamic>> tableData = await db.query(tableName);
      allData[tableName] = tableData;
    }

    return jsonEncode(allData);
  }

  Future<void> clearAllData() async {
    final db = await instance.database;

    // Lấy danh sách tất cả các bảng (trừ bảng hệ thống)
    final List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';"
    );

    // Xóa tất cả dữ liệu từ mỗi bảng
    for (var table in tables) {
      String tableName = table['name'];
      await db.delete(tableName);
    }
  }

  Future<void> importSynchronyData(String jsonData) async {
    final db = await instance.database;

    // Step 1: Clear all tables
    final List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';"
    );

    // Delete all rows from each table
    for (var table in tables) {
      String tableName = table['name'];
      await db.delete(tableName);
    }

    // Step 2: Import the new data from JSON
    Map<String, dynamic> importedData = jsonDecode(jsonData);

    // Insert data into each table
    for (String tableName in importedData.keys) {
      List<Map<String, dynamic>> tableData = List<Map<String, dynamic>>.from(importedData[tableName]);

      // Insert all rows for this table
      for (var row in tableData) {
        await db.insert(tableName, row);
      }
    }

    print("Data imported successfully.");
  }


  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  Future<bool> isTopicCompleted(String topic) async {
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT COUNT(*) as total, SUM(CASE WHEN level = 28 THEN 1 ELSE 0 END) as completed FROM words WHERE topic = ?", [topic]);

    if (result.isNotEmpty) {
      int total = result[0]["total"] as int;
      int completed = result[0]["completed"] as int;
      return total > 0 && total == completed;
    }

    return false;
  }

  Future<int> countCompletedTopics() async {
    final db = await instance.database;
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

  Future<Map<String, Map>> getDataCharacter(String typeset) async {
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT setLevel, *
    FROM characterjp
    WHERE typeword = ?
    AND setLevel IN (1, 2, 3, 4, 5)
  ''', [typeset]);

    // Khởi tạo Map với danh sách rỗng cho mỗi cấp độ
    Map<String, Map<dynamic, dynamic>> data = {
      "1": {},
      "2": {},
      "3": {},
      "4": {},
      "5": {}
    };

    // Duyệt qua kết quả truy vấn và đưa vào danh sách tương ứng
    for (var row in result) {
      String levelKey = row['setLevel'].toString(); // Chuyển setLevel thành String để làm key
      if (data.containsKey(levelKey)) {
        data[levelKey]!.putIfAbsent(row["charName"], () => [row]);
      }
    }

    return data;
  }

  Future<void> insertCharacter(
      String charName, int level, int setLevel, String typeword) async {
    final db = await instance.database;
    await db.insert(
      'characterjp',
        {
          'charName': charName,
          'level': level,
          'setLevel': setLevel,
          'typeword': typeword,
        },
      conflictAlgorithm: ConflictAlgorithm.replace, // Tránh lỗi trùng key
    );
  }

  Future<bool> isCharacterExist(String charName) async {
    final db = await instance.database;
    final result = await db.query(
      'characterjp',
      where: 'charName = ?',
      whereArgs: [charName],
    );
    return result.isNotEmpty;
  }

  Future<void> increaseCharacterLevel(String charName, int increaseBy, int level, String typeChar) async {
    final db = await instance.database;

    // Kiểm tra nhân vật có tồn tại không
    bool exists = await isCharacterExist(charName);

    if (exists) {
      // Nếu tồn tại, tăng level
      await db.rawUpdate(
        'UPDATE characterjp SET level = level + ? WHERE charName = ?',
        [increaseBy, charName],
      );
    } else {
      // Nếu chưa tồn tại, thêm mới nhân vật với level mặc định là increaseBy
      await insertCharacter(charName, increaseBy, level, typeChar);
    }
  }

  Future<Batch> getBatch() async {
    final db = _database; // Đảm bảo database đã khởi tạo
    return db!.batch(); // Trả về Batch để sử dụng sau này
  }

  /// Checks if a topic exists in a specific folder.
  Future<bool> hasTopicInFolder(int folderID, String topicID) async {
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM folder_topics WHERE folder_id = ? AND topic_id = ?',
      [folderID, topicID],
    );
    return result.isNotEmpty;
  }

  //write documentation for this function by English
  /// Adds a topic to a folder.
  /// Returns true if the topic was successfully added, false if the topic already exists in the folder.<br>
  /// [folderID] is the ID of the folder to which the topic will be added.<br>
  /// [topicID] is the ID of the topic to be added.<br>
  /// If the topic already exists in the folder, it returns false without adding it again.<br>
  /// If the topic is successfully added, it returns true.<br>
  /// This function uses a conflict algorithm to ignore duplicate entries, ensuring that no error is thrown if the
  /// topic already exists in the folder.<br>
  /// Example usage:
  /// ```dart
  /// bool success = await DatabaseHelper.instance.addTopicToFolder(folderID, topicID);
  /// if (success) {
  ///   print('Topic added successfully.');
  /// } else {
  ///  print('Topic already exists in the folder.');
  ///  }
  ///  ```
  Future<bool> addTopicToFolder(int folderID, String topicID) async {
    try {
      final db = await instance.database;

      if (await hasTopicInFolder(folderID, topicID)) {
        return false; // Topic already exists in folder
      }

      // Check if topicID exists in topic table
      final topicExists = await db.query(
        'topic',
        where: 'id = ?',
        whereArgs: [topicID],
      );
      if (topicExists.isEmpty) {
        throw Exception('Topic ID does not exist');
      }

      await db.insert(
        'folder_topics',
        {'folder_id': folderID, 'topic_id': topicID},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );

      return true; // Successfully added
    } catch (e) {
      print('Error adding topic to folder: $e');
      return false;
    } // Thêm thành công
  }

  /// Deletes a topic from a folder.<br>
  /// [folderID] is the ID of the folder from which the topic will be removed<br>
  /// [topicID] is the ID of the topic to be removed.<br>
  /// This function uses the `delete` method of the database to remove the topic from the<br>
  /// `folder_topics` table based on the provided folder ID and topic ID.<br>
  Future<void> deleteTopicFromFolder(int folderID, String topicID) async {
    final db = await instance.database;
    await db.delete(
      'folder_topics',
      where: 'folder_id = ? AND topic_id = ?',
      whereArgs: [folderID, topicID],
    );
  }

  Future<List<topic>> getAllTopicInFolder(int folderID) async {
    final db = await instance.database;
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
    return result.map((e) => topic.fromJson(e)).toList();
  }
  
  Future<void> deleteFolder(int folderID) async {
    final db = await instance.database;
    db.delete("folder_topics", where: "folder_id = ?", whereArgs: [folderID]);
    await db.delete(
      'folders',
      where: 'id = ?',
      whereArgs: [folderID],
    );
  }

  Future<void> createDataLevel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("level")){
      await prefs.setInt("level", 1);
      await prefs.setInt("exp", 0);
      await prefs.setInt("nextExp", 100);
    }

    if(!prefs.containsKey("Streak")){
      await prefs.setInt("Streak", 0);
      await prefs.setString("lastCheckIn", '');
      await prefs.setStringList("checkInHistoryTreak", <String>[]);
      await prefs.setStringList("checkInHistory", <String>[]);
    }

    if(!prefs.containsKey("achivement")){
      await prefs.setStringList("achivement", <String>[]);
    }

    Map<String, dynamic> data = {
      "levelSet": 0,
      "level": 0,
    };

    if(!prefs.containsKey("hiragana")){
      await prefs.setString("hiragana", jsonEncode(data));
    }

    if(!prefs.containsKey("katakana")){
      await prefs.setString("katakana", jsonEncode(data));
    }
  }
}
