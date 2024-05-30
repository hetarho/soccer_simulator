//선수 고유 속성
enum PlayerHiddenType {
  normal('normal'),

  /// 하드워커 - 스테미너가 천천히 소진된다.
  hardWorker('hardWorker'),

  ///천재 - 성장 확률이 대폭 상승한다
  genius('genius'),

  ///리더 - 같이 뛰는 동료들의 능력을 향상시킨다.
  leader('leader');

  final String text;
  const PlayerHiddenType(this.text);

  // 문자열을 PlayerHiddenType 열거형으로 변환하는 함수
  static PlayerHiddenType fromString(String str) {
    return PlayerHiddenType.values.firstWhere((val) => val.text == str, orElse: () => throw ArgumentError('Invalid PlayerHiddenType string: $str'));
  }

  @override
  String toString() => text;
}

enum BodyType {
  slim('slim'),
  normal('normal'),
  robust('robust');

  final String text;
  const BodyType(this.text);

  // 문자열을 BodyType 열거형으로 변환하는 함수
  static BodyType fromString(String str) {
    return BodyType.values.firstWhere((val) => val.text == str, orElse: () => throw ArgumentError('Invalid BodyType string: $str'));
  }

  @override
  String toString() => text;
}
