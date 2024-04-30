import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/entities/fixture/fixture.dart';
import 'package:soccer_simulator/entities/league/season.dart';
import 'package:soccer_simulator/entities/player/player.dart';

class League implements Jsonable {
  List<Season> seasons = [];
  Season _currentSeason = Season(rounds: []);
  late List<Club> clubs;
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
        return a.nickName.compareTo(b.nickName);
      }
    });
    return clubs;
  }

  List<Player> get allPlayer => clubs.map((e) => e.players).expand((element) => element).toList();

  League.fromJson(Map<dynamic, dynamic> map) {
    seasons = (map['seasons'] as List).map((e) => Season.fromJson(e)).toList();
    _currentSeason = Season.fromJson(map['_currentSeason']);
    clubs = (map['clubs'] as List).map((e) => Club.fromJson(e)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'seasons': seasons.map((e) => e.toJson()).toList(),
      '_currentSeason': _currentSeason.toJson(),
      'clubs': clubs.map((e) => e.toJson()).toList(),
    };
  }
}
