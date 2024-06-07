import 'package:soccer_simulator/data/data_source/dto/league_dto.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';

abstract class LeagueDataSource {
  Future<int> addLeague({required int saveSlotId, required String name, required National national, required int level});
  Future<LeagueDto?> getLeague({required int id});
  Future<int> updateLeague({required int id, required int saveSlotId, required String name, required National national, required int level});
  Future<int> deleteLeague({required int id});
  Future<List<LeagueDto>> getAllLeagues();
}
