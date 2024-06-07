import 'package:soccer_simulator/data/data_source/dto/league_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/league_data_source.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';
import 'package:soccer_simulator/ui/dbManager/db_manager.dart';

class LeagueLocalDataSource implements LeagueDataSource {
  final DbManager dbManager;

  LeagueLocalDataSource(this.dbManager);

  @override
  Future<int> addLeague({required int saveSlotId, required String name, required National national, required int level}) async {
    final db = await dbManager.getDatabase();
    final leagueData = {
      'saveSlotId': saveSlotId,
      'name': name,
      'national': national.toString(),
      'level': level,
    };
    return await db.insert('league', leagueData);
  }

  @override
  Future<LeagueDto?> getLeague({required int id}) async {
    final db = await dbManager.getDatabase();
    List<Map<String, dynamic>> results = await db.query('league', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return LeagueDto.fromJson(results.first);
    }
    return null;
  }

  @override
  Future<int> updateLeague({required int id, required int saveSlotId, required String name, required National national, required int level}) async {
    final db = await dbManager.getDatabase();
    final leagueData = {
      'saveSlotId': saveSlotId,
      'name': name,
      'national': national.toString(),
      'level': level,
    };
    return await db.update('league', leagueData, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteLeague({required int id}) async {
    final db = await dbManager.getDatabase();
    return await db.delete('league', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<LeagueDto>> getAllLeagues() async {
    final db = await dbManager.getDatabase();
    final data = await db.query('league');

    return data.map((datum) => LeagueDto.fromJson(datum)).toList();
  }
}
