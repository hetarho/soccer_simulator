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
    int? composure,
    int? teamwork,
  }) {
    this.stamina = stamina ?? 0;
    this.strength = strength ?? 0;
    this.attSkill = attSkill ?? 0;
    this.passSkill = passSkill ?? 0;
    this.defSkill = defSkill ?? 0;
    this.composure = composure ?? 0;
    this.teamwork = teamwork ?? 0;
  }

  @override
  toString() {
    return '''TODO''';
  }

  Stat.createCBStat({required int min, required int max}) {
    stamina = R().getInt(max: max, min: min);
    strength = R().getInt(max: max + 10, min: min + 10);
    attSkill = R().getInt(max: max - 20, min: min - 20);
    passSkill = R().getInt(max: max - 20, min: min - 20);
    defSkill = R().getInt(max: max + 20, min: min + 20);
    composure = R().getInt(max: max + 10, min: min + 10);
  }

  Stat.random({
    int min = 15,
    int max = 40,
    required Position position,
    int? stamina,
    int? strength,
    int? attSkill,
    int? passSkill,
    int? defSkill,
    int? composure,
    int? teamwork,
  }) {
    this.stamina = stamina ?? R().getInt(max: max, min: min);
    this.strength = strength ?? R().getInt(max: max, min: min);
    this.attSkill = attSkill ?? R().getInt(max: max, min: min);
    this.passSkill = passSkill ?? R().getInt(max: max, min: min);
    this.defSkill = defSkill ?? R().getInt(max: max, min: min);
    this.composure = composure ?? R().getInt(max: max, min: min);
    this.teamwork = teamwork ?? R().getInt(max: max, min: min);

    switch (position) {
      case Position.forward:
        this.attSkill = attSkill ?? R().getInt(max: max + 30, min: min + 30);
        break;
      case Position.midfielder:
        this.passSkill = passSkill ?? R().getInt(max: max + 30, min: min + 30);
        break;
      case Position.defender:
        this.defSkill = defSkill ?? R().getInt(max: max + 30, min: min + 30);
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
    required Position position,
    required int point,
  }) {
    switch (position) {
      case Position.forward:
        attSkill = R().getInt(max: 2, min: 0);
        passSkill = R().getInt(max: 2, min: 0);
        break;
      case Position.midfielder:
        attSkill = R().getInt(max: 2, min: 0);
        passSkill = R().getInt(max: 2, min: 0);
        defSkill = R().getInt(max: 2, min: 0);
        break;
      case Position.defender:
        passSkill = R().getInt(max: 2, min: 0);
        defSkill = R().getInt(max: 2, min: 0);
        break;
      default:
    }
    teamwork = R().getInt(max: 2, min: 0);
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
    composure = composure + newStat.composure;
    teamwork = teamwork + newStat.teamwork;
  }

  int get average {
    return ((stamina + strength + attSkill + passSkill + passSkill + defSkill + composure + teamwork) / 8).round();
  }
}
