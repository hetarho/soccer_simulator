import 'package:soccer_simulator/domain/enum/play_level.enum.dart';

class Tactics {
  Tactics({
    required this.pressDistance,
    required this.freeLevel,
    required this.attackLevel,
    required this.shortPassLevel,
    required this.dribbleLevel,
    required this.shootLevel,
  });
  Tactics.normal({
    this.pressDistance = 25,
    this.attackLevel = PlayLevel.middle,
    this.shortPassLevel = PlayLevel.middle,
    this.dribbleLevel = PlayLevel.middle,
    this.shootLevel = PlayLevel.middle,
  }) {
    freeLevel = FreeLevel.normal();
  }

  late double pressDistance;
  late FreeLevel freeLevel;
  late PlayLevel attackLevel;
  late PlayLevel shortPassLevel;

  ///상황을 드리블로 풀어나가는 비중
  late PlayLevel dribbleLevel;

  ///슛을 신중하게 하는지 여부
  late PlayLevel shootLevel;
}

class FreeLevel {
  late PlayLevel forward;
  late PlayLevel backward;
  late PlayLevel left;
  late PlayLevel right;

  FreeLevel(this.forward, this.backward, this.left, this.right);

  FreeLevel.normal() {
    forward = PlayLevel.middle;
    backward = PlayLevel.middle;
    left = PlayLevel.middle;
    right = PlayLevel.middle;
  }
}
