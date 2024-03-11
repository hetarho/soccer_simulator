import 'package:soccer_simulator/entities/player.dart';

class Club {
  Club({required this.name});

  final String name;

  int pts = 0;
  int win = 0;
  int draw = 0;
  int lose = 0;

  List<Player> players = [];
}
