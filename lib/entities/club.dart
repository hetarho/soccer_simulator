import 'package:soccer_simulator/entities/player.dart';

class Club {
  Club({required this.name});

  final String name;

  int win = 0;
  int draw = 0;
  int lose = 0;

  int get pts {
    return win * 3 + draw;
  }

  newSeason() {
    win = 0;
    draw = 0;
    lose = 0;
  }

  List<Player> players = [];
}
