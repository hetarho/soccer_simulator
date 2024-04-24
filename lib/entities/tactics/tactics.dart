class Tactics {
  Tactics({
    required this.pressDistance,
    required this.freeLevel,
    required this.attackLevel,
    required this.shortPassLevel,
  });
  Tactics.normal({
    this.pressDistance = 10,
    this.freeLevel = PlayLevel.middle,
    this.attackLevel = PlayLevel.middle,
    this.shortPassLevel = PlayLevel.middle,
  });

  final double pressDistance;
  final PlayLevel freeLevel;
  final PlayLevel attackLevel;
  final PlayLevel shortPassLevel;
}

enum PlayLevel {
  min,
  low,
  middle,
  hight,
  max,
}
