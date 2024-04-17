class Tactics {
  Tactics({required this.pressDistance});
  Tactics.none({
    this.pressDistance = 0,
  });
  Tactics.normal({
    this.pressDistance = 10,
  });

  final double pressDistance;
}
