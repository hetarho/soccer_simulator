// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:soccer_simulator/entities/member.dart';

class Player extends Member {
  Player({
    required super.name,
    required super.birthDay,
    required super.national,
    required this.tall,
    required PlayerStat stat,
    this.personalTraningType = TraningType.normal,
    this.teamTraningType = TraningType.normal,
    this.teamTraningTypePercent = 0.5,
    this.position,
    double? potential,
  }) {
    _stat = stat;

    //포텐셜을 지정해주지 않으면 랜덤으로 책정
    if (potential != null) _potential = potential;
    _potential = Random().nextDouble();
  }

  ///선수의 키
  final double tall;

  //선수의 스텟
  late PlayerStat _stat;

  ///팀 트레이닝시 훈련 종류
  TraningType teamTraningType;

  ///개인 트레이닝 시 훈련 종류
  TraningType personalTraningType;

  ///팀 트레이닝 베율
  double teamTraningTypePercent;

  ///경기에 출전할 포지션
  Position? position;

  /// 선수의 잠재력
  late double _potential;

  ///선수를 트레이닝 시켜서 알고리즘에 따라 선수 능력치를 향상시키는 메소드
  void traning() {
    PlayerStat newStat = PlayerStat.init();
    _stat.add(newStat);
  }

  ///선수의 특정 능력치를 향상시켜주는 메소드
  void addStat(PlayerStat newStat) {
    _stat.add(newStat);
  }

  ///실제 경기를 뛰면서 발생하는 스텟 성장 - 출전 포지션에 따라 다르게 성장
  void playGame() {}
}

enum TraningType {
  normal,
  att,
  def,
  pass,
  physical,
}

enum Position {
  forward,
  midfielder,
  deffender,
  goalKeeper,
  subForward,
  subMidfielder,
  subDeffender,
  subGoalKeeper,
}

class PlayerStat {
  PlayerStat.init({
    this.organization = 0,
    this.physical = 0,
    this.speed = 0,
    this.jump = 0,
    this.dribble = 0,
    this.shoot = 0,
    this.shootPower = 0,
    this.tackle = 0,
    this.shortPass = 0,
    this.longPass = 0,
    this.save = 0,
    this.freeKick = 0,
    this.penaltyKick = 0,
    this.intersept = 0,
    this.reorientation = 0,
    this.keyPass = 0,
    this.sQ = 0,
  });

  ///트레이닝시 상승시킬 능력치
  PlayerStat.tragnig(TraningType type, double potential) {
    sQ = 1;
  }

  ///게임 투입시 상승시킬 능력치
  PlayerStat.playGame(Position position, double potential) {
    sQ = 1;
  }

  ///조직력
  int? organization;

  ///피지컬
  int? physical;

  ///스피드
  int? speed;

  ///점프력 - 헤딩 정확도 향상
  int? jump;

  ///드리블
  int? dribble;

  ///슈팅 파워 - 슈팅 파워가 클 수록 먼 거리에서 골 확률 증가
  int? shootPower;

  ///슛 - 슛 능력치가 높을수록 다양한 위치에서 슈팅 가능
  int? shoot;

  ///방향 전환
  int? reorientation;

  ///키패스
  int? keyPass;

  ///짧은 패스
  int? shortPass;

  ///긴 패스
  int? longPass;

  ///태클 - 상대방이 드리블시 볼 소유권 획득 가능
  int? tackle;

  ///가로채기 - 상대방이 패스시 볼 소유권 획득 가능
  int? intersept;

  ///프리킥
  int? freeKick;

  ///패널티킥
  int? penaltyKick;

  ///선방
  int? save;

  ///축구 지능
  int? sQ;

  ///새로운 스탯을 더하면 스텟이 올라가는 함수
  add(PlayerStat newStat) {}
}
