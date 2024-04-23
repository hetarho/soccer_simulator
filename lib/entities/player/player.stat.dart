part of 'player.dart';

/// base stat
///
/// 키
/// 체형
/// 축구지능
/// 반응속도
/// 스피드
/// 유연성
///
/// 체력
/// 근력
/// 공격스킬
/// 패스스킬
/// 수비스킬
/// 침착함
/// 조직력
extension PlayerStat on Player {
  double get maxDistance => sqrt(speed) * 0.85 + 7;

  /// 슛능력치 - 축구지능 + 기술 + 근력 + 침착함 + 체력
  int get shootingStat {
    double res = soccerIQ * 0.15;
    res = res + stat.attSkill * 0.5;
    res = res + stat.strength * 0.1;
    res = res + stat.composure * 0.2;
    res = res + _currentStamina * 0.05;
    return res.round();
  }

  /// 중거리 슛 - 축구지능 + 기술 + 근력 + 침착함 + 체력
  int get midRangeShootStat {
    double res = soccerIQ * 0.1;
    res = res + stat.attSkill * 0.3;
    res = res + stat.strength * 0.5;
    res = res + stat.composure * 0.05;
    res = res + _currentStamina * 0.05;
    return res.round();
  }

  /// 키패스 - 축구지능 +  기술 + 근력 + 체력 + 조직력 + 침착함
  int get keyPassStat {
    return 1;
  }

  /// 짧은패스 - 축구지능 + 기술 + 조직력 + 침착함
  int get shortPassStat {
    return 1;
  }

  /// 롱패스 - 축구지능 + 체력 + 기술 + 근력 + 조직력 + 침착함
  int get longPassStat {
    return 1;
  }

  /// 헤딩 - 키 + 체형 + 기술 + 체력
  int get headerStat {
    return 1;
  }

  /// 드리블 - 키 + 체형 + 축구지능 + 반응속도 + 체력 + 기술 + 유연성
  int get dribbleStat {
    return 1;
  }

  /// 탈압박 - 축구지능 + 반응속도 + 유연성 + 체력 + 침착함
  int get evadePressStat {
    double res = soccerIQ * 0.4;
    res = res + reflex * 0.25;
    res = res + flexibility * 0.1;
    res = res + _currentStamina * 0.05;
    res = res + stat.composure * 0.2;
    return res.round();
  }

  ///태클 - 축구지능 + 반응속도 + 체력 + 기술 + 침착함
  int get tackleStat {
    double res = soccerIQ * 0.1;
    res = res + reflex * 0.1;
    res = res + _currentStamina * 0.05;
    res = res + stat.defSkill * 0.7;
    res = res + stat.composure * 0.05;
    return res.round();
  }

  ///인터셉트 - 축구지능 + 반응속도  + 체력
  int get interceptStat {
    return 1;
  }

  ///압박 - 축구지능 + 체력 + 조직력 + 침착함
  int get pressureStat {
    double res = soccerIQ * 0.35;
    res = res + _currentStamina * 0.3;
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
    double res = soccerIQ * 0.3;
    res = res + reflex * 0.2;
    res = res + _currentStamina * 0.2;
    res = res + stat.teamwork * 0.1;
    res = res + stat.composure * 0.2;
    return res.round();
  }

  ///시야 - 축구지능 + 반응속도 + 침착함
  int get visionStat {
    double res = soccerIQ * 0.6;
    res = res + reflex * 0.3;
    res = res + stat.composure * 0.1;
    return res.round();
  }

  ///선방 - 키 + 축구지능 + 반응속도 + 유연성 + 수비스킬 + 침착함
  int get keepingStat {
    double res = height * 0.2;
    res = res + soccerIQ * 0.1;
    res = res + reflex * 0.5;
    res = res + flexibility * 0.05;
    res = res + stat.defSkill * 0.1;
    res = res + stat.composure * 0.05;
    return res.round();
  }
}
// 빌드업: buildUp
// 반박자빠른슈팅: quickReleaseShot
// 아크로바틱: acrobatic
