import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/main.dart';

Formation formation4222 = Formation(positions: [
  PositionInFormation(pos: PosXY(40, 90), position: Position.forward),
  PositionInFormation(pos: PosXY(60, 90), position: Position.forward),
  PositionInFormation(pos: PosXY(15, 70), position: Position.midfielder),
  PositionInFormation(pos: PosXY(85, 70), position: Position.midfielder),
  PositionInFormation(pos: PosXY(40, 50), position: Position.midfielder),
  PositionInFormation(pos: PosXY(60, 50), position: Position.midfielder),
  PositionInFormation(pos: PosXY(15, 30), position: Position.defender),
  PositionInFormation(pos: PosXY(40, 30), position: Position.defender),
  PositionInFormation(pos: PosXY(60, 30), position: Position.defender),
  PositionInFormation(pos: PosXY(85, 30), position: Position.defender),
  PositionInFormation(pos: PosXY(50, 0), position: Position.goalKeeper),
]);
