import 'dart:math';

import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/enum/training_type.dart';
import 'package:soccer_simulator/utils/random.dart';

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
class Stat {
  Stat({
    int? stamina,
    int? strength,
    int? attSkill,
    int? passSkill,
    int? defSkill,
    int? gkSkill,
    int? composure,
    int? teamwork,
  }) {
    this.stamina = stamina ?? 0;
    this.strength = strength ?? 0;
    this.attSkill = attSkill ?? 0;
    this.passSkill = passSkill ?? 0;
    this.defSkill = defSkill ?? 0;
    this.gkSkill = gkSkill ?? 0;
    this.composure = composure ?? 0;
    this.teamwork = teamwork ?? 0;
  }

  @override
  toString() {
    return '''TODO''';
  }

  Stat.create({
    required int min,
    required int max,
    required PlayerRole role,
    int? stamina,
    int? strength,
    int? attSkill,
    int? passSkill,
    int? defSkill,
    int? gkSkill,
    int? composure,
    int? teamwork,
  }) {
    this.stamina = stamina ?? R().getInt(max: max, min: min);
    this.strength = strength ?? R().getInt(max: max, min: min);
    this.attSkill = attSkill ?? R().getInt(max: max, min: min);
    this.passSkill = passSkill ?? R().getInt(max: max, min: min);
    this.defSkill = defSkill ?? R().getInt(max: max, min: min);
    this.gkSkill = gkSkill ?? R().getInt(max: max, min: min);
    this.composure = composure ?? R().getInt(max: max, min: min);
    this.teamwork = teamwork ?? R().getInt(max: max, min: min);

    switch (role) {
      case PlayerRole.forward:
        this.attSkill += 60;
        this.defSkill = sqrt(this.defSkill).round();
        this.gkSkill -= 40;
        break;
      case PlayerRole.midfielder:
        this.passSkill += 60;
        this.defSkill -= 40;
        this.attSkill -= 40;
        this.gkSkill -= 40;
        break;
      case PlayerRole.defender:
        this.defSkill += 60;
        this.attSkill = sqrt(this.attSkill).round();
        this.gkSkill -= 40;
        break;
      case PlayerRole.goalKeeper:
        this.gkSkill += 40;
        this.passSkill -= 20;
        this.defSkill -= 20;
        this.attSkill -= 40;
        break;
      default:
        break;
    }
  }

  ///훈련시 상승시킬 능력치
  Stat.training({
    required List<TrainingType> type,
    required int point,
    bool isTeamTraining = false,
  }) {
    type.shuffle();
    TrainingType targetType = type[0];

    switch (targetType) {
      case TrainingType.attSkill:
        attSkill = R().getInt(max: 2, min: 1);
        break;
      case TrainingType.defSkill:
        defSkill = R().getInt(max: 2, min: 1);
        break;
      case TrainingType.passSkill:
        passSkill = R().getInt(max: 2, min: 1);
        break;
      case TrainingType.gkSkill:
        gkSkill = R().getInt(max: 2, min: 1);
        break;
      case TrainingType.stamina:
        stamina = R().getInt(max: 2, min: 1);
        break;
      case TrainingType.strength:
        strength = R().getInt(max: 2, min: 1);
        break;
    }

    if (isTeamTraining) teamwork = R().getInt(max: 2, min: 1);
  }

  ///게임 투입시 상승시킬 능력치
  Stat.playGame({
    required PlayerRole role,
    required int point,
  }) {
    switch (role) {
      case PlayerRole.forward:
        attSkill = point + R().getInt(max: point, min: 0);
        passSkill = point + R().getInt(max: point, min: 0);
        break;
      case PlayerRole.midfielder:
        attSkill = point + R().getInt(max: point, min: 0);
        passSkill = point + R().getInt(max: point, min: 0);
        defSkill = point + R().getInt(max: point, min: 0);
        break;
      case PlayerRole.defender:
        passSkill = point + R().getInt(max: point, min: 0);
        defSkill = point + R().getInt(max: point, min: 0);
        break;
      case PlayerRole.goalKeeper:
        gkSkill = point + R().getInt(max: point, min: 0);
      default:
    }
    teamwork = R().getInt(max: point, min: 0);
  }

  ///체력
  int stamina = 0;

  ///근력
  int strength = 0;

  ///공격기술
  int attSkill = 0;

  ///패스기술
  int passSkill = 0;

  ///수비기술
  int defSkill = 0;

  int gkSkill = 0;

  ///침착함
  int composure = 0;

  ///조직력
  int teamwork = 0;

  ///새로운 스탯을 더하면 스텟이 올라가는 함수 : TODO
  add(Stat newStat) {
    stamina = stamina + newStat.stamina;
    strength = strength + newStat.strength;
    attSkill = attSkill + newStat.attSkill;
    passSkill = passSkill + newStat.passSkill;
    defSkill = defSkill + newStat.defSkill;
    gkSkill = gkSkill + newStat.gkSkill;
    composure = composure + newStat.composure;
    teamwork = teamwork + newStat.teamwork;
  }

  int get average {
    return ((stamina + strength + attSkill + passSkill + passSkill + defSkill + gkSkill + composure + teamwork) / 9).round();
  }
}
