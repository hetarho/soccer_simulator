import 'dart:ui';

import 'package:soccer_simulator/domain/entities/club/club.dart';

class ClubInFixture {
  final int id;
  final Club club;
  Color uniformColor;
  int _scoredGoal = 0;
  int hasBallTime = 0;
  int shoot = 0;
  int pass = 0;
  int tackle = 0;
  int dribble = 0;

  score() {
    _scoredGoal += 1;
    club.currentSeasonStat.scored();
  }

  concede() {
    club.currentSeasonStat.conceded();
  }

  get goal {
    return _scoredGoal;
  }

  ClubInFixture({
    required this.id,
    required this.club,
    required this.uniformColor,
  });
}
