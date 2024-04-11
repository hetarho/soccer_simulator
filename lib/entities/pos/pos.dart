import 'dart:math';

class PosXY {
  double x = 0;
  double y = 0;
  PosXY(this.x, this.y);

  double distance(PosXY target) {
    return sqrt(pow(x - target.x, 2) + pow(y - target.y, 2));
  }

  @override
  String toString() {
    return 'x:$x y:$y';
  }
}
