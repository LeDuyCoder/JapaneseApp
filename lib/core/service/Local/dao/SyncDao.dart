import 'dart:convert';

import 'package:archive/archive.dart';

import '../database_helper.dart';

class SyncDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Map<String, dynamic>> decodeSynchronyData(String encoded) async {
    final bytes = base64Decode(encoded);
    final decompressed = GZipDecoder().decodeBytes(bytes);
    return jsonDecode(utf8.decode(decompressed));
  }

  Future<String> exportAllData() async {
    final db = await _dbHelper.database;
    final tables = await db.rawQuery(
      "SELECT name, sql FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
    );

    Map<String, dynamic> allData = {};
    for (var table in tables) {
      String name = table['name'] as String;
      String? schema = table['sql'] as String?;
      List<Map<String, dynamic>> rows = await db.query(name);

      allData[name] = {"schema": schema, "rows": rows};
    }

    final jsonStr = jsonEncode(allData);
    final compressed = GZipEncoder().encode(utf8.encode(jsonStr) as List<int>);
    return base64Encode(compressed!);
  }

  Future<void> importData(String encodedData) async {
    final db = await _dbHelper.database;
    final importedData = await decodeSynchronyData(encodedData);

    for (final entry in importedData.entries) {
      final String tableName = entry.key;
      final tableContent = entry.value as Map<String, dynamic>;
      final String? schema = tableContent["schema"] as String?;
      final rows = List<Map<String, dynamic>>.from(tableContent["rows"]);

      if (schema != null && schema.isNotEmpty) {
        await db.execute("DROP TABLE IF EXISTS $tableName");
        await db.execute(schema);
      }

      for (final row in rows) {
        await db.insert(tableName, row);
      }
    }
  }

  Future<String> getAllSynchronyData({List<String>? includeTables}) async {
    final db = await _dbHelper.database;

    // Lấy danh sách tất cả bảng
    final List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name, sql FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
    );

    Map<String, dynamic> allData = {};

    // Lọc bảng nếu truyền includeTables
    final filteredTables = includeTables != null
        ? tables.where((t) => includeTables.contains(t['name']))
        : tables;

    // Query song song thay vì tuần tự
    final futures = filteredTables.map((table) async {
      String tableName = table['name'];
      String? schema = table['sql'];

      List<Map<String, dynamic>> tableData = await db.query(tableName);

      return {
        "name": tableName,
        "schema": schema,
        "rows": tableData,
      };
    });

    final results = await Future.wait(futures);

    for (var r in results) {
      final tableName = r["name"] as String;
      final schema = r["schema"] as String?;
      final rows = r["rows"] as List<Map<String, dynamic>>;

      allData[tableName] = {
        "schema": schema,
        "rows": rows,
      };
    }

    // Encode JSON
    final jsonStr = jsonEncode(allData);

    // Gzip nén JSON để tiết kiệm dung lượng
    final compressed = GZipEncoder().encode(utf8.encode(jsonStr) as List<int>);

    // Base64 để lưu vào Firestore
    return base64Encode(compressed!);
  }

  Future<void> importSynchronyData(String encodedData) async {
    final db = await _dbHelper.database;
    final Map<String, dynamic> importedData = await decodeSynchronyData(encodedData);

    final List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
    );

    await db.execute('''
        UPDATE words
        SET topic = (
          SELECT topic.id
          FROM topic
          WHERE topic.name = words.topic
        )
        WHERE EXISTS (
          SELECT 1
          FROM topic
          WHERE topic.name = words.topic
        );
      ''');

    for (var table in tables) {
      final tableName = table['name'] as String;
      await db.delete(tableName);
    }

    for (final entry in importedData.entries) {
      final String tableName = entry.key;
      final Map<String, dynamic> tableContent = Map<String, dynamic>.from(entry.value);

      final String? schema = tableContent["schema"] as String?;
      final List<dynamic> rowsRaw = tableContent["rows"] as List<dynamic>;

      final List<Map<String, dynamic>> rows =
      rowsRaw.map((r) => Map<String, dynamic>.from(r)).toList();

      if (schema != null && schema.isNotEmpty) {
        await db.execute("DROP TABLE IF EXISTS $tableName");
        await db.execute(schema);
      }

      for (final row in rows) {
        await db.insert(tableName, row);
      }
    }
  }
}
