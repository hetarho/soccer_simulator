import 'package:soccer_simulator/domain/enum/national.enum.dart';

abstract class Member {
  Member({
    required this.name,
    required this.birthDay,
    required this.national,
  });

  final String name;
  final DateTime birthDay;
  final National national;
}
