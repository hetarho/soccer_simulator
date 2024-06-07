import 'package:soccer_simulator/data/data_source/dto/club_season_stat_dto.dart';

abstract class ClubSeasonStatDataSource {
  Future<int> addClubSeasonStat({required int seasonId, required int clubId, required int won, required int drawn, required int lost, required int gf, required int ga});
  Future<ClubSeasonStatDto?> getClubSeasonStat({required int id});
  Future<int> updateClubSeasonStat({required int id, required int seasonId, required int clubId, required int won, required int drawn, required int lost, required int gf, required int ga});
  Future<int> deleteClubSeasonStat({required int id});
  Future<List<ClubSeasonStatDto>> getAllClubSeasonStats();
}