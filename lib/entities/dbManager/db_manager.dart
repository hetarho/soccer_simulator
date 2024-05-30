import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbManager {
  static Database? _database;

  static Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local_db.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE league (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT
        )
        ''');
        await db.execute('''
        CREATE TABLE club (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          league_id INTEGER,
          FOREIGN KEY (league_id) REFERENCES league (id)
        )
        ''');
        await db.execute('''
        CREATE TABLE player (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          club_id INTEGER,
          FOREIGN KEY (club_id) REFERENCES club (id)
        )
        ''');
      },
    );
  }

  Future<Database> getDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database!;
  }
}
