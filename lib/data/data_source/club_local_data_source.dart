import 'package:soccer_simulator/data/data_source/dto/club_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/club_data_source.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';
import 'package:soccer_simulator/ui/dbManager/db_manager.dart';

class ClubLocalDataSource implements ClubDataSource {
  final DbManager dbManager;

  ClubLocalDataSource(this.dbManager);

  @override
  Future<int> addClub(
      {required int leagueId,
      required National national,
      required String name,
      required String nickName,
      required int homeColor,
      required int awayColor,
      required String tactics,
      required int winStack,
      required int noLoseStack,
      required int loseStack,
      required int noWinStack}) async {
    final db = await dbManager.getDatabase();
    final clubData = {
      'leagueId': leagueId,
      'national': national.toString(),
      'name': name,
      'nickName': nickName,
      'homeColor': homeColor,
      'awayColor': awayColor,
      'tactics': tactics,
      'winStack': winStack,
      'noLoseStack': noLoseStack,
      'loseStack': loseStack,
      'noWinStack': noWinStack,
    };
    return await db.insert('club', clubData);
  }

  @override
  Future<ClubDto?> getClub({required int id}) async {
    final db = await dbManager.getDatabase();
    List<Map<String, dynamic>> results = await db.query('club', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return ClubDto.fromJson(results.first);
    }
    return null;
  }

  @override
  Future<int> updateClub(
      {required int id,
      required int leagueId,
      required National national,
      required String name,
      required String nickName,
      required int homeColor,
      required int awayColor,
      required String tactics,
      required int winStack,
      required int noLoseStack,
      required int loseStack,
      required int noWinStack}) async {
    final db = await dbManager.getDatabase();
    final clubData = {
      'leagueId': leagueId,
      'national': national.toString(),
      'name': name,
      'nickName': nickName,
      'homeColor': homeColor,
      'awayColor': awayColor,
      'tactics': tactics,
      'winStack': winStack,
      'noLoseStack': noLoseStack,
      'loseStack': loseStack,
      'noWinStack': noWinStack,
    };
    return await db.update('club', clubData, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteClub({required int id}) async {
    final db = await dbManager.getDatabase();
    return await db.delete('club', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<ClubDto>> getAllClubs() async {
    final db = await dbManager.getDatabase();
    final data = await db.query('club');

    return data.map((datum) => ClubDto.fromJson(datum)).toList();
  }
}
