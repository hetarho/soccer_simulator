import 'package:soccer_simulator/entities/pos/pos.dart';

class Ball {
  PosXY posXY = PosXY(50, 100);
  bool isMoving = false;
  PosXY? startPos;
  PosXY? endPos;
}
