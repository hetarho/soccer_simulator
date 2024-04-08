// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:soccer_simulator/entities/ball.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/main.dart';
import 'package:uuid/uuid.dart';

import 'package:soccer_simulator/entities/member.dart';
import 'package:soccer_simulator/entities/player_stat.dart';
import 'package:soccer_simulator/enum/player.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/enum/training_type.dart';
import 'package:soccer_simulator/utils/random.dart';

class Player extends Member {
  Player({
    required super.name,
    required super.birthDay,
    required super.national,
    required this.backNumber,
    required PlayerStat stat,
    this.personalTrainingTypes = const [],
    this.teamTrainingTypePercent = 0.5,
    this.position,
    required this.height,
    required this.bodyType,
    required this.soccerIQ,
    required this.reflex,
    required this.flexibility,
    int? potential,
  }) {
    _stat = stat;

    //포텐셜을 지정해주지 않으면 랜덤으로 책정
    _potential = potential ?? R().getInt(min: 30, max: 120);
  }

  Player.random({
    required super.name,
    required super.birthDay,
    required super.national,
    required this.backNumber,
    required Position position,
    PlayerStat? stat,
    int? potential,
    double? height,
    BodyType? bodyType,
    int? soccerIQ,
    int? reflex,
    int? flexibility,
    this.personalTrainingTypes = const [],
    this.teamTrainingTypePercent = 0.5,
  }) {
    height = height ?? R().getDouble(min: 165, max: 210);
    bodyType = bodyType ?? R().getBodyType();
    soccerIQ = soccerIQ ?? R().getInt(min: 30, max: 120);
    reflex = reflex ?? R().getInt(min: 30, max: 120);
    flexibility = flexibility ?? R().getInt(min: 30, max: 120);
    _potential = potential ?? R().getInt(min: 30, max: 120);
    _stat = stat ?? PlayerStat.random(position: position);
  }

  final String id = const Uuid().v4();

  ///스타팅 멤버인지 여부
  bool isStartingPlayer = false;

  ///경기에서 현재 포지션
  PosXY posXY = PosXY(0, 0);

  ///스타팅 포지션
  PosXY _startingPoxXY = PosXY(0, 0);

  set startingPoxXY(PosXY newValue) {
    _startingPoxXY = newValue;
    posXY = newValue;
  }

  PosXY get startingPoxXY {
    return _startingPoxXY;
  }

  ///선수 스텟
  PlayerStat get stat {
    return _stat;
  }

  int get potential {
    return _potential;
  }

  ///등번호
  final int backNumber;

  ///키
  late final double height;

  ///체형
  late final BodyType bodyType;

  ///축구 지능
  late final int soccerIQ;

  ///반응 속도
  late final int reflex;

  ///유연성
  late final int flexibility;

  //선수의 스텟
  late final PlayerStat _stat;

  ///개인 트레이닝 시 훈련 종류
  List<TrainingType> personalTrainingTypes;

  ///팀 트레이닝 베율
  double teamTrainingTypePercent;

  ///추가로 상승시킬 스탯
  int _extraStat = 0;

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

  int get overall {
    return _stat.average;
  }

  List<List<int>> seasonRecord = [];

  Position get wantPosition {
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

  get extraStat {
    return _extraStat;
  }

  addExtraStat(int point) {
    _extraStat += point;
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
        PlayerStat newStat = PlayerStat.training(
          type: teamTrainingTypes,
          point: teamGrowPoint,
          isTeamTraining: true,
        );
        _stat.add(newStat);
        _stat.add(PlayerStat(teamwork: 1));
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
  void addStat(PlayerStat stat, int point) {
    _stat.add(stat);
    _extraStat -= point;
  }

  ///실제 경기를 뛰면서 발생하는 스텟 성장 - 출전 포지션에 따라 다르게 성장
  void _growAfterPlay() {
    //남은 포텐셜이 0보다 커야 성장 가능, 30이상이면 경기시마다 항상 성장
    if (_potential / 30 > Random().nextDouble()) {
      if (Random().nextDouble() > 0.7) _potential -= 1;
      PlayerStat newStat = PlayerStat.playGame(position: position ?? wantPosition, point: Random().nextInt(3));
      _stat.add(newStat);
    }
  }

  void resetPosXY() {
    posXY = startingPoxXY;
  }

  void gamePlayed() {
    resetPosXY();
    _growAfterPlay();
  }

  ///현재 공을 가지고 있는지 여부
  bool hasBall = false;

  actionWidthBall({
    required ClubInFixture team,
    required ClubInFixture opposite,
    required Ball ball,
    required Fixture fixture,
  }) {
    List<Player> teamPlayers = [...team.club.players.where((p) => p.id != id)];
    List<Player> oppositePlayers = opposite.club.players;

    ///슛으로 소유권을 상실했을 경우
    if (teamPlayers.where((player) => player.hasBall).isEmpty && !hasBall) {
      actionWithOutBall(team: team, opposite: opposite, ball: ball, fixture: fixture);
      return;
    }

    if (hasBall) {
      teamPlayers.sort((a, b) => a.posXY.distance(posXY) - b.posXY.distance(posXY) > 0 ? 1 : -1);
      int shootPercent = (200 / max(2, PosXY(50, 200).distance(posXY))).round();
      int passPercent = 50;
      int dribblePercent = 50;
      int ranNum = R().getInt(min: 0, max: shootPercent + passPercent + dribblePercent);

      if (ranNum < shootPercent) {
        shoot(fixture: fixture, team: team, opposite: opposite, goalKeeper: oppositePlayers.firstWhere((player) => player.position == Position.goalKeeper));
      } else if (ranNum < shootPercent + passPercent) {
        pass(R().getInt(max: 10, min: 0) > 8 ? teamPlayers.last : teamPlayers.first);
      } else if (ranNum < shootPercent + passPercent + dribblePercent) {
        dribble();
      } else {
        stayFront();
      }
    } else {
      int ranNum = R().getInt(min: 0, max: 100);
      switch (ranNum) {
        case < 100:
          stayFront();
          break;
        case < 5:
          break;
        case < 7:
          break;
        default:
          break;
      }
    }
  }

  actionWithOutBall({
    required ClubInFixture team,
    required ClubInFixture opposite,
    required Ball ball,
    required Fixture fixture,
  }) {
    List<Player> oppositePlayers = opposite.club.players;

    ///상대방의 공을 이미 배았았을 경우
    if (oppositePlayers.where((player) => player.hasBall).isEmpty) {
      actionWidthBall(team: team, opposite: opposite, ball: ball, fixture: fixture);
      return;
    }
    int ranNum = R().getInt(min: 0, max: 100);
    PosXY reversePos = PosXY(100 - posXY.x, 200 - posXY.y);
    bool canTackle = ball.posXY.distance(reversePos) < 10;

    Player playerWidthBall = oppositePlayers.firstWhere((player) => player.hasBall);

    if (canTackle) {
      switch (ranNum) {
        case < 30:
          stayBack();
          break;
        case < 100:
          tackle(playerWidthBall);
          break;
        case < 7:
          break;
        default:
          break;
      }
    } else {
      switch (ranNum) {
        case < 100:
          stayBack();
          break;
        case < 5:
          break;
        case < 7:
          break;
        default:
          break;
      }
    }
  }

  stayFront() {
    move(7, 2);
  }

  stayBack() {
    move(7, -2);
  }

  dribble() {
    move(10, 10);
  }

  pass(Player target) {
    hasBall = false;
    target.hasBall = true;
  }

  shoot({
    required Player goalKeeper,
    required Fixture fixture,
    required ClubInFixture team,
    required ClubInFixture opposite,
  }) {
    int ranNum = R().getInt(min: 0, max: 100);
    hasBall = false;
    goalKeeper.hasBall = true;

    if (ranNum < 10) {
      fixture.scored(
        scoredClub: team,
        concedeClub: opposite,
        scoredPlayer: this,
        assistPlayer: team.club.startPlayers[1],
      );
    }
  }

  buildUpPass() {}

  tackle(Player targetPlayer) {
    int ranNum = R().getInt(min: 0, max: 100);
    if (ranNum < 20) {
      targetPlayer.hasBall = false;
      hasBall = true;
    } else {}
  }

  press() {}

  move(double distance, [double frontAdditional = 0]) {
    double moveDistance = switch (position) {
      Position.forward => 10,
      Position.midfielder => 6,
      Position.defender => 3,
      Position.goalKeeper => 1,
      _ => 0,
    };

    double minX = max(0, startingPoxXY.x - 5 * moveDistance);
    double maxX = min(100, startingPoxXY.x + 5 * moveDistance);
    double minY = max(0, startingPoxXY.y - 4 * moveDistance);
    double maxY = min(200, startingPoxXY.y + 10 * moveDistance);

    posXY = PosXY(
      (posXY.x + R().getDouble(min: -1 * distance, max: distance)).clamp(minX, maxX),
      (posXY.y + R().getDouble(min: -1 * distance, max: distance) + frontAdditional).clamp(minY, maxY),
    );
  }
}

class PosXY {
  double x = 0;
  double y = 0;
  PosXY(this.x, this.y);

  double distance(PosXY target) {
    return sqrt(pow(x - target.x, 2) + pow(y - target.y, 2));
  }

  @override
  String toString() {
    return 'x:$x y:$y';
  }
}

//---타고난거

///키
///체형 - 마름 / 보통 / 건장
///축구지능
///반응속도
///유연성

//---훈련으로 바뀌는거

///체력
///근력
///기술

//---경기 경험으로 바뀌는 것

///침착함

//--경기 경험 + 훈련으로 바뀌는 것

///조직력

//온더볼

/// 슛 - 축구지능 + 기술 + 근력 + 침착함 + 체력
/// 중거리 슛 - 축구지능 + 기술 + 근력 + 침착함 + 체력
/// 키패스 - 축구지능 +  기술 + 근력 + 체력 + 조직력 + 침착함
/// 짧은패스 - 축구지능 + 기술 + 조직력 + 침착함
/// 롱패스 - 축구지능 + 체력 + 기술 + 근력 + 조직력 + 침착함
/// 헤딩 - 키 + 체형 + 기술 + 체력
/// 드리블 - 키 + 체형 + 축구지능 + 반응속도 + 치력 + 기술 + 유연성
/// 탈압박 - 축구지능 + 반응속도 + 유연성 + 체력 + 기술 + 침착함

//오프더볼

///태클 - 축구지능 + 반응속도 + 체형 + 체력 + 기술 + 침착함
///인터셉트 - 축구지능 + 반응속도  + 체력
///압박 - 축구지능 + 체력 + 조직력 + 침착함
///침투 - 축구지능 + 반응속도 + 체력 + 근력 + 조직력

//일반

///판단력 - 축구지능 + 반응속도 + 체력 + 조직력 + 침착함

//특수능력

///방향전환 - 판단력 + 축구 지능
///빌드업 - 짧은패스 + 롱패스
///반박자 빠른 슈팅 - 슛 + 반응속도
///아크로바틱 - 슛 + 유연성

///태클 마스터 - 태클 + 기술
///패스 마스터 - 짧은패스 + 롱패스 + 키패스 + 기술

