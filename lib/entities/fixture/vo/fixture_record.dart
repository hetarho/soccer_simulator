import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/enum/player_action.enum.dart';

class FixtureRecord implements Jsonable {
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

  FixtureRecord.fromJson(Map<dynamic, dynamic> map) {
    time = Duration(microseconds: map['time']);
    if (map['club'] != null) club = Club.fromJson(map['club']);
    action = PlayerAction.fromString(map['action']);
    if (map['player'] != null) player = Player.fromJson(map['player']);
    isGameEnd = map['isGameEnd'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'time': time.inMicroseconds,
      'club': club?.toJson(),
      'action': action.toString(),
      'player': player?.toJson(),
      'isGameEnd': isGameEnd,
    };
  }
}
