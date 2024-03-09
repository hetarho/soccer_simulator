import 'package:soccer_simulator/enum/national.dart';

class Member {
  Member({
    required this.overall,
    required this.name,
    required this.birthDay,
    required this.national,
  });

  int overall;
  final String name;
  final DateTime birthDay;
  final National national;
}
