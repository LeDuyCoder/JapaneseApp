import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
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
    print("path: $path");

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
      await db.execute('''
      CREATE TABLE IF NOT EXISTS topic (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      );
    ''');

      await db.execute("""
        CREATE TABLE IF NOT EXISTS words (
          word TEXT NOT NULL,
          mean TEXT NOT NULL,
          wayread TEXT NOT NULL,
          topic TEXT NOT NULL,
          level INTEGER
        );
      """);

      await db.execute("""
        CREATE TABLE IF NOT EXISTS folders (
          namefolder TEXT NOT NULL,
          topics TEXT
        );
      """);

      print("Tables created successfully.");
    } catch (e) {
      print("Error creating tables: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAllFolder() async {
    final db = await instance.database;

    // Sử dụng truy vấn SQL thô
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM folders');
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllTopic() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM topic');
    return result;
  }

  Future<bool> hasFolderName(String nameFolder) async {
    final db = await instance.database;
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

  Future<void> insertNewFolder(String nameFolder) async{
    final db = await instance.database;
    await db.insert("folders", {"namefolder":nameFolder});
  }

  Future<List<Map<String, dynamic>>> getAllWordbyTopic(String topic) async {
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM words WHERE topic = '$topic'");
    return result;
  }

  Future<void> insertDataTopic(List<Map<String, dynamic>> dataInsert) async {
    final db = await instance.database;
    try {
      print(dataInsert);
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
      print("Lỗi khi chèn dữ liệu: $e");
    }
  }

  Future<void> insertTopic(String nameTopic) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;


    final db = await instance.database;
    UuidV4 uuidV4 = UuidV4();
    await db.insert("topic", {"id":"${uuidV4.generate()}-${androidInfo.model}","name":nameTopic});
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

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
