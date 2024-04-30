enum TrainingType {
  attSkill('attSkill'),
  passSkill('passSkill'),
  defSkill('defSkill'),
  gkSkill('gkSkill'),
  strength('strength'),
  stamina('stamina');

  final String text;
  const TrainingType(this.text);

// 문자열을 TrainingType 열거형으로 변환하는 함수
  static TrainingType fromString(String str) {
    return TrainingType.values.firstWhere((val) => val.text == str, orElse: () => throw ArgumentError('Invalid TrainingType string: $str'));
  }

  @override
  String toString() => text;
}
