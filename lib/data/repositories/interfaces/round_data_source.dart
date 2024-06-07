import 'package:soccer_simulator/data/data_source/dto/round_dto.dart';

abstract class RoundDataSource {
  Future<int> addRound({required int seasonId, required int number});
  Future<RoundDto?> getRound({required int id});
  Future<int> updateRound({required int id, required int seasonId, required int number});
  Future<int> deleteRound({required int id});
  Future<List<RoundDto>> getAllRounds();
}