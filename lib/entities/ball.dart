import 'package:soccer_simulator/entities/player.dart';

class Ball {
  PosXY posXY = PosXY(50, 100);
  bool isMoving = false;
  PosXY? startPos;
  PosXY? endPos;
}
