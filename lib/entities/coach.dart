import 'package:soccer_simulator/entities/member.dart';

class Coach extends Member {
  Coach({
    required super.overall,
    required super.name,
    required super.birthDay,
    required this.playStyle,
  });

  final PlayStyle playStyle;
}

enum PlayStyle {
  pass, //패스 플레이 위주
  press, // 압박 위주
  counter, // 역습 위주
  none, // 기본
}
