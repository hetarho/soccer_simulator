import 'package:soccer_simulator/data/data_source/dto/club_season_stat_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/club_season_stat_data_source.dart';

class ClubSeasonStatRepository {
  final ClubSeasonStatDataSource dataSource;

  ClubSeasonStatRepository(this.dataSource);

  Future<int> addClubSeasonStat({required int seasonId, required int clubId, required int won, required int drawn, required int lost, required int gf, required int ga}) {
    return dataSource.addClubSeasonStat(seasonId: seasonId, clubId: clubId, won: won, drawn: drawn, lost: lost, gf: gf, ga: ga);
  }

  Future<ClubSeasonStatDto?> getClubSeasonStat({required int id}) {
    return dataSource.getClubSeasonStat(id: id);
  }

  Future<int> updateClubSeasonStat({required int id, required int seasonId, required int clubId, required int won, required int drawn, required int lost, required int gf, required int ga}) {
    return dataSource.updateClubSeasonStat(id: id, seasonId: seasonId, clubId: clubId, won: won, drawn: drawn, lost: lost, gf: gf, ga: ga);
  }

  Future<int> deleteClubSeasonStat({required int id}) {
    return dataSource.deleteClubSeasonStat(id: id);
  }

  Future<List<ClubSeasonStatDto>> getAllClubSeasonStats() {
    return dataSource.getAllClubSeasonStats();
  }
}
