import 'package:soccer_simulator/entities/fixture.dart';

class League {
  List<List<Fixture>> season = [];
  List<List<List<Fixture>>> fixtureRecord = [];

  List<List<Fixture>> _createFixtures({required List clubs}) {
    List<List<Fixture>> rounds = [];

    int n = clubs.length;

    for (int round = 0; round < (n - 1) * 2; round++) {
      List<Fixture> games = [];

      bool firstHalfRound = round < (n - 1);

      for (int i = 0; i < n / 2; i++) {
        if (firstHalfRound) {
          games.add(Fixture(homeClub: clubs[i], awayClub: clubs[n - 1 - i]));
        } else {
          games.add(Fixture(homeClub: clubs[n - 1 - i], awayClub: clubs[i]));
        }
      }

      rounds.add(games);
      games = [];

      clubs.insert(1, clubs.removeLast());
    }
    List<List<Fixture>> firstHalfRounds = rounds.sublist(0, (rounds.length / 2).round());
    List<List<Fixture>> secondHalfRounds = rounds.sublist((rounds.length / 2).round());

    firstHalfRounds.shuffle();
    secondHalfRounds.shuffle();

    return [...firstHalfRounds, ...secondHalfRounds];
  }
}
