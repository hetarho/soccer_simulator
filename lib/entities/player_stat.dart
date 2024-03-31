import 'dart:math';

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
class PlayerStat {
  PlayerStat({
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

  PlayerStat.random({
    int min = 15,
    int max = 40,
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
  }

  ///훈련시 상승시킬 능력치
  PlayerStat.training({
    required List<TrainingType> type,
    required int point,
  }) {}

  ///게임 투입시 상승시킬 능력치
  PlayerStat.playGame({required Position position, required int point}) {}

  ///체력
  late final int stamina;

  ///근력
  late final int strength;

  ///공격기술
  late final int attSkill;

  ///패스기술
  late final int passSkill;

  ///수비기술
  late final int defSkill;

  ///침착함
  late final int composure;

  ///조직력
  late final int teamwork;

  ///새로운 스탯을 더하면 스텟이 올라가는 함수
  add(PlayerStat newStat) {}
}
