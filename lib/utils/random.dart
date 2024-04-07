import 'dart:math' as m;

import 'package:soccer_simulator/enum/player.dart';

class R {
  int getInt({
    int min = 0,
    int max = 0,
  }) {
    return m.Random().nextInt(m.max(max - min + 1, 0)) + min;
  }

  double getDouble({
    double min = 0,
    double max = 0,
  }) {
    return m.Random().nextDouble() * (m.max(max - min, 0)) + min;
  }

  BodyType getBodyType() {
    int num = m.Random().nextInt(3);
    return switch (num) {
      0 => BodyType.slim,
      1 => BodyType.normal,
      2 => BodyType.robust,
      _ => BodyType.normal,
    };
  }
}
