part of 'player.dart';

extension PlayerGrow on Player {
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
  void growAfterTraining({
    required double coachAbility,
    required List<TrainingType> teamTrainingTypes,
  }) {
    //남은 포텐셜이 0보다 커야 성장 가능
    if (_potential > 0) {
      double personalSuccessPercent = coachAbility * (1 - teamTrainingTypePercent);
      double teamSuccessPercent = coachAbility * teamTrainingTypePercent;

      int personalGrowPoint = personalSuccessPercent ~/ (Random().nextDouble() + 0.03);
      int teamGrowPoint = teamSuccessPercent ~/ (Random().nextDouble() + 0.03);

      if (teamGrowPoint > 0 && _potential / 20 > Random().nextDouble()) {
        _potential -= 1;
        Stat newStat = Stat.training(
          type: teamTrainingTypes,
          point: teamGrowPoint,
          isTeamTraining: true,
        );
        _stat.add(newStat);
        _stat.add(Stat(teamwork: 1));
      }
      if (personalGrowPoint > 0 && _potential / 20 > Random().nextDouble()) {
        _potential -= 1;
        Stat newStat = Stat.training(
          type: personalTrainingTypes,
          point: personalGrowPoint,
        );
        _stat.add(newStat);
      }
    }
  }

  ///실제 경기를 뛰면서 발생하는 스텟 성장 - 출전 포지션에 따라 다르게 성장
  void _growAfterPlay() {
    //남은 포텐셜이 0보다 커야 성장 가능, 30이상이면 경기시마다 항상 성장
    if (_potential / 30 > Random().nextDouble()) {
      if (Random().nextDouble() > 0.7) _potential -= 1;
      Stat newStat = Stat.playGame(position: position ?? wantPosition, point: Random().nextInt(2));
      _stat.add(newStat);
    }
  }

  Position _getWantedPositionFromStat(Stat stat) {
    List<int> statList = [stat.attSkill, stat.passSkill, stat.defSkill];
    statList.sort((a, b) => b - a);

    if (statList[0] == stat.attSkill) {
      return Position.forward;
    } else if (statList[0] == stat.passSkill) {
      return Position.midfielder;
    } else {
      return Position.defender;
    }
  }
}