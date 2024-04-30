import 'dart:math' as m;

import 'package:soccer_simulator/entities/formation/formation.dart';
import 'package:soccer_simulator/enum/national.enum.dart';
import 'package:soccer_simulator/enum/player.enum.dart';

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

  DateTime getDate({
    int? year,
    int? month,
    int? day,
  }) {
    DateTime now = DateTime.now();
    return DateTime(
      year ?? getInt(min: now.year - 35, max: now.year - 15),
      month ?? getInt(min: 1, max: 12),
      day ?? getInt(min: 1, max: 28),
    );
  }

  National getNational() {
    return National.values[getInt(max: National.values.length - 1)];
  }

  Formation getFormation() {
    List<Formation> formations = [
      Formation.create3241(),
      Formation.create352(),
      Formation.create41212(),
      Formation.create4141(),
      Formation.create4222(),
      Formation.create4231(),
      Formation.create433(),
      Formation.create442(),
      Formation.create532(),
    ];

    formations.shuffle();

    return formations.first;
  }
}
