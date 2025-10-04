import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class ReadnotificationDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // tên bảng
  static const String tableName = "read_notifications";

  // cột
  static const String columnId = "id";
  static const String columnNotificationId = "notification_id";
  static const String columnReadAt = "read_at";

  /// Thêm thông báo đã đọc
  Future<int> insertReadNotification(String notificationId) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableName,
      {
        columnNotificationId: notificationId,
        columnReadAt: DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // tránh trùng notification_id
    );
  }

  /// Lấy danh sách tất cả id thông báo đã đọc
  Future<List<int>> getAllReadNotificationIds() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      columns: [columnNotificationId],
    );
    return result.map((e) => e[columnNotificationId] as int).toList();
  }

  /// Kiểm tra một thông báo đã đọc chưa
  Future<bool> isNotificationRead(String notificationId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: "$columnNotificationId = ?",
      whereArgs: [notificationId],
    );
    return result.isNotEmpty;
  }

  /// Xóa trạng thái đã đọc của một thông báo
  Future<int> deleteReadNotification(String notificationId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableName,
      where: "$columnNotificationId = ?",
      whereArgs: [notificationId],
    );
  }

  /// Xóa toàn bộ dữ liệu đã đọc
  Future<int> clearAll() async {
    final db = await _dbHelper.database;
    return await db.delete(tableName);
  }
}
