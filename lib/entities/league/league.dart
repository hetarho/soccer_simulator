import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/entities/fixture/fixture.dart';
import 'package:soccer_simulator/entities/league/season.dart';
import 'package:soccer_simulator/entities/player/player.dart';

class League implements Jsonable {
  List<Season> seasons = [];
  bool _seasonEnd = true;
  List<Club> clubs = [];
  late Season _currentSeason;
  League({required this.clubs}) {
    startNewSeason();
  }

  int get round {
    return _currentSeason.roundNumber;
  }

  Season get currentSeason => _currentSeason;

  endCurrentSeason() {
    _currentSeason.seasonEnd(table.map((club) => Club.save(club)).toList());
    int ranking = 1;
    for (var club in clubs) {
      club.startNewSeason(seasons.length, ranking++);
      for (var player in club.players) {
        player.newSeason();
      }
    }
    _seasonEnd = true;
  }

  startNewSeason() {
    if (!_seasonEnd) return;
    _currentSeason = Season.create(clubs: clubs);
    seasons.add(_currentSeason);
    _seasonEnd = false;
  }

  List<Fixture> getNextFixtures() {
    return _currentSeason.currentRound.fixtures;
  }

  nextRound() {
    if (_currentSeason.currentRound.isAllGameEnd) _currentSeason.nextRound(table.map((club) => Club.save(club)).toList());
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
    clubs = (map['clubs'] as List).map((e) => Club.fromJson(e)).toList();
    seasons = (map['seasons'] as List).map((e) => Season.fromJson(e, clubs)).toList();
    if (seasons.isNotEmpty) _currentSeason = seasons.last;
    _seasonEnd = map['_seasonEnd'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'seasons': seasons.map((e) => e.toJson()).toList(),
      '_seasonEnd': _seasonEnd,
      'clubs': clubs.map((e) => e.toJson()).toList(),
    };
  }
}
