import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class DatabseDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> deleteData(String nameTable, String whereUpdate) async {
    final db = await _dbHelper.database;

    // Xóa dữ liệu từ bảng dựa trên điều kiện (where)
    await db.delete(
      nameTable,      // Tên bảng
      where: whereUpdate,  // Điều kiện xóa (ví dụ: "id = 1")
    );
  }
}
