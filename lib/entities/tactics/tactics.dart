class Tactics {
  Tactics({
    required this.pressDistance,
    required this.freeLevel,
    required this.attackLevel,
    required this.shortPassLevel,
  });
  Tactics.normal({
    this.pressDistance = 10,
    this.attackLevel = PlayLevel.middle,
    this.shortPassLevel = PlayLevel.middle,
  }) {
    freeLevel = FreeLevel.normal();
  }

  late final double pressDistance;
  late final FreeLevel freeLevel;
  late final PlayLevel attackLevel;
  late final PlayLevel shortPassLevel;
}

class FreeLevel {
  late final PlayLevel forward;
  late final PlayLevel backward;
  late final PlayLevel left;
  late final PlayLevel right;

  FreeLevel(this.forward, this.backward, this.left, this.right);

  FreeLevel.normal() {
    forward = PlayLevel.middle;
    backward = PlayLevel.middle;
    left = PlayLevel.middle;
    right = PlayLevel.middle;
  }
}

enum PlayLevel {
  min,
  low,
  middle,
  hight,
  max,
}
