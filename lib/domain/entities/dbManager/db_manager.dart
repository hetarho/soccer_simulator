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
        CREATE TABLE saveSlot (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          selectedLeagueId INTEGER,
          selectedClubId INTEGER
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
