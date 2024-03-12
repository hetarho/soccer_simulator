import 'dart:math';

import 'package:soccer_simulator/entities/member.dart';
import 'package:soccer_simulator/entities/player_stat.dart';
import 'package:soccer_simulator/enum/stat.dart';
import 'package:soccer_simulator/enum/training_type.dart';
import 'package:soccer_simulator/enum/position.dart';

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
    _potential = potential ?? (Random().nextInt(120) + 30);
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

  ///추가로 상승시킬 스탯
  int extraStat = 0;

  ///경기에 출전할 포지션
  Position? position;

  ///선수의 컨디션
  double condition = 1;

  ///골
  int goal = 0;

  /// 어시스트
  int assist = 0;

  /// 수비 성공
  int defSuccess = 0;

  /// 선방
  int saveSuccess = 0;

  List<List<int>> seasonRecord = [];

  addExtraStat(int point) {
    extraStat += point;
  }

  //시즌 데이터 저장
  _saveSeason() {
    seasonRecord.add([goal, assist, defSuccess, saveSuccess]);
  }

  newSeason() {
    _saveSeason();
    goal = 0;
    assist = 0;
    defSuccess = 0;
    saveSuccess = 0;
  }

  /// 트레이팅, 게임시 성장할 수 있는 스텟
  late int _potential;

  ///선수를 트레이닝 시켜서 알고리즘에 따라 선수 능력치를 향상시키는 메소드
  ///
  ///[coachAbility]
  ///
  /// ~0.2 하급 코치
  ///
  /// ~0.4 중급 코치
  ///
  /// ~0.6 고급 코치
  ///
  /// ~ 0.8 엘리트 코치
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

      int personalGrowPoint = personalSuccessPercent ~/ (Random().nextDouble() + 0.03);
      int teamGrowPoint = teamSuccessPercent ~/ (Random().nextDouble() + 0.03);

      if (teamGrowPoint > 0 && _potential / 20 > Random().nextDouble()) {
        _potential -= 1;
        PlayerStat newStat = PlayerStat.training(
          type: teamTrainingTypes,
          point: teamGrowPoint,
        );
        _stat.add(newStat);
        _stat.add(PlayerStat(organization: 1));
      }
      if (personalGrowPoint > 0 && _potential / 20 > Random().nextDouble()) {
        _potential -= 1;
        PlayerStat newStat = PlayerStat.training(
          type: personalTrainingTypes,
          point: personalGrowPoint,
        );
        _stat.add(newStat);
      }
    }
  }

  ///선수의 특정 능력치를 향상시켜주는 메소드
  void addStat(Stat stat, int point) {
    int newPoint = min(extraStat, point);
    PlayerStat newStat = switch (stat) {
      Stat.dribble => PlayerStat(dribble: newPoint),
      Stat.intercept => PlayerStat(intercept: newPoint),
      Stat.jump => PlayerStat(jump: newPoint),
      Stat.keyPass => PlayerStat(keyPass: newPoint),
      Stat.longPass => PlayerStat(longPass: newPoint),
      Stat.organization => PlayerStat(organization: newPoint),
      Stat.physical => PlayerStat(physical: newPoint),
      Stat.reorientation => PlayerStat(reorientation: newPoint),
      Stat.sQ => PlayerStat(sQ: newPoint),
      Stat.save => PlayerStat(save: newPoint),
      Stat.shoot => PlayerStat(shoot: newPoint),
      Stat.shootAccuracy => PlayerStat(shootAccuracy: newPoint),
      Stat.shootPower => PlayerStat(shootPower: newPoint),
      Stat.shortPass => PlayerStat(shortPass: newPoint),
      Stat.speed => PlayerStat(speed: newPoint),
      Stat.stamina => PlayerStat(stamina: newPoint),
      Stat.tackle => PlayerStat(tackle: newPoint),
    };
    _stat.add(newStat);
    extraStat -= newPoint;
  }

  ///실제 경기를 뛰면서 발생하는 스텟 성장 - 출전 포지션에 따라 다르게 성장
  void playGame() {
    //남은 포텐셜이 0보다 커야 성장 가능, 30이상이면 경기시마다 항상 성장
    if (_potential / 30 > Random().nextDouble() && position != null) {
      if (Random().nextDouble() > 0.7) _potential -= 1;
      PlayerStat newStat = PlayerStat.playGame(position: position!, point: Random().nextInt(3));
      _stat.add(newStat);
    }
  }
}
