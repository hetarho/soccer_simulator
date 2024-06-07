import 'package:soccer_simulator/data/data_source/dto/club_in_fixture_dto.dart';

abstract class ClubInFixtureDataSource {
  Future<int> addClubInFixture({required int fixtureId, required int clubId, required bool isHome, required int scoredGoal, required int hasBallTime, required int shoot, required int pass, required int tackle, required int dribble});
  Future<ClubInFixtureDto?> getClubInFixture({required int id});
  Future<int> updateClubInFixture({required int id, required int fixtureId, required int clubId, required bool isHome, required int scoredGoal, required int hasBallTime, required int shoot, required int pass, required int tackle, required int dribble});
  Future<int> deleteClubInFixture({required int id});
  Future<List<ClubInFixtureDto>> getAllClubInFixtures();
}