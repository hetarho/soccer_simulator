// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:soccer_simulator/entities/ball.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:uuid/uuid.dart';

import 'package:soccer_simulator/entities/member.dart';
import 'package:soccer_simulator/entities/player_stat.dart';
import 'package:soccer_simulator/enum/player.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/enum/training_type.dart';
import 'package:soccer_simulator/utils/random.dart';

part '_player.action.dart';
part '_player.grow.dart';

class Player extends Member {
  late StreamController<PlayerAction> _streamController;
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
    _streamController = StreamController<PlayerAction>.broadcast();
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
    _streamController = StreamController<PlayerAction>.broadcast();
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

  ///슛 횟수
  int shooting = 0;

  ///골
  int goal = 0;

  /// 어시스트
  int assist = 0;

  ///성공한 패스
  int passSuccess = 0;

  ///성공한 드리블
  int dribbleSuccess = 0;

  /// 수비 성공
  int defSuccess = 0;

  /// 선방
  int saveSuccess = 0;

  /// 트레이팅, 게임시 성장할 수 있는 스텟
  late int _potential;

  int get overall => _stat.average;

  List<Map<String, int>> gameRecord = [];

  List<List<int>> seasonRecord = [];

  Position get wantPosition => _getWantedPositionFromStat(stat);

  PlayerAction? lastAction;

  get extraStat => _extraStat;

  addExtraStat(int point) {
    _extraStat += point;
  }

  //시즌 데이터 저장
  _saveSeason() {}

  newSeason() {
    _saveSeason();
  }

  ///선수의 특정 능력치를 향상시켜주는 메소드
  void addStat(PlayerStat stat, int point) {
    _stat.add(stat);
    _extraStat -= point;
  }

  void resetPosXY() {
    posXY = startingPoxXY;
  }

  void gamePlayed() {
    gameRecord.add({
      'goal': goal,
      'assist': assist,
      'passSuccess': passSuccess,
      'shooting': shooting,
      'defSuccess': defSuccess,
      'saveSuccess': saveSuccess,
      'dribbleSuccess': dribbleSuccess,
    });
    goal = 0;
    assist = 0;
    passSuccess = 0;
    shooting = 0;
    defSuccess = 0;
    saveSuccess = 0;
    dribbleSuccess = 0;
    resetPosXY();
    _growAfterPlay();
  }

  ///현재 공을 가지고 있는지 여부
  bool hasBall = false;

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

  actionWidthBall({
    required ClubInFixture team,
    required ClubInFixture opposite,
    required Ball ball,
    required Fixture fixture,
  }) {
    lastAction = null;
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
      int passPercent = 100;
      int dribblePercent = 30;
      int ranNum = R().getInt(min: 0, max: shootPercent + passPercent + dribblePercent);
      List<Player> frontPlayers = teamPlayers.where((p) => p.posXY.y > posXY.y - 20).toList();

      List<Player> nearOpposite = oppositePlayers
          .where((opposite) =>
              opposite.posXY.distance(PosXY(
                100 - posXY.x,
                200 - posXY.y,
              )) <
              10)
          .toList();

      bool canShoot = true;

      for (var opposite in nearOpposite) {
        double distanceBonus = 3 -
            opposite.posXY.distance(PosXY(
                  100 - posXY.x,
                  200 - posXY.y,
                )) *
                1.5;

        if ((overall / (opposite.overall * distanceBonus + overall)) < R().getDouble(max: 1)) {
          canShoot = false;
        }
      }

      if (canShoot && (ranNum < shootPercent || frontPlayers.isEmpty)) {
        lastAction = PlayerAction.shoot;
        shoot(fixture: fixture, team: team, opposite: opposite, goalKeeper: oppositePlayers.firstWhere((player) => player.position == Position.goalKeeper));
      } else if (ranNum < shootPercent + passPercent) {
        lastAction = PlayerAction.pass;
        late Player target;
        if (ball.posXY.y >= 100 && frontPlayers.isNotEmpty) {
          target = frontPlayers[R().getInt(min: 0, max: frontPlayers.length - 1)];
        } else if (ball.posXY.y >= 50) {
          target = R().getInt(max: 10, min: 0) > 1 ? teamPlayers[R().getInt(min: 0, max: 1)] : teamPlayers[R().getInt(min: 7, max: 9)];
        } else {
          target = R().getInt(max: 10, min: 0) > 3 ? teamPlayers[R().getInt(min: 0, max: 2)] : teamPlayers[R().getInt(min: 5, max: 7)];
        }

        pass(target, team);
      } else if (ranNum < shootPercent + passPercent + dribblePercent) {
        lastAction = PlayerAction.dribble;
        dribble(team);
      }

      if (lastAction != null) _streamController.add(lastAction!);
    } else {
      int ranNum = R().getInt(min: 0, max: 100);
      switch (ranNum) {
        case < 40:
          stayFront();
          break;
        case < 100:
          moveFront();
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
    lastAction = null;
    List<Player> oppositePlayers = opposite.club.players;

    ///상대방의 공을 이미 배았았을 경우
    if (oppositePlayers.where((player) => player.hasBall).isEmpty) {
      actionWidthBall(team: team, opposite: opposite, ball: ball, fixture: fixture);
      return;
    }
    PosXY ballPos = PosXY(100 - ball.posXY.x, 200 - ball.posXY.y);
    bool canTackle = ballPos.distance(posXY) < 4;

    double personalPressBonus = switch (position) {
      Position.forward when ballPos.y > posXY.y => 100,
      Position.forward => 20,
      Position.midfielder => 15,
      Position.defender => 10,
      _ => 0,
    };
    bool canPress = team.club.tactics.pressDistance + personalPressBonus > ballPos.distance(posXY);

    if (canTackle) {
      int tacklePercent = 50;
      int stayBackPercent = 100;
      int ranNum = R().getInt(min: 0, max: tacklePercent + stayBackPercent);

      if (ranNum < tacklePercent) {
        tackle(fixture.playerWithBall!, team);
        lastAction = PlayerAction.tackle;
      } else if (ranNum < tacklePercent + stayBackPercent) {
        stayBack();
      }
    } else {
      if (canPress) {
        press(ball.posXY);
      } else {
        stayBack();
      }
    }
    if (lastAction != null) _streamController.add(lastAction!);
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

enum PlayerAction {
  shoot('shoot'),
  tackle('tackle'),
  pass('pass'),
  dribble('dribble'),
  goal('goal'),
  assist('assist'),
  keeping('keeping');

  final String text;
  const PlayerAction(this.text);

  @override
  String toString() => text;
}
