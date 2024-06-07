import 'package:soccer_simulator/data/data_source/dto/club_dto.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';

abstract class ClubDataSource {
  Future<int> addClub(
      {required int leagueId,
      required National national,
      required String name,
      required String nickName,
      required int homeColor,
      required int awayColor,
      required String tactics,
      required int winStack,
      required int noLoseStack,
      required int loseStack,
      required int noWinStack});
  Future<ClubDto?> getClub({required int id});
  Future<int> updateClub(
      {required int id,
      required int leagueId,
      required National national,
      required String name,
      required String nickName,
      required int homeColor,
      required int awayColor,
      required String tactics,
      required int winStack,
      required int noLoseStack,
      required int loseStack,
      required int noWinStack});
  Future<int> deleteClub({required int id});
  Future<List<ClubDto>> getAllClubs();
}
