import 'package:soccer_simulator/data/data_source/dto/club_in_fixture_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/club_in_fixture_data_source.dart';
import 'package:soccer_simulator/ui/dbManager/db_manager.dart';

class ClubInFixtureLocalDataSource implements ClubInFixtureDataSource {
  final DbManager dbManager;

  ClubInFixtureLocalDataSource(this.dbManager);

  @override
  Future<int> addClubInFixture(
      {required int fixtureId,
      required int clubId,
      required bool isHome,
      required int scoredGoal,
      required int hasBallTime,
      required int shoot,
      required int pass,
      required int tackle,
      required int dribble}) async {
    final db = await dbManager.getDatabase();
    final clubInFixtureData = {
      'fixtureId': fixtureId,
      'clubId': clubId,
      'isHome': isHome ? 1 : 0,
      'scoredGoal': scoredGoal,
      'hasBallTime': hasBallTime,
      'shoot': shoot,
      'pass': pass,
      'tackle': tackle,
      'dribble': dribble,
    };
    return await db.insert('clubInFixture', clubInFixtureData);
  }

  @override
  Future<ClubInFixtureDto?> getClubInFixture({required int id}) async {
    final db = await dbManager.getDatabase();
    List<Map<String, dynamic>> results = await db.query('clubInFixture', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return ClubInFixtureDto.fromJson(results.first);
    }
    return null;
  }

  @override
  Future<int> updateClubInFixture(
      {required int id,
      required int fixtureId,
      required int clubId,
      required bool isHome,
      required int scoredGoal,
      required int hasBallTime,
      required int shoot,
      required int pass,
      required int tackle,
      required int dribble}) async {
    final db = await dbManager.getDatabase();
    final clubInFixtureData = {
      'fixtureId': fixtureId,
      'clubId': clubId,
      'isHome': isHome ? 1 : 0,
      'scoredGoal': scoredGoal,
      'hasBallTime': hasBallTime,
      'shoot': shoot,
      'pass': pass,
      'tackle': tackle,
      'dribble': dribble,
    };
    return await db.update('clubInFixture', clubInFixtureData, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteClubInFixture({required int id}) async {
    final db = await dbManager.getDatabase();
    return await db.delete('clubInFixture', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<ClubInFixtureDto>> getAllClubInFixtures() async {
    final db = await dbManager.getDatabase();
    final data = await db.query('clubInFixture');

    return data.map((datum) => ClubInFixtureDto.fromJson(datum)).toList();
  }
}
