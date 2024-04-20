import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/main.dart';

Formation formation433 = Formation(positions: [
  PositionInFormation(pos: PosXY(25, 90), position: Position.forward),
  PositionInFormation(pos: PosXY(50, 90), position: Position.forward),
  PositionInFormation(pos: PosXY(75, 90), position: Position.forward),
  PositionInFormation(pos: PosXY(25, 60), position: Position.midfielder),
  PositionInFormation(pos: PosXY(50, 60), position: Position.midfielder),
  PositionInFormation(pos: PosXY(75, 60), position: Position.midfielder),
  PositionInFormation(pos: PosXY(15, 30), position: Position.defender),
  PositionInFormation(pos: PosXY(40, 30), position: Position.defender),
  PositionInFormation(pos: PosXY(60, 30), position: Position.defender),
  PositionInFormation(pos: PosXY(85, 30), position: Position.defender),
  PositionInFormation(pos: PosXY(50, 0), position: Position.goalKeeper),
]);
