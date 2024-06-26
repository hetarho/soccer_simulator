part of 'player.dart';

extension PlayerStat on Player {
  double get maxDistance => sqrt(speed) * 0.45 + 2.7;

  /// 슛능력치 - 축구지능 + 기술 + 근력 + 침착함 + 체력
  int get shootingStat {
    double res = soccerIQ * 0.15;
    res = res + stat.attSkill * 0.5;
    res = res + stat.strength * 0.1;
    res = res + stat.composure * 0.2;
    return res.round();
  }

  /// 중거리 슛 - 축구지능 + 기술 + 근력 + 침착함 + 체력
  int get midRangeShootStat {
    double res = soccerIQ * 0.2;
    res = res + stat.attSkill * 0.25;
    res = res + stat.strength * 0.45;
    res = res + stat.composure * 0.05;
    return res.round();
  }

  /// 키패스 - 축구지능 +  기술 + 근력 + 체력  + 침착함
  int get keyPassStat {
    double res = soccerIQ * 0.5;
    res = res + stat.passSkill * 0.4;
    res = res + stat.composure * 0.05;
    return res.round();
  }

  /// 짧은패스 - 축구지능 + 기술 + 조직력 + 침착함 + 체력
  int get shortPassStat {
    double res = soccerIQ * 0.3;
    res = res + stat.passSkill * 0.5;
    res = res + stat.teamwork * 0.01;
    res = res + stat.composure * 0.05;
    return res.round();
  }

  /// 롱패스 - 축구지능 + 체력 + 기술 + 근력 + 조직력 + 침착함
  int get longPassStat {
    double res = soccerIQ * 0.2;
    res = res + stat.passSkill * 0.5;
    res = res + stat.strength * 0.2;
    res = res + stat.composure * 0.05;
    return res.round();
  }

  /// 헤딩 - 축구지능  + 근력 +  키 +  기술 + 체력
  int get headerStat {
    double res = soccerIQ * 0.1;
    res = res + (height * 0.7) * 0.25;
    res = res + stat.strength * 0.25;
    res = res + stat.attSkill * 0.3;
    return res.round();
  }

  /// 드리블 - 축구지능 +  체형 + 반응속도 + 체력 + 유연성
  int get dribbleStat {
    double res = soccerIQ * 0.3;
    res = res + reflex * 0.2;
    res = res + stat.attSkill * 0.2;
    res = res + flexibility * 0.2;
    return res.round();
  }

  /// 탈압박 - 축구지능 + 반응속도 + 유연성 + 체력 + 침착함
  int get evadePressStat {
    double res = soccerIQ * 0.4;
    res = res + reflex * 0.25;
    res = res + flexibility * 0.1;
    res = res + stat.composure * 0.2;
    return res.round();
  }

  ///태클 - 축구지능 + 반응속도 + 체력 + 기술 + 침착함
  int get tackleStat {
    double res = soccerIQ * 0.1;
    res = res + stat.defSkill * 0.8;
    res = res + stat.composure * 0.05;
    return res.round();
  }

  ///인터셉트 - 축구지능 + 반응속도  +  수비기술
  int get interceptStat {
    double res = soccerIQ * 0.2;
    res = res + reflex * 0.1;
    res = res + stat.defSkill * 0.7;
    return res.round();
  }

  ///압박 - 축구지능 + 체력 + 조직력 + 침착함
  int get pressureStat {
    double res = soccerIQ * 0.35;
    res = res + stat.teamwork * 0.3;
    res = res + stat.composure * 0.05;
    return res.round();
  }

  ///침투 - 축구지능 + 반응속도 + 체력 + 근력 + 조직력
  int get penetrationStat {
    return 1;
  }

  ///판단력 - 축구지능 + 반응속도 + 체력 + 조직력 + 침착함
  int get judgementStat {
    double res = soccerIQ * 0.2;
    res = res + reflex * 0.2;
    res = res + stat.teamwork * 0.1;
    res = res + stat.composure * 0.3;
    return res.round();
  }

  ///시야 - 축구지능 + 체력  + 반응속도 + 침착함
  int get visionStat {
    double res = soccerIQ * 0.4;
    res = res + reflex * 0.1;
    res = res + stat.composure * 0.3;
    return res.round();
  }

  ///선방 - 키 + 축구지능 + 반응속도 + 유연성 + 골키퍼스킬 + 침착함
  int get keepingStat {
    double res = height * 0.15;
    res = res + soccerIQ * 0.1;
    res = res + reflex * 0.1;
    res = res + flexibility * 0.05;
    res = res + stat.gkSkill * 0.5;
    res = res + stat.composure * 0.1;
    return res.round();
  }

  double get tackleDistance => min(10, tackleStat / 10);
}
