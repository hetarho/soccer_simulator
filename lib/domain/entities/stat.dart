import 'dart:math';

import 'package:soccer_simulator/domain/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/domain/enum/position.enum.dart';
import 'package:soccer_simulator/domain/enum/training_type.enum.dart';
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
class Stat implements Jsonable {
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
    return '''
stamina:${stamina}
strength:${strength}
attSkill:${attSkill}
passSkill:${passSkill}
defSkill:${defSkill}
gkSkill:${gkSkill}
composure:${composure}
teamwork:${teamwork}
''';
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

    try {
      switch (role) {
        case PlayerRole.forward:
          this.attSkill += 30;
          this.defSkill = sqrt(this.defSkill).round() + 10;
          this.gkSkill -= 30;
          break;
        case PlayerRole.midfielder:
          this.passSkill += 30;
          this.defSkill -= 30;
          this.attSkill -= 30;
          this.gkSkill -= 30;
          break;
        case PlayerRole.defender:
          this.defSkill += 30;
          this.attSkill = sqrt(this.attSkill).round() + 10;
          this.gkSkill -= 30;
          break;
        case PlayerRole.goalKeeper:
          this.gkSkill += 30;
          this.passSkill -= 20;
          this.defSkill -= 20;
          this.attSkill -= 30;
          break;
        default:
          break;
      }
    } catch (e) {
      print(e);
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
        attSkill = R().getInt(max: point, min: 0);
        passSkill = R().getInt(max: point, min: 0);
        break;
      case PlayerRole.midfielder:
        attSkill = R().getInt(max: point, min: 0);
        passSkill = R().getInt(max: point, min: 0);
        defSkill = R().getInt(max: point, min: 0);
        break;
      case PlayerRole.defender:
        passSkill = R().getInt(max: point, min: 0);
        defSkill = R().getInt(max: point, min: 0);
        break;
      case PlayerRole.goalKeeper:
        gkSkill = R().getInt(max: point, min: 0);
      default:
    }
    teamwork = R().getInt(max: point, min: 0);
  }

  Stat.agingCurve({
    required int point,
    required PlayerRole role,
  }) {
    switch (role) {
      case PlayerRole.forward:
        attSkill = R().getInt(max: 0, min: point);
        passSkill = R().getInt(max: 0, min: point);
        break;
      case PlayerRole.midfielder:
        attSkill = R().getInt(max: 0, min: point);
        passSkill = R().getInt(max: 0, min: point);
        defSkill = R().getInt(max: 0, min: point);
        break;
      case PlayerRole.defender:
        passSkill = R().getInt(max: 0, min: point);
        defSkill = R().getInt(max: 0, min: point);
        break;
      case PlayerRole.goalKeeper:
        gkSkill = R().getInt(max: 0, min: point);
      default:
    }
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
    stamina = max(0, stamina + newStat.stamina);
    strength = max(0, strength + newStat.strength);
    attSkill = max(0, attSkill + newStat.attSkill);
    passSkill = max(0, passSkill + newStat.passSkill);
    defSkill = max(0, defSkill + newStat.defSkill);
    gkSkill = max(0, gkSkill + newStat.gkSkill);
    composure = max(0, composure + newStat.composure);
    teamwork = max(0, teamwork + newStat.teamwork);
  }

  int get average {
    return ((stamina + strength + attSkill + passSkill + passSkill + defSkill + gkSkill + composure + teamwork) / 9).round();
  }

  Stat.fromJson(Map<dynamic, dynamic> map) {
    stamina = map['stamina'];
    strength = map['strength'];
    attSkill = map['attSkill'];
    passSkill = map['passSkill'];
    defSkill = map['defSkill'];
    gkSkill = map['gkSkill'];
    composure = map['composure'];
    teamwork = map['teamwork'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'stamina': stamina,
      'strength': strength,
      'attSkill': attSkill,
      'passSkill': passSkill,
      'defSkill': defSkill,
      'gkSkill': gkSkill,
      'composure': composure,
      'teamwork': teamwork,
    };
  }
}
