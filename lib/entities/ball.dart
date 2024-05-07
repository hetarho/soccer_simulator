import 'package:soccer_simulator/entities/pos/pos.dart';

class Ball {
  PosXY posXY = PosXY(50, 100);
  double moveDistance = 0;
  bool isMoving = false;
  double get ballSpeed => moveDistance / 35;

  Ball();
}
