// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:soccer_simulator/entities/member.dart';
import 'package:soccer_simulator/enum/national.dart';

class Player extends Member {
  Player({
    required super.overall,
    required super.name,
    required super.birthDay,
    required this.tall,
    required this.national,
    required this.physical,
    required this.speed,
    required this.jump,
    required this.dribble,
    required this.shoot,
    required this.longShoot,
    required this.tackle,
    required this.shortPass,
    required this.longPass,
    required this.save,
    required this.freeKick,
    required this.penaltyKick,
    required this.sQ,
  });

  //고정 요소
  final double tall;
  final National national;

  //피지컬 스텟
  int physical;
  int speed;
  int jump;

  //기술 스텟
  int dribble;
  int shoot;
  int longShoot;
  int tackle;
  int shortPass;
  int longPass;
  int save;
  int freeKick;
  int penaltyKick;

  //축구 지능
  int sQ;
}