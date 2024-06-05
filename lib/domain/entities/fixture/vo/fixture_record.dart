import 'package:soccer_simulator/domain/entities/club/club.dart';

import 'package:soccer_simulator/domain/entities/player/player.dart';
import 'package:soccer_simulator/domain/enum/player_action.enum.dart';

class FixtureRecord {
  late final Duration time;
  late final Club? club;
  late final PlayerAction? action;
  late final Player? player;
  late final bool isGameEnd;

  FixtureRecord({
    required this.time,
    required this.isGameEnd,
    this.club,
    this.action,
    this.player,
  });

  @override
  String toString() {
    return 'FixtureRecord(time: $time, club: ${club?.name}, action: $action, player: ${player?.name})';
  }
}
