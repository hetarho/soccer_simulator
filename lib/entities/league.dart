import 'dart:async';

import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/fixture.dart';

class League {
  List<Season> seasons = [];
  Season _currentSeason = Season(rounds: []);
  List<Club> clubs;
  League({required this.clubs});

  get round {
    return _currentSeason.roundNumber;
  }

  startNewSeason() {
    _currentSeason = Season.create(clubs: clubs);
  }

  List<Fixture> getNextFixtures() {
    return _currentSeason.currentRound.fixtures;
  }

  nextRound() {
    if (_currentSeason.currentRound.isAllGameEnd) _currentSeason.nextRound();
  }
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
  late StreamController<bool> _streamController;
  Stream<bool> get gameStream => _streamController.stream;

  int get roundNumber {
    return _roundNumber;
  }

  nextRound() {
    if (_roundNumber < rounds.length) _roundNumber++;
  }

  Round get currentRound {
    return rounds.firstWhere((round) => round.number == _roundNumber);
  }

  bool get seasonEnd {
    return _roundNumber == rounds.length;
  }

  Season.create({required List clubs}) {
    List<Round> newRounds = [];

    int n = clubs.length;

    for (int roundNumber = 0; roundNumber < (n - 1) * 2; roundNumber++) {
      List<Fixture> fixtures = [];

      bool firstHalfRound = roundNumber < (n - 1);

      for (int i = 0; i < n / 2; i++) {
        if (firstHalfRound) {
          fixtures.add(Fixture(homeClub: clubs[i], awayClub: clubs[n - 1 - i]));
        } else {
          fixtures.add(Fixture(homeClub: clubs[n - 1 - i], awayClub: clubs[i]));
        }
      }

      fixtures.shuffle();

      newRounds.add(Round(fixtures: fixtures, number: roundNumber + 1));
      fixtures = [];

      clubs.insert(1, clubs.removeLast());
    }
    List<Round> firstHalfRounds = newRounds.sublist(0, (newRounds.length / 2).round());
    List<Round> secondHalfRounds = newRounds.sublist((newRounds.length / 2).round());

    firstHalfRounds.shuffle();
    secondHalfRounds.shuffle();

    rounds = [...firstHalfRounds, ...secondHalfRounds];
  }

  Season({required this.rounds});
}
