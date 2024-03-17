import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/fixture.dart';

class League {
  List<Season> seasons = [];
  Season _currentSeason = Season(rounds: []);
  List<Club> clubs;
  League({required this.clubs});

  set gameCallback(Function function) {
    _currentSeason.gameCallback = function;
  }

  get round {
    return _currentSeason.roundNumber;
  }

  startNewSeason() {
    _currentSeason = Season.create(clubs: clubs);
  }

  List<Fixture> nextFixtures() {
    return _currentSeason.nextRound().fixtures;
  }

  nextRound() {
    _currentSeason.roundNumber++;
  }
}

class Round {
  final List<Fixture> fixtures;
  final int number;

  Round({required this.fixtures, required this.number});
}

class Season {
  late List<Round> rounds;
  int roundNumber = 1;
  Function? gameCallback;

  Round nextRound() {
    return rounds.firstWhere((round) => round.number == roundNumber);
  }

  Season.create({required List clubs}) {
    List<Round> newRounds = [];

    int n = clubs.length;

    for (int roundNumber = 0; roundNumber < (n - 1) * 2; roundNumber++) {
      List<Fixture> fixtures = [];

      bool firstHalfRound = roundNumber < (n - 1);

      for (int i = 0; i < n / 2; i++) {
        if (firstHalfRound) {
          fixtures.add(Fixture(homeClub: clubs[i], awayClub: clubs[n - 1 - i])
            ..gameStream.listen((event) {
              if (gameCallback != null) gameCallback!();
              if (event) {
                for (var players in clubs[i].startPlayers) {
                  players.growAfterPlay();
                }
                for (var players in clubs[n - 1 - i].startPlayers) {
                  players.growAfterPlay();
                }
              }
            }));
        } else {
          fixtures.add(Fixture(homeClub: clubs[n - 1 - i], awayClub: clubs[i])
            ..gameStream.listen((event) {
              if (gameCallback != null) gameCallback!();
              if (event) {
                for (var players in clubs[n - 1 - i].startPlayers) {
                  players.growAfterPlay();
                }
                for (var players in clubs[i].startPlayers) {
                  players.growAfterPlay();
                }
              }
            }));
        }
      }

      newRounds.add(Round(fixtures: fixtures, number: roundNumber + 1));
      fixtures = [];

      clubs.insert(1, clubs.removeLast());
    }
    List<Round> firstHalfRounds =
        newRounds.sublist(0, (newRounds.length / 2).round());
    List<Round> secondHalfRounds =
        newRounds.sublist((newRounds.length / 2).round());

    firstHalfRounds.shuffle();
    secondHalfRounds.shuffle();

    rounds = [...firstHalfRounds, ...secondHalfRounds];
  }

  Season({required this.rounds});
}
