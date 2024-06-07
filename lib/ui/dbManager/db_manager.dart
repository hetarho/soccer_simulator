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

        await db.execute('''
        CREATE TABLE season (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          leagueId INTEGER,
          roundNumber INTEGER
        )
        ''');

        await db.execute('''
        CREATE TABLE round (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          seasonId INTEGER,
          number INTEGER
        )
        ''');

        await db.execute('''
        CREATE TABLE league (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          saveSlotId INTEGER,
          name TEXT,
          national TEXT,
          level INTEGER
        )
        ''');

        await db.execute('''
        CREATE TABLE fixture (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          roundId INTEGER
        )
        ''');

        await db.execute('''
        CREATE TABLE clubSeasonStat (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          seasonId INTEGER,
          clubId INTEGER,
          won INTEGER,
          drawn INTEGER,
          lost INTEGER,
          gf INTEGER,
          ga INTEGER
        )
        ''');

        await db.execute('''
        CREATE TABLE clubInFixture (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          fixtureId INTEGER,
          clubId INTEGER,
          isHome INTEGER,
          scoredGoal INTEGER,
          hasBallTime INTEGER,
          shoot INTEGER,
          pass INTEGER,
          tackle INTEGER,
          dribble INTEGER
        )
        ''');

        await db.execute('''
        CREATE TABLE club (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          leagueId INTEGER,
          national TEXT,
          name TEXT,
          nickName TEXT,
          homeColor INTEGER,
          awayColor INTEGER,
          tactics TEXT,
          winStack INTEGER,
          noLoseStack INTEGER,
          loseStack INTEGER,
          noWinStack INTEGER
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
