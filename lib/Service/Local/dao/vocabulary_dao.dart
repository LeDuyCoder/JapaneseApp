import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class VocabularyDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> addWord(String jp, String kana, String? mean, String? exampleJp, String? exampleVi) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'vocabulary',
      {
        'word_jp': jp,
        'word_kana': kana,
        'word_mean': mean,
        'example_jp': exampleJp,
        'example_vi': exampleVi
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Map<String, dynamic>>> getAllVocabulary() async {
    final db = await _dbHelper.database;
    return await db.query('vocabulary');
  }

  Future<int> removeWord(String jp, String kana) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'vocabulary',
      where: 'word_jp = ? AND word_kana = ?',
      whereArgs: [jp, kana],
    );
  }

  Future<void> update(String nameTable, Map<String, dynamic> data, String whereUpdate) async {
    final db = await _dbHelper.database;
    await db.update(nameTable, data, where: whereUpdate);
  }

  Future<bool> isVocabularyExist(
      {
        required String wordJp,
        required String wordKana,
      }) async
  {
    final db = await _dbHelper.database;
    final result = await db.query(
      'vocabulary',
      where: 'word_jp = ? AND word_kana = ?',
      whereArgs: [wordJp, wordKana],
    );
    return result.isNotEmpty;
  }

  // Xóa một từ vựng theo wordJp và wordKana
  Future<int> removeVocabulary(
      {
        required String wordJp,
        required String wordKana,
      }) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'vocabulary',
      where: 'word_jp = ? AND word_kana = ?',
      whereArgs: [wordJp, wordKana],
    );
  }

  Future<int> addVocabularyInDistionary(
      {
        required String wordJp,
        required String wordKana,
        String? wordMean,
        String? exampleJp,
        String? exampleVi,
      }) async
  {
    final db = await _dbHelper.database;
    return await db.insert(
      'vocabulary',
      {
        'word_jp': wordJp,
        'word_kana': wordKana,
        'word_mean': wordMean,
        'example_jp': exampleJp,
        'example_vi': exampleVi,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
