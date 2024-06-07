import 'package:soccer_simulator/data/data_source/dto/fixture_dto.dart';

abstract class FixtureDataSource {
  Future<int> addFixture({required int roundId});
  Future<FixtureDto?> getFixture({required int id});
  Future<int> updateFixture({required int id, required int roundId});
  Future<int> deleteFixture({required int id});
  Future<List<FixtureDto>> getAllFixtures();
}