import 'dart:async';
import 'dart:math';

import 'package:soccer_simulator/domain/entities/club/club.dart';

import 'package:soccer_simulator/domain/entities/fixture/club_in_fixture.dart';
import 'package:soccer_simulator/domain/entities/player/vo/player_act_event.dart';
import 'package:soccer_simulator/domain/entities/player/vo/player_game_record.dart';
import 'package:soccer_simulator/domain/entities/tactics/tactics.dart';
import 'package:soccer_simulator/domain/enum/play_level.enum.dart';
import 'package:soccer_simulator/domain/enum/player_action.enum.dart';
import 'package:soccer_simulator/utils/math.dart';
import 'package:soccer_simulator/utils/function.dart';

import 'package:soccer_simulator/domain/entities/fixture/fixture.dart';
import 'package:soccer_simulator/domain/entities/member.dart';
import 'package:soccer_simulator/domain/entities/stat.dart';
import 'package:soccer_simulator/domain/entities/pos/pos.dart';
import 'package:soccer_simulator/domain/enum/player.enum.dart';
import 'package:soccer_simulator/domain/enum/position.enum.dart';
import 'package:soccer_simulator/domain/enum/training_type.enum.dart';
import 'package:soccer_simulator/utils/random.dart';

part 'player.action.dart';
part 'player.grow.dart';
part 'player.stat.dart';

class Player extends Member {
  Player({
    required this.id,
    required super.name,
    required super.birthDay,
    required super.national,
    required this.height,
    required this.bodyType,
    required this.soccerIQ,
    required this.reflex,
    required this.flexibility,
    required this.speed,
    required this.tactics,
    required int potential,
    required Stat stat,
    this.backNumber,
    this.personalTrainingTypes = const [],
    this.teamTrainingTypePercent = 0.5,
    this.position,
  })  : _potential = potential,
        _stat = stat;

  final int id;

  ///스타팅 멤버인지 여부
  bool isStartingPlayer = false;

  ///게임 진행을 위한 stream controller
  StreamController<PlayerActEvent>? _streamController;

  /// 선수의 액션을 이벤트로 발생시켜주는 stream
  Stream<PlayerActEvent>? get playerStream => _streamController?.stream;

  /// Timer 인스턴스를 저장할 변수
  Timer? _timer;

  ///TODO: 삭제 예정 - 선수의 playSpeed
  Duration _playSpeed = const Duration(milliseconds: 1);

  void updatePlaySpeed(Duration newTimeSpeed) {
    _playSpeed = newTimeSpeed;
  }

  Duration get playSpeed {
    return _playSpeed;
  }

  ///경기에서 현재 포지션
  PosXY posXY = PosXY(0, 0);

  ///상대팀 선수와 거리 비교를 위한 포지션
  PosXY get reversePosXy => PosXY(100 - posXY.x, 200 - posXY.y);

  ///스타팅 포지션
  PosXY _startingPoxXY = PosXY(0, 0);

  ///스타팅 포지션이 변경될 때마다 포지션 변경
  set startingPoxXY(PosXY newValue) {
    _startingPoxXY = newValue;

    position = getPositionFromPosXY(newValue);

    posXY = newValue;
  }

  ///스타팅 포지션 getter
  PosXY get startingPoxXY {
    return _startingPoxXY;
  }

  ///선수 스텟 getter
  Stat get stat {
    return _stat;
  }

  /// 선수 잠재력 getter
  int get potential {
    return _potential;
  }

  /// 선수 잠재력 setter
  set potential(newVal) {
    _potential = newVal;
  }

  ///선수의 나이를 구하는 함수
  getAge(DateTime now) {
    (now.difference(birthDay).inDays / 365).floor();
  }

  ///등번호
  int? backNumber;

  ///키
  double height;

  ///체형
  BodyType bodyType;

  ///축구 지능
  int soccerIQ;

  ///반응 속도
  int reflex;

  ///스피드
  int speed;

  ///유연성
  int flexibility;

  //선수의 스텟
  final Stat _stat;

  ///선수의 소속 클럽
  Club? team;

  ///선수의 개인 전술
  Tactics tactics;

  ///개인 트레이닝 시 훈련 종류
  List<TrainingType> personalTrainingTypes;

  ///팀 트레이닝 베율
  double teamTrainingTypePercent;

  ///추가로 상승시킬 스탯
  int _extraStat = 0;

  ///경기에 출전할 포지션
  Position? position;

  /// 트레이팅, 게임시 성장할 수 있는 스텟
  int _potential;
  
  PlayerRole get role {
    if ([
      Position.st,
      Position.cf,
      Position.lf,
      Position.rf,
      Position.lw,
      Position.rw,
    ].contains(position)) {
      return PlayerRole.forward;
    } else if ([
      Position.lm,
      Position.rm,
      Position.cm,
      Position.am,
      Position.dm,
    ].contains(position)) {
      return PlayerRole.midfielder;
    } else if ([
      Position.lb,
      Position.cb,
      Position.rb,
    ].contains(position)) {
      return PlayerRole.defender;
    } else {
      return PlayerRole.goalKeeper;
    }
  }

  ///========================= 경기마다 초기화 ==========================

  ///선수의 컨디션
  double condition = 1;

  PlayerGameRecord _currentGameRecord = PlayerGameRecord.init();

  //TODO;
  Fixture? _currentFixture;

  ClubInFixture get _myTeamCurrentFixture {
    return _currentFixture!.home.club.id == team?.id ? _currentFixture!.home : _currentFixture!.away;
  }

  ClubInFixture get _opponentTeamCurrentFixture {
    return _currentFixture!.home.club.id == team?.id ? _currentFixture!.away : _currentFixture!.home;
  }

  PosXY get _ballPosXY {
    return _currentFixture!.ball.posXY;
  }

  int get overall {
    List<int> stats = [
      if ([PlayerRole.forward].contains(role)) shootingStat,
      if ([PlayerRole.forward].contains(role)) midRangeShootStat,
      if ([PlayerRole.forward, PlayerRole.midfielder].contains(role)) keyPassStat,
      if ([PlayerRole.forward, PlayerRole.midfielder].contains(role)) shortPassStat,
      if ([PlayerRole.forward, PlayerRole.midfielder, PlayerRole.defender, PlayerRole.goalKeeper].contains(role)) longPassStat,
      if ([PlayerRole.forward, PlayerRole.midfielder, PlayerRole.defender, PlayerRole.goalKeeper].contains(role)) headerStat,
      if ([PlayerRole.forward, PlayerRole.midfielder, PlayerRole.defender].contains(role)) dribbleStat,
      if ([PlayerRole.forward, PlayerRole.midfielder, PlayerRole.defender, PlayerRole.goalKeeper].contains(role)) evadePressStat,
      if ([PlayerRole.forward, PlayerRole.midfielder, PlayerRole.defender].contains(role)) tackleStat,
      if ([PlayerRole.midfielder, PlayerRole.defender].contains(role)) pressureStat,
      if ([PlayerRole.forward, PlayerRole.midfielder, PlayerRole.defender, PlayerRole.goalKeeper].contains(role)) judgementStat,
    ];

    return (stats.fold(0, (prev, res) => res + prev) / stats.length).round();
  }

  ///========================= 시즌마다 초기화 ==========================
  List<PlayerGameRecord> gameRecord = [];

  ///시즌 골 수
  int get seasonGoal => gameRecord.fold(0, (prev, rec) => prev + rec.goal);

  ///시즌 어시스트 수
  int get seasonAssist => gameRecord.fold(0, (prev, rec) => prev + rec.assist);

  ///시즌 패스 성공 수
  int get seasonPassSuccess => gameRecord.fold(0, (prev, rec) => prev + rec.passSuccess);

  ///시즌 수비 성공 수
  int get seasonDefSuccess => gameRecord.fold(0, (prev, rec) => prev + rec.defSuccess);

  ///시즌 드리블 성공 수
  int get seasonDribbleSuccess => gameRecord.fold(0, (prev, rec) => prev + rec.dribbleSuccess);

  ///시즌 패스 시도 수
  int get seasonPassTry => gameRecord.fold(0, (prev, rec) => prev + rec.passTry);

  ///시즌 패스 성공률
  int get seasonPassSuccessPercent => (seasonPassSuccess * 100 / max(1, seasonPassTry)).round();

  ///시즌 패스 슈팅 수
  int get seasonShooting => gameRecord.fold(0, (prev, rec) => prev + rec.shooting);

  ///시즌 유효 슈팅 수
  int get seasonShootOnTarget => gameRecord.fold(0, (prev, rec) => prev + rec.shootOnTarget);

  ///시즌 패스 슈팅 정확도
  int get seasonShootAccuracy => (seasonGoal * 100 / max(1, seasonShooting)).round();

  ///시즌 패스 슈팅 정확도
  int get seasonIntercept => gameRecord.fold(0, (prev, rec) => prev + rec.intercept);

  List<List<PlayerGameRecord>> seasonRecord = [];

  Position get wantPosition => _getWantedPositionFromStat(stat);

  PlayerAction? lastAction;

  Player? passedPlayer;

  get extraStat => _extraStat;

  addExtraStat(int point) {
    _extraStat += point;
  }

  //시즌 데이터 저장
  _saveSeason() {
    seasonRecord.add(gameRecord);
    gameRecord = [];
  }

  newSeason() {
    _saveSeason();
  }

  ///선수의 특정 능력치를 향상시켜주는 메소드
  void addStat(Stat stat, int point) {
    _stat.add(stat);
    _extraStat -= point;
  }

  void resetPosXY() {
    posXY = startingPoxXY;
  }

  ///현재 공을 가지고 있는지 여부
  bool _hasBall = false;

  double _currentStamina = 100;

  ///현재 선수의 패스 선택지로서의 매력도
  double attractive = 0.0;

  double rotateDegree = 0;

  ///이 수치가 높을수록 스타팅포인트에서 이동하기 어려움( 0 = 완전 자유로움 100 = 자리에고정)
  double get _leftFreedom =>
      switch (position ?? wantPosition) {
        ///forward
        Position.lf => 0,
        Position.lw => 0,
        Position.rf => 30,
        Position.rw => 20,
        Position.st => 50,
        Position.cf => 50,

        ///midfielder
        Position.lm => 0,
        Position.rm => 60,
        Position.cm => 60,
        Position.am => 60,
        Position.dm => 60,

        ///defender
        Position.lb => 10,
        Position.rb => 70,
        Position.cb => 80,
        Position.gk => 95,
      } *
      _freeLevelToDouble(tactics.freeLevel.left) *
      _freeLevelToDouble(team?.tactics.freeLevel.left);

  double get _rightFreedom =>
      switch (position ?? wantPosition) {
        ///forward
        Position.lf => 30,
        Position.lw => 20,
        Position.rf => 0,
        Position.rw => 0,
        Position.st => 50,
        Position.cf => 50,

        ///midfielder
        Position.lm => 60,
        Position.rm => 0,
        Position.cm => 60,
        Position.am => 60,
        Position.dm => 60,

        ///defender
        Position.lb => 70,
        Position.rb => 10,
        Position.cb => 80,
        Position.gk => 95,
      } *
      _freeLevelToDouble(tactics.freeLevel.right) *
      _freeLevelToDouble(team?.tactics.freeLevel.right);

  double get _forwardFreedom =>
      switch (position ?? wantPosition) {
        ///forward
        Position.lf => 10,
        Position.lw => 10,
        Position.rf => 10,
        Position.rw => 10,
        Position.st => 10,
        Position.cf => 10,

        ///midfielder
        Position.lm => 20,
        Position.rm => 20,
        Position.cm => 50,
        Position.am => 20,
        Position.dm => 60,

        ///defender
        Position.lb => 20,
        Position.rb => 20,
        Position.cb => 80,
        Position.gk => 99,
      } *
      _freeLevelToDouble(tactics.freeLevel.forward) *
      _freeLevelToDouble(team?.tactics.freeLevel.forward);

  double get _backwardFreedom =>
      switch (position ?? wantPosition) {
        ///forward
        Position.lf => 75,
        Position.lw => 75,
        Position.rf => 75,
        Position.rw => 75,
        Position.st => 75,
        Position.cf => 75,

        ///midfielder
        Position.lm => 60,
        Position.rm => 60,
        Position.cm => 60,
        Position.am => 60,
        Position.dm => 60,

        ///defender
        Position.lb => 80,
        Position.rb => 80,
        Position.cb => 80,
        Position.gk => 90,
      } *
      _freeLevelToDouble(tactics.freeLevel.backward) *
      _freeLevelToDouble(team?.tactics.freeLevel.backward);

  double _freeLevelToDouble(PlayLevel? freeLevel) => switch (freeLevel) {
        PlayLevel.min => 2,
        PlayLevel.low => 1.5,
        PlayLevel.middle => 1,
        PlayLevel.hight => 0.5,
        PlayLevel.max => 0.25,
        _ => 1,
      };

  @override
  String toString() {
    return '''
=====================Player=====================
name: $name,
birthDay: $birthDay,
national: $national,
height: $height,
bodyType: $bodyType,
soccerIQ: $soccerIQ,
reflex: $reflex,
speed: $speed,
flexibility: $flexibility,
potential: $potential,
stat: $stat,
tactics: $tactics,
currentGameRecord: $_currentGameRecord,
personalTrainingTypes: $personalTrainingTypes,
teamTrainingTypePercent: $teamTrainingTypePercent,
  ''';
  }
}
