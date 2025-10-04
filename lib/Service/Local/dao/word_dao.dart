import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class WordDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> deleteWord(String word) async {
    final db = await _dbHelper.database;
    await db.delete('words', where: 'word = ?', whereArgs: [word]);
  }

  Future<void> updateWordLevel(String word, int newLevel) async {
    final db = await _dbHelper.database;
    await db.update('words', {"level": newLevel}, where: 'word = ?', whereArgs: [word]);
  }

  Future<Map<String, Map>> getDataCharacter(String typeset) async {
    final db = await _dbHelper.database;
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
      String charName, int level, int setLevel, String typeword) async
  {
    final db = await _dbHelper.database;
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
    final db = await _dbHelper.database;
    final result = await db.query(
      'characterjp',
      where: 'charName = ?',
      whereArgs: [charName],
    );
    return result.isNotEmpty;
  }

  Future<void> increaseCharacterLevel(String charName, int increaseBy, int level, String typeChar) async {
    final db = await _dbHelper.database;

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

  DatabaseHelper getDatabaseHelper(){
    return _dbHelper;
  }
}
