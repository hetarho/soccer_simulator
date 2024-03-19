import 'package:soccer_simulator/entities/player.dart';
import 'package:uuid/uuid.dart';

class Club {
  Club({required this.name});

  final String id = const Uuid().v4();
  final String name;

  bool hasBall = false;

  int won = 0;
  int drawn = 0;
  int lost = 0;

  int winStack = 0;
  int noLoseStack = 0;
  int loseStack = 0;
  int noWinStack = 0;

  int gf = 0;
  int ga = 0;
  int gd = 0;

  int get pts {
    return won * 3 + drawn;
  }

  win() {
    won++;
    winStack++;
    noLoseStack++;
    loseStack = 0;
    noWinStack = 0;
  }

  lose() {
    lost++;
    noWinStack++;
    loseStack++;
    winStack = 0;
    noLoseStack = 0;
  }

  draw() {
    drawn++;
    noWinStack++;
    noLoseStack++;
    winStack = 0;
    loseStack = 0;
  }

  newSeason() {
    won = 0;
    drawn = 0;
    lost = 0;
  }

  int get attOverall {
    return (startPlayers.fold(0, (pre, curr) => pre + curr.stat.attOverall) / 11).round();
  }

  int get midOverall {
    return (startPlayers.fold(0, (pre, curr) => pre + curr.stat.midOverall) / 11).round();
  }

  int get defOverall {
    return (startPlayers.fold(0, (pre, curr) => pre + curr.stat.defOverall) / 11).round();
  }

  int get overall {
    return ((attOverall + midOverall + defOverall) / 3).round();
  }

  List<Player> players = [];
  List<Player> startPlayers = [];
}
