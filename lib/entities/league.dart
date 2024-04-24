import 'dart:async';

import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/entities/player/player.dart';

class League {
  List<Season> seasons = [];
  Season _currentSeason = Season(rounds: []);
  List<Club> clubs;
  League({required this.clubs});

  get round {
    return _currentSeason.roundNumber;
  }

  Season get currentSeason => _currentSeason;

  startNewSeason() {
    _currentSeason.seasonEnd(table.map((club) => Club.copy(club)).toList());
    int ranking = 0;
    for (var club in clubs) {
      club.startNewSeason(seasons.length, ranking++);
      for (var player in club.players) {
        player.newSeason();
      }
    }
    _currentSeason = Season.create(clubs: clubs);
    seasons.add(_currentSeason);
  }

  List<Fixture> getNextFixtures() {
    return _currentSeason.currentRound.fixtures;
  }

  nextRound() {
    if (_currentSeason.currentRound.isAllGameEnd) _currentSeason.nextRound();
  }

  List<Club> get table {
    clubs.sort((a, b) {
      if (a.pts != b.pts) {
        return b.pts - a.pts;
      } else if (a.gd != b.gd) {
        return b.gd - a.gd;
      } else if (a.gf != b.gf) {
        return b.gf - a.gf;
      } else {
        return a.name.compareTo(b.name);
      }
    });
    return clubs;
  }

  List<Player> get allPlayer => clubs.map((e) => e.players).expand((element) => element).toList();
}

class Round {
  final List<Fixture> fixtures;
  final int number;

  get isAllGameEnd {
    return fixtures.fold(true, (pre, curr) => curr.isGameEnd && pre);
  }

  Round({required this.fixtures, required this.number});
}

class Season {
  late List<Round> rounds;
  int _roundNumber = 1;
  List<Club> seasonRecords = [];

  seasonEnd(List<Club> clubs) {
    seasonRecords = clubs;
    rounds = [];
  }

  int get roundNumber {
    return _roundNumber;
  }

  nextRound() {
    if (_roundNumber < rounds.length) _roundNumber++;
  }

  Round get currentRound {
    return rounds.firstWhere((round) => round.number == _roundNumber);
  }

  bool get isEndSeason {
    return _roundNumber == rounds.length;
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
}
