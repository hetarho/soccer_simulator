import 'package:soccer_simulator/data/data_source/dto/club_dto.dart';
import 'package:soccer_simulator/data/repositories/interfaces/club_data_source.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';

class ClubRepository {
  final ClubDataSource dataSource;

  ClubRepository(this.dataSource);

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
      required int noWinStack}) {
    return dataSource.addClub(
        leagueId: leagueId,
        national: national,
        name: name,
        nickName: nickName,
        homeColor: homeColor,
        awayColor: awayColor,
        tactics: tactics,
        winStack: winStack,
        noLoseStack: noLoseStack,
        loseStack: loseStack,
        noWinStack: noWinStack);
  }

  Future<ClubDto?> getClub({required int id}) {
    return dataSource.getClub(id: id);
  }

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
      required int noWinStack}) {
    return dataSource.updateClub(
        id: id,
        leagueId: leagueId,
        national: national,
        name: name,
        nickName: nickName,
        homeColor: homeColor,
        awayColor: awayColor,
        tactics: tactics,
        winStack: winStack,
        noLoseStack: noLoseStack,
        loseStack: loseStack,
        noWinStack: noWinStack);
  }

  Future<int> deleteClub({required int id}) {
    return dataSource.deleteClub(id: id);
  }

  Future<List<ClubDto>> getAllClubs() {
    return dataSource.getAllClubs();
  }
}
