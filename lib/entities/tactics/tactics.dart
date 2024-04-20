class Tactics {
  Tactics({
    required this.pressDistance,
    required this.freeLevel,
  });
  Tactics.none({
    this.pressDistance = 0,
    this.freeLevel = PlayerFreeLevel.middle,
  });
  Tactics.normal({
    this.pressDistance = 10,
    this.freeLevel = PlayerFreeLevel.middle,
  });

  final double pressDistance;
  final PlayerFreeLevel freeLevel;
}

enum PlayerFreeLevel {
  min,
  low,
  middle,
  hight,
  max,
}
