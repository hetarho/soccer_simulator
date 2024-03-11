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
    this.personalTrainingTypes = const [
      TrainingType.att,
      TrainingType.def,
      TrainingType.pass,
      TrainingType.physical,
    ],
    this.teamTrainingTypePercent = 0.5,
    this.position,
    int? potential,
  }) {
    _stat = stat;

    //포텐셜을 지정해주지 않으면 랜덤으로 책정
    _potential = potential ?? (Random().nextInt(30) + 20);
  }

  PlayerStat get stat {
    return _stat;
  }

  int get potential {
    return _potential;
  }

  ///선수의 키
  final double tall;

  //선수의 스텟
  late PlayerStat _stat;

  ///개인 트레이닝 시 훈련 종류
  List<TrainingType> personalTrainingTypes;

  ///팀 트레이닝 베율
  double teamTrainingTypePercent;

  ///경기에 출전할 포지션
  Position? position;

  ///선수의 컨디션
  double condition = 1;

  /// 트레이팅, 게임시 성장할 수 있는 스텟
  late int _potential;

  ///선수를 트레이닝 시켜서 알고리즘에 따라 선수 능력치를 향상시키는 메소드
  void training({
    required double coachAbility,
    List<TrainingType> teamTrainingTypes = const [
      TrainingType.att,
      TrainingType.def,
      TrainingType.pass,
      TrainingType.physical,
    ],
  }) {
    //남은 포텐셜이 0보다 커야 성장 가능
    if (_potential > 0) {
      double personalSuccessPercent = coachAbility * (1 - teamTrainingTypePercent);
      double teamSuccessPercent = coachAbility * teamTrainingTypePercent;

      int personalGrowPoint = personalSuccessPercent ~/ (Random().nextDouble() + 0.1);
      int teamGrowPoint = teamSuccessPercent ~/ (Random().nextDouble() + 0.1);

      //성장 성공시 스텟 상승
      if (personalGrowPoint > 0 || teamGrowPoint > 0) {
        _potential -= 1;
      }
      if (teamGrowPoint > 0) {
        PlayerStat newStat = PlayerStat.training(
          type: teamTrainingTypes,
          point: teamGrowPoint,
          isTeamTraining: true,
        );
        _stat.add(newStat);
      }
      if (personalGrowPoint > 0) {
        PlayerStat newStat = PlayerStat.training(
          type: personalTrainingTypes,
          point: personalGrowPoint,
          isTeamTraining: false,
        );
        _stat.add(newStat);
      }
    }
  }

  ///선수의 특정 능력치를 향상시켜주는 메소드
  void addStat(PlayerStat newStat) {
    _stat.add(newStat);
  }

  ///실제 경기를 뛰면서 발생하는 스텟 성장 - 출전 포지션에 따라 다르게 성장
  void playGame() {
    //남은 포텐셜이 0보다 커야 성장 가능
    if (_potential > 0) {
      PlayerStat newStat = PlayerStat();
      _stat.add(newStat);
    }
  }
}

//선수 고유 속성
enum HiddenType {
  /// 하드워커 - 스테미너가 천천히 소진된다.
  hardWorker,

  ///천재 - 성장 확률이 대폭 상승한다
  genius,
}

enum TrainingType {
  att,
  def,
  pass,
  physical,
  save,
}

enum Position {
  forward,
  midfielder,
  defender,
  goalKeeper,
  subForward,
  subMidfielder,
  subDefender,
  subGoalKeeper,
}

/// 플레이어의 스텟
///
/// 0 ~ 30 유소년
///
/// 30 ~ 60 일반 선수
///
/// 60 ~ 90 중위권 에이스
///
/// 90 ~ 120 리그 탑급 플레이어
///
/// 120 ~ 월드클래스
class PlayerStat {
  PlayerStat({
    this.stamina,
    this.organization,
    this.physical,
    this.speed,
    this.jump,
    this.dribble,
    this.shoot,
    this.shootAccuracy,
    this.shootPower,
    this.tackle,
    this.shortPass,
    this.longPass,
    this.save,
    this.intercept,
    this.reorientation,
    this.keyPass,
    this.sQ,
  });

  PlayerStat.create({
    int? stamina,
    int? organization,
    int? physical,
    int? speed,
    int? jump,
    int? dribble,
    int? shoot,
    int? shootAccuracy,
    int? shootPower,
    int? tackle,
    int? shortPass,
    int? longPass,
    int? save,
    int? intercept,
    int? reorientation,
    int? keyPass,
    int? sQ,
  }) {
    this.stamina = stamina ?? 30 + Random().nextInt(30);
    this.organization = organization ?? 30 + Random().nextInt(30);
    this.physical = physical ?? 30 + Random().nextInt(30);
    this.speed = speed ?? 30 + Random().nextInt(30);
    this.jump = jump ?? 30 + Random().nextInt(30);
    this.dribble = dribble ?? 30 + Random().nextInt(30);
    this.shoot = shoot ?? 30 + Random().nextInt(30);
    this.shootAccuracy = shootAccuracy ?? 30 + Random().nextInt(30);
    this.shootPower = shootPower ?? 30 + Random().nextInt(30);
    this.tackle = tackle ?? 30 + Random().nextInt(30);
    this.shortPass = shortPass ?? 30 + Random().nextInt(30);
    this.longPass = longPass ?? 30 + Random().nextInt(30);
    this.save = save ?? 30 + Random().nextInt(30);
    this.intercept = intercept ?? 30 + Random().nextInt(30);
    this.reorientation = reorientation ?? 30 + Random().nextInt(30);
    this.keyPass = keyPass ?? 30 + Random().nextInt(30);
    this.sQ = sQ ?? 30 + Random().nextInt(30);
  }

  ///훈련시 상승시킬 능력치
  PlayerStat.training({
    required List<TrainingType> type,
    required int point,
    bool isTeamTraining = true,
  }) {
    List physicalStatList = [
      Stat.stamina,
      Stat.physical,
      Stat.speed,
      Stat.jump,
    ];

    List attStatList = [
      Stat.dribble,
      Stat.shoot,
      Stat.shootAccuracy,
      Stat.shootPower,
    ];

    List defStatList = [
      Stat.tackle,
      Stat.intercept,
    ];

    List passStatList = [
      Stat.keyPass,
      Stat.longPass,
      Stat.shortPass,
    ];

    List targetList = [
      if (type.contains(TrainingType.att)) ...attStatList,
      if (type.contains(TrainingType.physical)) ...physicalStatList,
      if (type.contains(TrainingType.def)) ...defStatList,
      if (type.contains(TrainingType.pass)) ...passStatList,
      if (type.contains(TrainingType.save)) Stat.save,
    ];

    List.generate(point, (index) {
      targetList.shuffle();
      switch (targetList[0]) {
        case Stat.stamina:
          stamina = point;
          break;
        case Stat.organization:
          organization = point;
          break;
        case Stat.physical:
          physical = point;
          break;
        case Stat.speed:
          speed = point;
          break;
        case Stat.jump:
          jump = point;
          break;
        case Stat.dribble:
          dribble = point;
          break;
        case Stat.shoot:
          shoot = point;
          break;
        case Stat.shootAccuracy:
          shootAccuracy = point;
          break;
        case Stat.shootPower:
          shootPower = point;
          break;
        case Stat.tackle:
          tackle = point;
          break;
        case Stat.shortPass:
          shortPass = point;
          break;
        case Stat.longPass:
          longPass = point;
          break;
        case Stat.save:
          save = point;
          break;
        case Stat.intercept:
          intercept = point;
          break;
        case Stat.reorientation:
          reorientation = point;
          break;
        case Stat.keyPass:
          keyPass = point;
          break;
        case Stat.sQ:
          sQ = point;
          break;
      }
    });
    if (isTeamTraining) organization = point;
  }

  ///게임 투입시 상승시킬 능력치
  PlayerStat.playGame(Position position, double successPercent) {
    sQ = 1;
  }

  ///조직력
  int? organization;

  ///체력
  int? stamina;

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

  ///슛정확도 - 골 확률 증가
  int? shootAccuracy;

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
  int? intercept;

  ///선방
  int? save;

  ///축구 지능
  int? sQ;

  ///새로운 스탯을 더하면 스텟이 올라가는 함수
  add(PlayerStat newStat) {
    stamina = (stamina ?? 0) + (newStat.stamina ?? 0);
    organization = (organization ?? 0) + (newStat.organization ?? 0);
    physical = (physical ?? 0) + (newStat.physical ?? 0);
    speed = (speed ?? 0) + (newStat.speed ?? 0);
    jump = (jump ?? 0) + (newStat.jump ?? 0);
    dribble = (dribble ?? 0) + (newStat.dribble ?? 0);
    shoot = (shoot ?? 0) + (newStat.shoot ?? 0);
    shootAccuracy = (shootAccuracy ?? 0) + (newStat.shootAccuracy ?? 0);
    shootPower = (shootPower ?? 0) + (newStat.shootPower ?? 0);
    tackle = (tackle ?? 0) + (newStat.tackle ?? 0);
    shortPass = (shortPass ?? 0) + (newStat.shortPass ?? 0);
    longPass = (longPass ?? 0) + (newStat.longPass ?? 0);
    save = (save ?? 0) + (newStat.save ?? 0);
    intercept = (intercept ?? 0) + (newStat.intercept ?? 0);
    reorientation = (reorientation ?? 0) + (newStat.reorientation ?? 0);
    keyPass = (keyPass ?? 0) + (newStat.keyPass ?? 0);
    sQ = (sQ ?? 0) + (newStat.sQ ?? 0);
  }
}

enum Stat {
  organization,

  stamina,
  physical,
  speed,
  jump,

  dribble,
  shoot,
  shootAccuracy,
  shootPower,

  shortPass,
  longPass,
  reorientation,
  keyPass,

  intercept,
  tackle,

  save,
  sQ,
}
