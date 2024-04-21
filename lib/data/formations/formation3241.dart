import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/main.dart';

Formation formation3241 = Formation(positions: [
  PositionInFormation(pos: PosXY(50, 90), position: PlayerRole.forward),
  PositionInFormation(pos: PosXY(15, 70), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(40, 70), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(60, 70), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(85, 70), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(40, 50), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(60, 50), position: PlayerRole.midfielder),
  PositionInFormation(pos: PosXY(30, 30), position: PlayerRole.defender),
  PositionInFormation(pos: PosXY(50, 30), position: PlayerRole.defender),
  PositionInFormation(pos: PosXY(70, 30), position: PlayerRole.defender),
  PositionInFormation(pos: PosXY(50, 0), position: PlayerRole.goalKeeper),
]);
