import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class MiscDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> clearAllData() async {
    final db = await _dbHelper.database;
    final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';");
    for (var t in tables) {
      await db.delete(t['name'] as String);
    }
  }

  Future<Batch> getBatch() async {
    final db = await _dbHelper.database;
    return db.batch();
  }
}
