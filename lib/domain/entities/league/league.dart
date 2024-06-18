// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:soccer_simulator/domain/entities/club/club.dart';
import 'package:soccer_simulator/domain/entities/fixture/fixture.dart';
import 'package:soccer_simulator/domain/entities/league/season.dart';
import 'package:soccer_simulator/domain/entities/player/player.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';

class League {
  League({
    required this.id,
    required this.name,
    required this.national,
    required this.level,
    required this.clubs,
    required this.seasons,
  });

  ///아이디
  final int id;

  ///리그 이름
  final String name;

  ///소속 국가
  final National national;

  ///몇부 리그인지 0 => 1부리그
  final int level;

  ///해당 리그에 소속된 클럽
  List<Club> clubs = [];

  /// 해당 리그의 시즌
  List<Season> seasons = [];

  ///승격, 강등으로 인한 클럽 교체
  changeClub({
    required List<Club> insertClub,
    required List<Club> removeClub,
  }) {
    clubs = [
      ...clubs.where((club) => !removeClub.contains(club.id)),
      ...insertClub,
    ];
  }

  ///리그가 몇라운드까지 진행됐는지
  int get round {
    return currentSeason.roundNumber;
  }

  ///리그의 현재 시즌
  Season get currentSeason => seasons.last;

  ///현재 시즌 종료
  endCurrentSeason() {
    // currentSeason.seasonEnd(table.map((club) => Club.save(club)).toList());
    // int ranking = 1;
    // for (var club in clubs) {
    //   club.startNewSeason(seasons.length, ranking++);
    //   for (var player in club.players) {
    //     player.newSeason();
    //   }
    // }
  }

  ///새 시즌 시작
  startNewSeason() {
    // if (!seasons.last.isSeasonEnd) return;
    // seasons.add(Season.create(clubs: clubs));
  }

  ///다음 경기 불러오기
  List<Fixture> getNextFixtures() {
    return currentSeason.currentRound.fixtures;
  }

  ///다음 라운드로
  nextRound() {}

  ///리그 테이블 불러오기
  List<Club> get table {
    // clubs.sort((a, b) {
    //   if (a.pts != b.pts) {
    //     return b.pts - a.pts;
    //   } else if (a.gd != b.gd) {
    //     return b.gd - a.gd;
    //   } else if (a.gf != b.gf) {
    //     return b.gf - a.gf;
    //   } else {
    //     return a.nickName.compareTo(b.nickName);
    //   }
    // });
    return clubs;
  }

  List<Player> get allPlayer => clubs.map((e) => e.players).expand((element) => element).toList();
}