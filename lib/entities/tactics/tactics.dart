class Tactics {
  Tactics({
    required this.pressDistance,
    required this.freeLevel,
    required this.attackLevel,
  });
  Tactics.normal({
    this.pressDistance = 10,
    this.freeLevel = PlayLevel.middle,
    this.attackLevel = PlayLevel.middle,
  });

  final double pressDistance;
  final PlayLevel freeLevel;
  final PlayLevel attackLevel;
}

enum PlayLevel {
  min,
  low,
  middle,
  hight,
  max,
}
