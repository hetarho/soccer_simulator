import 'package:soccer_simulator/entities/player.dart';

class Ground {
  Ground({required this.homePlayers, required this.awayPlayers});

  List<Player> homePlayers;
  List<Player> awayPlayers;
}
