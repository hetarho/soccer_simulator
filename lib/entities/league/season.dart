// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/entities/fixture/club_in_fixture.dart';
import 'package:soccer_simulator/entities/fixture/fixture.dart';
import 'package:soccer_simulator/entities/league/round.dart';

class SeasonSnapShot implements Jsonable {
  late final Club club;
  late final int pts;
  late final int rank;
  SeasonSnapShot({
    required this.club,
    required this.pts,
    required this.rank,
  });
  
  SeasonSnapShot.fromJson(Map<dynamic, dynamic> map, List<Club> clubs) {
    club = Club.fromJson(map['club']);
    pts = map['pts'];
    rank = map['rank'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'club': club.toJson(),
      'pts': pts,
      'rank': rank,
    };
  }
}

class Season implements Jsonable {
  late List<Round> rounds;
  int _roundNumber = 1;
  List<Club> seasonRecords = [];

  List<List<SeasonSnapShot>> seasonSnapshots = [];

  _addSnapShot(List<Club> clubs) {
    int index = 1;
    seasonSnapshots.add(clubs
        .map((club) => SeasonSnapShot(
              club: club,
              pts: club.pts,
              rank: index++,
            ))
        .toList());
  }

  seasonEnd(List<Club> clubs) {
    _addSnapShot(clubs);
    seasonRecords = clubs;
    rounds = [];
  }

  bool get isSeasonEnd => roundNumber == rounds.length;

  int get roundNumber {
    return _roundNumber;
  }

  nextRound(List<Club> clubs) {
    if (_roundNumber < rounds.length) _roundNumber++;
    _addSnapShot(clubs);
  }

  Round get currentRound {
    return rounds.firstWhere((round) => round.number == _roundNumber);
  }

  Season.create({required List<Club> clubs}) {
    clubs.shuffle();
    List<Round> newRounds = [];
    int n = clubs.length;
    // 각 클럽의 마지막 홈 경기 여부를 추적하는 맵
    Map<Club, bool> lastHomeGame = {for (var club in clubs) club: false};

    for (int roundNumber = 0; roundNumber < (n - 1) * 2; roundNumber++) {
      List<Fixture> fixtures = [];
      bool firstHalfRound = roundNumber < (n - 1);

      for (int i = 0; i < n / 2; i++) {
        Club homeClub = firstHalfRound ? clubs[i] : clubs[n - 1 - i];
        Club awayClub = firstHalfRound ? clubs[n - 1 - i] : clubs[i];

        // 홈과 원정 경기의 균형을 조정
        if (lastHomeGame[homeClub] == true && lastHomeGame[awayClub] == false) {
          // 만약 homeClub이 마지막 경기에서 홈 경기를 했다면, 이번 경기에서는 원정으로 설정
          Club temp = homeClub;
          homeClub = awayClub;
          awayClub = temp;
        }

        fixtures.add(Fixture(home: ClubInFixture(club: homeClub), away: ClubInFixture(club: awayClub)));
        // 마지막 홈 경기 여부 업데이트
        lastHomeGame[homeClub] = true;
        lastHomeGame[awayClub] = false;
      }

      fixtures.shuffle(); // 각 라운드 내 경기들의 순서를 랜덤하게 섞음
      newRounds.add(Round(fixtures: fixtures, number: roundNumber + 1));

      // 클럽 리스트 업데이트 (라운드 로빈 로테이션)
      clubs.insert(1, clubs.removeLast());
    }

    // 나머지 코드는 이전과 동일하게 유지
    // 첫 번째 및 두 번째 반쪽 라운드들을 셔플하고 전체 라운드 리스트를 구성
    rounds = newRounds;
  }

  Season({required this.rounds});

  Season.fromJson(Map<dynamic, dynamic> map, List<Club> clubs) {
    rounds = (map['rounds'] as List).map((e) => Round.fromJson(e, clubs)).toList();
    _roundNumber = map['_roundNumber'];
    seasonRecords = (map['seasonRecords'] as List).map((e) => Club.fromJson(e)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'rounds': rounds.map((e) => e.toJson()).toList(),
      '_roundNumber': _roundNumber,
      'seasonRecords': seasonRecords.map((e) => e.toJson()).toList(),
    };
  }
}
