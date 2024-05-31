import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbManager {
  static Database? _database;

  static Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local_db.db');

    // 기존 데이터베이스 삭제 (개발 중에만 사용, 프로덕션에서는 사용하지 않음)
    // await deleteDatabase(path);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE saveSlot (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
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
