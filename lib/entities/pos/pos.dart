import 'dart:math';

import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/utils/random.dart';

class PosXY implements Jsonable {
  double _x = 0;
  double _y = 0;
  PosXY(double x, double y) {
    this.x = x;
    this.y = y;
  }

  double get x => _x;
  double get y => _y;

  set y(double newValue) {
    _y = newValue.clamp(_posYMinBoundary, _posYMaxBoundary);
  }

  set x(double newValue) {
    _x = newValue.clamp(_posXMinBoundary, _posXMaxBoundary);
  }

  double get _posYMaxBoundary => 200;
  double get _posYMinBoundary => 0;
  double get _posXMaxBoundary => 100;
  double get _posXMinBoundary => 0;

  PosXY.random(double x, double y, double ranNum) {
    this.x = (x + R().getDouble(min: -ranNum, max: ranNum));
    this.y = (y + R().getDouble(min: -ranNum, max: ranNum));
  }

  double distance(PosXY target) {
    return sqrt(pow(x - target.x, 2) + pow(y - target.y, 2));
  }

  @override
  String toString() {
    return 'x:$x y:$y';
  }

  PosXY.fromJson(Map<dynamic, dynamic> map) {
    _x = map['_x'];
    _y = map['_y'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_x': _x,
      '_y': _y,
    };
  }
}
