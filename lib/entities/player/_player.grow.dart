part of 'player.dart';

extension _PlayerGrow on Player {
  ///실제 경기를 뛰면서 발생하는 스텟 성장 - 출전 포지션에 따라 다르게 성장
  void _growAfterPlay() {
    //남은 포텐셜이 0보다 커야 성장 가능, 30이상이면 경기시마다 항상 성장
    if (_potential / 30 > Random().nextDouble()) {
      if (Random().nextDouble() > 0.7) _potential -= 1;
      PlayerStat newStat = PlayerStat.playGame(position: position ?? wantPosition, point: Random().nextInt(3));
      _stat.add(newStat);
    }
  }

  Position _getWantedPositionFromStat(PlayerStat stat) {
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
