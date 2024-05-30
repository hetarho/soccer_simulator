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
  intercept('intercept'),
  keeping('keeping');

  final String text;
  const PlayerAction(this.text);

  // 문자열을 PlayerAction 열거형으로 변환하는 함수
  static PlayerAction fromString(String str) {
    return PlayerAction.values.firstWhere((val) => val.text == str, orElse: () => throw ArgumentError('Invalid PlayerAction string: $str'));
  }

  @override
  String toString() => text;
}
