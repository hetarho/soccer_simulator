import 'package:soccer_simulator/data/data_source/dto/season_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/season_data_source.dart';
import 'package:soccer_simulator/ui/dbManager/db_manager.dart';

class SeasonLocalDataSource implements SeasonDataSource {
  final DbManager dbManager;

  SeasonLocalDataSource(this.dbManager);

  @override
  Future<int> addSeason({required int leagueId, required int roundNumber}) async {
    final db = await dbManager.getDatabase();
    final seasonData = {
      'leagueId': leagueId,
      'roundNumber': roundNumber,
    };
    return await db.insert('season', seasonData);
  }

  @override
  Future<SeasonDto?> getSeason({required int id}) async {
    final db = await dbManager.getDatabase();
    List<Map<String, dynamic>> results = await db.query('season', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return SeasonDto.fromJson(results.first);
    }
    return null;
  }

  @override
  Future<int> updateSeason({required int id, required int leagueId, required int roundNumber}) async {
    final db = await dbManager.getDatabase();
    final seasonData = {
      'leagueId': leagueId,
      'roundNumber': roundNumber,
    };
    return await db.update('season', seasonData, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteSeason({required int id}) async {
    final db = await dbManager.getDatabase();
    return await db.delete('season', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<SeasonDto>> getAllSeasons() async {
    final db = await dbManager.getDatabase();
    final data = await db.query('season');

    return data.map((datum) => SeasonDto.fromJson(datum)).toList();
  }
}
