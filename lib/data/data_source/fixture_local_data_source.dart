import 'package:soccer_simulator/data/data_source/dto/fixture_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/fixture_data_source.dart';
import 'package:soccer_simulator/ui/dbManager/db_manager.dart';

class FixtureLocalDataSource implements FixtureDataSource {
  final DbManager dbManager;

  FixtureLocalDataSource(this.dbManager);

  @override
  Future<int> addFixture({required int roundId}) async {
    final db = await dbManager.getDatabase();
    final fixtureData = {
      'roundId': roundId,
    };
    return await db.insert('fixture', fixtureData);
  }

  @override
  Future<FixtureDto?> getFixture({required int id}) async {
    final db = await dbManager.getDatabase();
    List<Map<String, dynamic>> results = await db.query('fixture', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return FixtureDto.fromJson(results.first);
    }
    return null;
  }

  @override
  Future<int> updateFixture({required int id, required int roundId}) async {
    final db = await dbManager.getDatabase();
    final fixtureData = {
      'roundId': roundId,
    };
    return await db.update('fixture', fixtureData, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteFixture({required int id}) async {
    final db = await dbManager.getDatabase();
    return await db.delete('fixture', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<FixtureDto>> getAllFixtures() async {
    final db = await dbManager.getDatabase();
    final data = await db.query('fixture');

    return data.map((datum) => FixtureDto.fromJson(datum)).toList();
  }
}
