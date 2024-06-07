import 'package:soccer_simulator/data/data_source/dto/round_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/round_data_source.dart';

class RoundRepository {
  final RoundDataSource dataSource;

  RoundRepository(this.dataSource);

  Future<int> addRound({required int seasonId, required int number}) {
    return dataSource.addRound(seasonId: seasonId, number: number);
  }

  Future<RoundDto?> getRound({required int id}) {
    return dataSource.getRound(id: id);
  }

  Future<int> updateRound({required int id, required int seasonId, required int number}) {
    return dataSource.updateRound(id: id, seasonId: seasonId, number: number);
  }

  Future<int> deleteRound({required int id}) {
    return dataSource.deleteRound(id: id);
  }

  Future<List<RoundDto>> getAllRounds() {
    return dataSource.getAllRounds();
  }
}
