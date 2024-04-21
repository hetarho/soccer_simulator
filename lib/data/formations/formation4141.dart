import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/main.dart';

Formation formation4141 = Formation(positions: [
  PositionInFormation(pos: PosXY(50, 90), position: PlayerRole.forward),
  PositionInFormation(pos: PosXY(15, 70), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(40, 70), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(60, 70), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(85, 70), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(50, 50), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(15, 30), position: PlayerRole.defender),
  PositionInFormation(pos: PosXY(40, 30), position: PlayerRole.defender),
  PositionInFormation(pos: PosXY(60, 30), position: PlayerRole.defender),
  PositionInFormation(pos: PosXY(85, 30), position: PlayerRole.defender),
  PositionInFormation(pos: PosXY(50, 0), position: PlayerRole.goalKeeper),
]);
