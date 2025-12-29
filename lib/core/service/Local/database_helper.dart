import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
      onUpgrade: _updateDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS topic (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        user TEXT NOT NULL
      );
    ''');

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
        topic_id TEXT NOT NULL,
        FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE CASCADE,
        FOREIGN KEY (topic_id) REFERENCES topic(id) ON DELETE CASCADE,
        PRIMARY KEY (folder_id, topic_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS characterjp (
        charName TEXT NOT NULL,
        level INTEGER,
        setLevel INTEGER,
        typeword TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS vocabulary (
        word_jp TEXT NOT NULL,
        word_kana TEXT NOT NULL,
        word_mean TEXT,
        example_jp TEXT,
        example_vi TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (word_jp, word_kana)
      );
    ''');

    await db.execute('''
        CREATE TABLE read_notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            notification_id TEXT NOT NULL,
            read_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
            UNIQUE(notification_id)
        );
      ''');

    await db.execute('''
      CREATE TABLE user_items (
          id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
          item_type TEXT NOT NULL,
          item_id VARCHAR(50) NOT NULL,
          acquired_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );

    ''');
  }

  Future<void> _updateDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('''
            CREATE TABLE read_notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            notification_id TEXT NOT NULL,
            read_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(notification_id)
        );
      ''');
    }

    if(oldVersion < 4){
      await db.execute('''
        CREATE TABLE user_items (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            item_type TEXT NOT NULL,
            item_id VARCHAR(50) NOT NULL,
            acquired_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
        ''');
    }
    if(oldVersion < 5){
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
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Batch> getBatch() async {
    final db = _database; // Đảm bảo database đã khởi tạo
    return db!.batch(); // Trả về Batch để sử dụng sau này
  }
}
