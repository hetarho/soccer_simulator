import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/main.dart';

Formation formation532 = Formation(positions: [
  PositionInFormation(pos: PosXY(40, 90), position: PlayerRole.forward),
  PositionInFormation(pos: PosXY(60, 90), position: PlayerRole.forward),
  PositionInFormation(pos: PosXY(30, 65), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(50, 65), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(70, 65), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(10, 30), position: PlayerRole.defender),
  PositionInFormation(pos: PosXY(30, 30), position: PlayerRole.defender),
  PositionInFormation(pos: PosXY(50, 30), position: PlayerRole.defender),
  PositionInFormation(pos: PosXY(70, 30), position: PlayerRole.defender),
  PositionInFormation(pos: PosXY(90, 30), position: PlayerRole.defender),
  PositionInFormation(pos: PosXY(50, 0), position: PlayerRole.goalKeeper),
]);
