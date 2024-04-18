import 'dart:math';

import 'package:soccer_simulator/utils/random.dart';

class PosXY {
  double x = 0;
  double y = 0;
  PosXY(this.x, this.y);

  PosXY.random(double x, double y, double ranNum) {
    this.x = (x + R().getDouble(min: -ranNum, max: ranNum)).clamp(0, 100);
    this.y = (y + R().getDouble(min: -ranNum, max: ranNum)).clamp(0, 200);
  }

  double distance(PosXY target) {
    return sqrt(pow(x - target.x, 2) + pow(y - target.y, 2));
  }

  @override
  String toString() {
    return 'x:$x y:$y';
  }
}
