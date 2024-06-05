// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:soccer_simulator/domain/entities/club/club.dart';
import 'package:soccer_simulator/domain/entities/league/round.dart';

class Season {
  Season({
    required this.id,
    int? roundNumber,
  }) {
    _roundNumber = roundNumber ?? 1;
  }
  final int id;
  List<Round> rounds = [];
  int _roundNumber = 1;

  seasonEnd(List<Club> clubs) {
    rounds = [];
  }

  bool get isSeasonEnd => roundNumber == rounds.length;

  int get roundNumber {
    return _roundNumber;
  }

  nextRound(List<Club> clubs) {
    if (_roundNumber < rounds.length) _roundNumber++;
  }

  Round get currentRound {
    return rounds.firstWhere((round) => round.number == _roundNumber);
  }

  ///TODO:외부로 이동
  // Season.create({required List<Club> clubs}) {
  //   clubs.shuffle();
  //   List<Round> newRounds = [];
  //   int n = clubs.length;
  //   // 각 클럽의 마지막 홈 경기 여부를 추적하는 맵
  //   Map<Club, bool> lastHomeGame = {for (var club in clubs) club: false};

  //   for (int roundNumber = 0; roundNumber < (n - 1) * 2; roundNumber++) {
  //     List<Fixture> fixtures = [];
  //     bool firstHalfRound = roundNumber < (n - 1);

  //     for (int i = 0; i < n / 2; i++) {
  //       Club homeClub = firstHalfRound ? clubs[i] : clubs[n - 1 - i];
  //       Club awayClub = firstHalfRound ? clubs[n - 1 - i] : clubs[i];

  //       // 홈과 원정 경기의 균형을 조정
  //       if (lastHomeGame[homeClub] == true && lastHomeGame[awayClub] == false) {
  //         // 만약 homeClub이 마지막 경기에서 홈 경기를 했다면, 이번 경기에서는 원정으로 설정
  //         Club temp = homeClub;
  //         homeClub = awayClub;
  //         awayClub = temp;
  //       }

  //       //TODO:id
  //       fixtures.add(Fixture(
  //         id: 1,
  //         home: ClubInFixture(id: 1, club: homeClub, uniformColor: homeClub.homeColor),
  //         away: ClubInFixture(id: 1, club: awayClub, uniformColor: awayClub.homeColor),
  //       ));
  //       // 마지막 홈 경기 여부 업데이트
  //       lastHomeGame[homeClub] = true;
  //       lastHomeGame[awayClub] = false;
  //     }

  //     fixtures.shuffle(); // 각 라운드 내 경기들의 순서를 랜덤하게 섞음

  //     //TODO: id
  //     newRounds.add(Round(id: 1, fixtures: fixtures, number: roundNumber + 1));

  //     // 클럽 리스트 업데이트 (라운드 로빈 로테이션)
  //     clubs.insert(1, clubs.removeLast());
  //   }

  //   // 나머지 코드는 이전과 동일하게 유지
  //   // 첫 번째 및 두 번째 반쪽 라운드들을 셔플하고 전체 라운드 리스트를 구성
  //   rounds = newRounds;
  // }
}
