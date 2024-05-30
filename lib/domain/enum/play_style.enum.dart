enum PlayStyle {
  pass('pass'), //패스 플레이 위주
  press('press'), // 압박 위주
  counter('counter'), // 역습 위주
  none('none'); // 기본

  final String text;
  const PlayStyle(this.text);

  // 문자열을 PlayStyle 열거형으로 변환하는 함수
  static PlayStyle fromString(String str) {
    return PlayStyle.values.firstWhere((level) => level.text == str, orElse: () => throw ArgumentError('Invalid PlayStyle string: $str'));
  }

  @override
  String toString() => text;
}
