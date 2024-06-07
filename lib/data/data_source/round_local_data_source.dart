import 'package:soccer_simulator/data/data_source/dto/round_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/round_data_source.dart';
import 'package:soccer_simulator/ui/dbManager/db_manager.dart';

class RoundLocalDataSource implements RoundDataSource {
  final DbManager dbManager;

  RoundLocalDataSource(this.dbManager);

  @override
  Future<int> addRound({required int seasonId, required int number}) async {
    final db = await dbManager.getDatabase();
    final roundData = {
      'seasonId': seasonId,
      'number': number,
    };
    return await db.insert('round', roundData);
  }

  @override
  Future<RoundDto?> getRound({required int id}) async {
    final db = await dbManager.getDatabase();
    List<Map<String, dynamic>> results = await db.query('round', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return RoundDto.fromJson(results.first);
    }
    return null;
  }

  @override
  Future<int> updateRound({required int id, required int seasonId, required int number}) async {
    final db = await dbManager.getDatabase();
    final roundData = {
      'seasonId': seasonId,
      'number': number,
    };
    return await db.update('round', roundData, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteRound({required int id}) async {
    final db = await dbManager.getDatabase();
    return await db.delete('round', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<RoundDto>> getAllRounds() async {
    final db = await dbManager.getDatabase();
    final data = await db.query('round');

    return data.map((datum) => RoundDto.fromJson(datum)).toList();
  }
}
