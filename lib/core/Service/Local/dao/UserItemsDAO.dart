import 'package:sqflite/sqflite.dart';
import 'package:uuid/v4.dart';
import '../database_helper.dart';

class UserItemsDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> insertUserItem(String itemType, String itemId) async {
    final db = await _dbHelper.database;
    await db.insert(
      'user_items',
      {
        'id': const UuidV4().generate(),
        'item_type': itemType,
        'item_id': itemId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // nếu trùng id thì ghi đè
    );
  }

  Future<bool> isItemExists(String itemId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'user_items',
      where: 'item_id = ?',
      whereArgs: [itemId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await _dbHelper.database;
    return await db.query('user_items', orderBy: 'acquired_at DESC');
  }

  Future<int> deleteItem(String itemId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'user_items',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
  }


}
