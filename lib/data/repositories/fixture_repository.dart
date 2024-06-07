import 'package:soccer_simulator/data/data_source/dto/fixture_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/fixture_data_source.dart';

class FixtureRepository {
  final FixtureDataSource dataSource;

  FixtureRepository(this.dataSource);

  Future<int> addFixture({required int roundId}) {
    return dataSource.addFixture(roundId: roundId);
  }

  Future<FixtureDto?> getFixture({required int id}) {
    return dataSource.getFixture(id: id);
  }

  Future<int> updateFixture({required int id, required int roundId}) {
    return dataSource.updateFixture(id: id, roundId: roundId);
  }

  Future<int> deleteFixture({required int id}) {
    return dataSource.deleteFixture(id: id);
  }

  Future<List<FixtureDto>> getAllFixtures() {
    return dataSource.getAllFixtures();
  }
}
