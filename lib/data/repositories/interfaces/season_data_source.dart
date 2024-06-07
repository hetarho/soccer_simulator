import 'package:soccer_simulator/data/data_source/dto/season_dto.dart';

abstract class SeasonDataSource {
  Future<int> addSeason({required int leagueId, required int roundNumber});
  Future<SeasonDto?> getSeason({required int id});
  Future<int> updateSeason({required int id, required int leagueId, required int roundNumber});
  Future<int> deleteSeason({required int id});
  Future<List<SeasonDto>> getAllSeasons();
}