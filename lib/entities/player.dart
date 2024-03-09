// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:soccer_simulator/entities/member.dart';

class Player extends Member {
  Player({
    required super.name,
    required super.birthDay,
    required super.national,
    required this.tall,
    required this.physical,
    required this.speed,
    required this.jump,
    required this.dribble,
    required this.shoot,
    required this.shootPower,
    required this.tackle,
    required this.shortPass,
    required this.longPass,
    required this.save,
    required this.freeKick,
    required this.penaltyKick,
    required this.intersept,
    required this.reorientation,
    required this.keyPass,
    required this.sQ,
  });

  //고정 요소
  final double tall;

  ///피지컬
  int physical;

  ///스피드
  int speed;

  ///점프력 - 헤딩 정확도 향상
  int jump;

  ///드리블
  int dribble;

  ///슈팅 파워 - 슈팅 파워가 클 수록 먼 거리에서 골 확률 증가
  int shootPower;

  ///슛 - 슛 능력치가 높을수록 다양한 위치에서 슈팅 가능
  int shoot;

  ///방향 전환
  int reorientation;

  ///키패스
  int keyPass;

  ///짧은 패스
  int shortPass;

  ///긴 패스
  int longPass;

  ///태클 - 상대방이 드리블시 볼 소유권 획득 가능
  int tackle;

  ///가로채기 - 상대방이 패스시 볼 소유권 획득 가능
  int intersept;

  ///프리킥
  int freeKick;

  ///패널티킥
  int penaltyKick;

  ///선방
  int save;

  ///축구 지능
  int sQ;
}
