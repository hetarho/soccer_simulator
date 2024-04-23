enum PlayerAction {
  none('none'),
  move('move'),
  shoot('shoot'),
  tackle('tackle'),
  pass('pass'),
  press('press'),
  dribble('dribble'),
  goal('goal'),
  assist('assist'),
  keeping('keeping');

  final String text;
  const PlayerAction(this.text);

  @override
  String toString() => text;
}
