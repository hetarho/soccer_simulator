import 'package:soccer_simulator/data/data_source/dto/club_in_fixture_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/club_in_fixture_data_source.dart';

class ClubInFixtureRepository {
  final ClubInFixtureDataSource dataSource;

  ClubInFixtureRepository(this.dataSource);

  Future<int> addClubInFixture(
      {required int fixtureId,
      required int clubId,
      required bool isHome,
      required int scoredGoal,
      required int hasBallTime,
      required int shoot,
      required int pass,
      required int tackle,
      required int dribble}) {
    return dataSource.addClubInFixture(
        fixtureId: fixtureId, clubId: clubId, isHome: isHome, scoredGoal: scoredGoal, hasBallTime: hasBallTime, shoot: shoot, pass: pass, tackle: tackle, dribble: dribble);
  }

  Future<ClubInFixtureDto?> getClubInFixture({required int id}) {
    return dataSource.getClubInFixture(id: id);
  }

  Future<int> updateClubInFixture(
      {required int id,
      required int fixtureId,
      required int clubId,
      required bool isHome,
      required int scoredGoal,
      required int hasBallTime,
      required int shoot,
      required int pass,
      required int tackle,
      required int dribble}) {
    return dataSource.updateClubInFixture(
        id: id, fixtureId: fixtureId, clubId: clubId, isHome: isHome, scoredGoal: scoredGoal, hasBallTime: hasBallTime, shoot: shoot, pass: pass, tackle: tackle, dribble: dribble);
  }

  Future<int> deleteClubInFixture({required int id}) {
    return dataSource.deleteClubInFixture(id: id);
  }

  Future<List<ClubInFixtureDto>> getAllClubInFixtures() {
    return dataSource.getAllClubInFixtures();
  }
}
