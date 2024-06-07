import 'package:soccer_simulator/data/data_source/dto/season_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/season_data_source.dart';

class SeasonRepository {
  final SeasonDataSource dataSource;

  SeasonRepository(this.dataSource);

  Future<int> addSeason({required int leagueId, required int roundNumber}) {
    return dataSource.addSeason(leagueId: leagueId, roundNumber: roundNumber);
  }

  Future<SeasonDto?> getSeason({required int id}) {
    return dataSource.getSeason(id: id);
  }

  Future<int> updateSeason({required int id, required int leagueId, required int roundNumber}) {
    return dataSource.updateSeason(id: id, leagueId: leagueId, roundNumber: roundNumber);
  }

  Future<int> deleteSeason({required int id}) {
    return dataSource.deleteSeason(id: id);
  }

  Future<List<SeasonDto>> getAllSeasons() {
    return dataSource.getAllSeasons();
  }
}
