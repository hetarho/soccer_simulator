enum PlayLevel {
  min('min'),
  low('low'),
  middle('middle'),
  hight('hight'),
  max('max');

  final String text;
  const PlayLevel(this.text);

  // 문자열을 PlayLevel 열거형으로 변환하는 함수
  static PlayLevel fromString(String levelString) {
    return PlayLevel.values.firstWhere((level) => level.text == levelString, orElse: () => throw ArgumentError('Invalid PlayLevel string: $levelString'));
  }

  @override
  String toString() => text;
}
