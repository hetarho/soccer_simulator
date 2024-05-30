import 'package:soccer_simulator/domain/entities/player/player.dart';
import 'package:soccer_simulator/domain/enum/player_action.enum.dart';

///플레이어가 어떤 행동을 할 때마다 발생할 이벤트 VO
class PlayerActEvent {
  final Player player;
  final PlayerAction action;
  PlayerActEvent({
    required this.player,
    required this.action,
  });
}
