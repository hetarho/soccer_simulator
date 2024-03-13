import 'dart:math';

import 'package:soccer_simulator/entities/club.dart';

class Fixture {
  final Club homeClub;
  final Club awayClub;

  Duration playTime = const Duration(seconds: 0);
  double homeTeamBallPercentage = 1;

  bool get isPlayed {
    return playTime.compareTo(const Duration(minutes: 90)) > 0;
  }

  ///0.01초 = 실제 1초
  Duration playSpeed = const Duration(milliseconds: 10);

  gameStart(Function callback) async {
    await _nextSec(callback);
  }

  _nextSec(Function callback) async {
    if (isPlayed) return;
    playTime = Duration(seconds: playTime.inSeconds + 10);
    homeTeamBallPercentage = min(max(0, homeTeamBallPercentage + (Random().nextDouble() * 0.2 - 0.1)), 1);
    callback(() {});
    await Future.delayed(playSpeed);
    await _nextSec(callback);
  }

  Fixture({required this.homeClub, required this.awayClub});
}
