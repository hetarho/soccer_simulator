import 'dart:math';

import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/enum/stat.dart';
import 'package:soccer_simulator/enum/training_type.dart';

/// 플레이어의 스텟
///
/// 10 ~ 30 유소년
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

  @override
  toString() {
    return '''
    stamina = $stamina
organization = $organization
physical = $physical
speed = $speed
jump = $jump
dribble = $dribble
shoot = $shoot
shootAccuracy = $shootAccuracy
shootPower = $shootPower
tackle = $tackle
shortPass = $shortPass
longPass = $longPass
save = $save
intercept = $intercept
reorientation = $reorientation
keyPass = $keyPass
sQ = $sQ''';
  }

  PlayerStat.create({
    int seed = 15,
    int potential = 40,
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
    this.stamina = stamina ?? seed + Random().nextInt(potential);
    this.organization = organization ?? seed + Random().nextInt(potential);
    this.physical = physical ?? seed + Random().nextInt(potential);
    this.speed = speed ?? seed + Random().nextInt(potential);
    this.jump = jump ?? seed + Random().nextInt(potential);
    this.dribble = dribble ?? seed + Random().nextInt(potential);
    this.shoot = shoot ?? seed + Random().nextInt(potential);
    this.shootAccuracy = shootAccuracy ?? seed + Random().nextInt(potential);
    this.shootPower = shootPower ?? seed + Random().nextInt(potential);
    this.tackle = tackle ?? seed + Random().nextInt(potential);
    this.shortPass = shortPass ?? seed + Random().nextInt(potential);
    this.longPass = longPass ?? seed + Random().nextInt(potential);
    this.save = save ?? seed + Random().nextInt(potential);
    this.intercept = intercept ?? seed + Random().nextInt(potential);
    this.reorientation = reorientation ?? seed + Random().nextInt(potential);
    this.keyPass = keyPass ?? seed + Random().nextInt(potential);
    this.sQ = sQ ?? seed + Random().nextInt(potential);
  }

  ///훈련시 상승시킬 능력치
  PlayerStat.training({
    required List<TrainingType> type,
    required int point,
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
      Stat.reorientation,
    ];

    List targetList = [
      if (type.contains(TrainingType.att)) ...attStatList,
      if (type.contains(TrainingType.physical)) ...physicalStatList,
      if (type.contains(TrainingType.def)) ...defStatList,
      if (type.contains(TrainingType.pass)) ...passStatList,
      if (type.contains(TrainingType.save)) Stat.save,
      Stat.sQ
    ];

    List.generate(point, (index) {
      targetList.shuffle();
      setPoint(targetList[0], point);
    });
  }

  ///게임 투입시 상승시킬 능력치
  PlayerStat.playGame({required Position position, required int point}) {
    List forwardList = [
      Stat.dribble,
      Stat.shoot,
      Stat.shootAccuracy,
      Stat.shootPower,
      Stat.sQ,
    ];

    List defenderList = [
      Stat.tackle,
      Stat.intercept,
      Stat.sQ,
    ];

    List midfielderList = [
      Stat.keyPass,
      Stat.longPass,
      Stat.shortPass,
      Stat.reorientation,
      Stat.sQ,
    ];

    List targetList = switch (position) {
      Position.forward => forwardList,
      Position.midfielder => midfielderList,
      Position.defender => defenderList,
      _ => [],
    };

    List.generate(point, (index) {
      targetList.shuffle();
      setPoint(targetList[0], point);
    });
  }

  setPoint(Stat stat, int point) {
    switch (stat) {
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

  int get attOverall {
    if (dribble == null || shoot == null || shootAccuracy == null || keyPass == null || longPass == null || speed == null || shortPass == null || shootPower == null) {
      return 0;
    } else {
      return ((dribble! + shoot! + shootAccuracy! + shootPower! + keyPass! + speed! + longPass! + shortPass!) / 8 + (sQ ?? 0) / 10).round();
    }
  }

  int get midOverall {
    if (intercept == null || dribble == null || keyPass == null || longPass == null || shortPass == null || shootPower == null) {
      return 0;
    } else {
      return ((dribble! + intercept! + shootPower! + keyPass! + longPass! + shortPass!) / 6 + (sQ ?? 0) / 10).round();
    }
  }

  int get defOverall {
    if (tackle == null || intercept == null || longPass == null || stamina == null || physical == null || shortPass == null) {
      return 0;
    } else {
      return ((tackle! + intercept! + longPass! + stamina! + physical! + shortPass!) / 6 + (sQ ?? 0) / 10).round();
    }
  }

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
