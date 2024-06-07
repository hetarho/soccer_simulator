import 'package:soccer_simulator/data/data_source/dto/club_season_stat_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/club_season_stat_data_source.dart';
import 'package:soccer_simulator/ui/dbManager/db_manager.dart';

class ClubSeasonStatLocalDataSource implements ClubSeasonStatDataSource {
  final DbManager dbManager;

  ClubSeasonStatLocalDataSource(this.dbManager);

  @override
  Future<int> addClubSeasonStat({required int seasonId, required int clubId, required int won, required int drawn, required int lost, required int gf, required int ga}) async {
    final db = await dbManager.getDatabase();
    final clubSeasonStatData = {
      'seasonId': seasonId,
      'clubId': clubId,
      'won': won,
      'drawn': drawn,
      'lost': lost,
      'gf': gf,
      'ga': ga,
    };
    return await db.insert('clubSeasonStat', clubSeasonStatData);
  }

  @override
  Future<ClubSeasonStatDto?> getClubSeasonStat({required int id}) async {
    final db = await dbManager.getDatabase();
    List<Map<String, dynamic>> results = await db.query('clubSeasonStat', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return ClubSeasonStatDto.fromJson(results.first);
    }
    return null;
  }

  @override
  Future<int> updateClubSeasonStat({required int id, required int seasonId, required int clubId, required int won, required int drawn, required int lost, required int gf, required int ga}) async {
    final db = await dbManager.getDatabase();
    final clubSeasonStatData = {
      'seasonId': seasonId,
      'clubId': clubId,
      'won': won,
      'drawn': drawn,
      'lost': lost,
      'gf': gf,
      'ga': ga,
    };
    return await db.update('clubSeasonStat', clubSeasonStatData, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteClubSeasonStat({required int id}) async {
    final db = await dbManager.getDatabase();
    return await db.delete('clubSeasonStat', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<ClubSeasonStatDto>> getAllClubSeasonStats() async {
    final db = await dbManager.getDatabase();
    final data = await db.query('clubSeasonStat');

    return data.map((datum) => ClubSeasonStatDto.fromJson(datum)).toList();
  }
}
