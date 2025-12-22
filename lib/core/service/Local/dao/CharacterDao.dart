import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class CharacterDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> insertCharacter(
      String charName, int level, int setLevel, String typeword) async {
    final db = await _dbHelper.database;
    await db.insert(
      'characterjp',
      {'charName': charName, 'level': level, 'setLevel': setLevel, 'typeword': typeword},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isCharacterExist(String charName) async {
    final db = await _dbHelper.database;
    final result = await db.query('characterjp', where: 'charName = ?', whereArgs: [charName]);
    return result.isNotEmpty;
  }

  Future<void> increaseCharacterLevel(String charName, int increaseBy) async {
    final db = await _dbHelper.database;
    await db.rawUpdate(
      'UPDATE characterjp SET level = level + ? WHERE charName = ?',
      [increaseBy, charName],
    );
  }
}
