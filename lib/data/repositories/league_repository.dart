import 'package:soccer_simulator/data/data_source/dto/league_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/league_data_source.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';

class LeagueRepository {
  final LeagueDataSource dataSource;

  LeagueRepository(this.dataSource);

  Future<int> addLeague({required int saveSlotId, required String name, required National national, required int level}) {
    return dataSource.addLeague(saveSlotId: saveSlotId, name: name, national: national, level: level);
  }

  Future<LeagueDto?> getLeague({required int id}) {
    return dataSource.getLeague(id: id);
  }

  Future<int> updateLeague({required int id, required int saveSlotId, required String name, required National national, required int level}) {
    return dataSource.updateLeague(id: id, saveSlotId: saveSlotId, name: name, national: national, level: level);
  }

  Future<int> deleteLeague({required int id}) {
    return dataSource.deleteLeague(id: id);
  }

  Future<List<LeagueDto>> getAllLeagues() {
    return dataSource.getAllLeagues();
  }
}
