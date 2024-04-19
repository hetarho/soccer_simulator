// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:soccer_simulator/entities/player/vo/player_act_event.dart';
import 'package:soccer_simulator/entities/player/vo/player_game_record.dart';
import 'package:soccer_simulator/entities/tactics.dart';
import 'package:soccer_simulator/enum/player_action.dart';
import 'package:soccer_simulator/utils/math.dart';
import 'package:uuid/uuid.dart';

import 'package:soccer_simulator/entities/ball.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/entities/member.dart';
import 'package:soccer_simulator/entities/stat.dart';
import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:soccer_simulator/enum/player.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/enum/training_type.dart';
import 'package:soccer_simulator/utils/random.dart';

part 'player.action.dart';
part 'player.grow.dart';
part 'player.stat.dart';

class Player extends Member {
  late StreamController<PlayerActEvent> _streamController;
  Stream<PlayerActEvent> get playerStream => _streamController.stream;
  Player({
    required super.name,
    required super.birthDay,
    required super.national,
    required this.backNumber,
    required Stat stat,
    this.personalTrainingTypes = const [],
    this.teamTrainingTypePercent = 0.5,
    this.position,
    required this.height,
    required this.bodyType,
    required this.soccerIQ,
    required this.reflex,
    required this.flexibility,
    required this.speed,
    int? potential,
  }) {
    _stat = stat;

    //포텐셜을 지정해주지 않으면 랜덤으로 책정
    _potential = potential ?? R().getInt(min: 30, max: 120);
    _streamController = StreamController<PlayerActEvent>.broadcast();
  }

  @override
  String toString() {
    return 'Player:$name goal:$seasonGoal';
  }

  bool isPlaying = false;
  Timer? _timer; // Timer 인스턴스를 저장할 변수
  Duration _playSpeed = const Duration(milliseconds: 0);

  ///현재 경기 시간
  Duration playTime = const Duration(seconds: 0);

  void updateTimeSpeed(Duration newTimeSpeed) {
    _playSpeed = newTimeSpeed;
  }

  Duration get playSpeed {
    return Duration(milliseconds: (_playSpeed.inMilliseconds * 10 / sqrt(reflex)).round());
  }

  gameStart({
    required Fixture fixture,
    required ClubInFixture team,
    required ClubInFixture opposite,
    required Ball ball,
    required bool isHome,
  }) {
    _timer?.cancel();
    _timer = Timer.periodic(playSpeed, (timer) async {
      playTime = fixture.playTime;
      bool teamHasBall = team.club.startPlayers.where((player) => player.hasBall).isNotEmpty;
      lastAction = null;

      /// 판단력/5 만큼 행동 포인트 적립
      _actPoint += judgementStat / 10;
      if (teamHasBall) {
        attack(team: team, opponent: opposite, ball: ball, fixture: fixture);
      } else {
        defend(team: team, opponent: opposite, ball: ball, fixture: fixture);
      }

      if (lastAction != null) _streamController.add(PlayerActEvent(player: this, action: lastAction!));
    });
  }

  gameEnd() {
    posXY = startingPoxXY;
    _timer?.cancel();
  }

  Player.random({
    required super.name,
    required super.birthDay,
    required super.national,
    required this.backNumber,
    required Position position,
    Stat? stat,
    int? potential,
    double? height,
    BodyType? bodyType,
    int? soccerIQ,
    int? reflex,
    int? flexibility,
    int? speed,
    int? min,
    int? max,
    Tactics? tactics,
    this.personalTrainingTypes = const [],
    this.teamTrainingTypePercent = 0.5,
  }) {
    this.height = height ?? R().getDouble(min: 165, max: 210);
    this.bodyType = bodyType ?? R().getBodyType();
    this.soccerIQ = soccerIQ ?? R().getInt(min: min ?? 30, max: max ?? 120);
    this.reflex = reflex ?? R().getInt(min: min ?? 30, max: max ?? 120);
    this.speed = speed ?? R().getInt(min: min ?? 30, max: max ?? 120);
    this.flexibility = flexibility ?? R().getInt(min: min ?? 30, max: max ?? 120);
    _potential = potential ?? R().getInt(min: min ?? 30, max: max ?? 120);
    _stat = stat ?? Stat.random(position: position);
    _streamController = StreamController<PlayerActEvent>.broadcast();
    this.tactics = tactics ?? Tactics(pressDistance: 15);
  }

  final String id = const Uuid().v4();

  ///스타팅 멤버인지 여부
  bool isStartingPlayer = false;

  ///경기에서 현재 포지션
  PosXY posXY = PosXY(0, 0);

  ///상대팀 선수와 거리 비교를 위한 포지션
  PosXY get reversePosXy => PosXY(100 - posXY.x, 200 - posXY.y);

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
  Stat get stat {
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
  late int soccerIQ;

  ///반응 속도
  late int reflex;

  ///스피드
  late int speed;

  ///유연성
  late int flexibility;

  //선수의 스텟
  late final Stat _stat;

  ///선수의 개인 전술
  Tactics? tactics;

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

  List<PlayerGameRecord> gameRecord = [];

  int get seasonGoal => gameRecord.fold(0, (prev, rec) => prev + rec.goal);
  int get seasonAssist => gameRecord.fold(0, (prev, rec) => prev + rec.assist);

  List<List<int>> seasonRecord = [];

  Position get wantPosition => _getWantedPositionFromStat(stat);

  PlayerAction? lastAction;

  Player? passedPlayer;

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
  void addStat(Stat stat, int point) {
    _stat.add(stat);
    _extraStat -= point;
  }

  void resetPosXY() {
    posXY = startingPoxXY;
  }

  void gamePlayed() {
    gameRecord.add(PlayerGameRecord(
      goal: goal,
      assist: assist,
      passSuccess: passSuccess,
      shooting: shooting,
      defSuccess: defSuccess,
      saveSuccess: saveSuccess,
      dribbleSuccess: dribbleSuccess,
    ));
    goal = 0;
    assist = 0;
    passSuccess = 0;
    shooting = 0;
    defSuccess = 0;
    saveSuccess = 0;
    dribbleSuccess = 0;
    _currentStamina = 100;
    resetPosXY();
    _growAfterPlay();
  }

  ///현재 공을 가지고 있는지 여부
  bool _hasBall = false;

  double _currentStamina = 100;

  bool get hasBall => _hasBall;

  ///현재 공을 잡고 플레이가 가능한지를 나타내는 변수 100이상이 되야 플레이 가능
  double _actPoint = 0;

  ///현재 선수의 패스 선택지로서의 매력도
  double attractive = 0.0;

  set hasBall(bool newVal) {
    ///공을 얻거나 잃으면 활동 포인트 초기화
    _actPoint = 0;
    if (newVal) {
      _streamController.add(PlayerActEvent(player: this, action: PlayerAction.none));
    }
    _hasBall = newVal;
  }

  ///윙어인지 아닌지를 나타내는 변수
  bool get isWinger => isLeftWinger || isRightWinger;

  bool get isLeftWinger => startingPoxXY.x < 30;
  bool get isRightWinger => startingPoxXY.x > 70;

  double get _posXMinBoundary {
    return max(
        0,
        switch (position) {
          Position.goalKeeper => startingPoxXY.x - 15,
          Position.defender => startingPoxXY.x - 15,
          Position.midfielder => startingPoxXY.x - (isLeftWinger ? 10 : 15),
          Position.forward => startingPoxXY.x - (isLeftWinger ? 15 : 25),
          _ => min(startingPoxXY.x - 100, 0),
        });
  }

  double get _posXMaxBoundary {
    return min(
        100,
        switch (position) {
          Position.goalKeeper => startingPoxXY.x + 15,
          Position.defender => startingPoxXY.x + 15,
          Position.midfielder => startingPoxXY.x + (isRightWinger ? 10 : 15),
          Position.forward => startingPoxXY.x + (isRightWinger ? 15 : 25),
          _ => min(startingPoxXY.x + 100, 100),
        });
  }

  double get _posYMinBoundary {
    return max(
        0,
        switch (position) {
          Position.goalKeeper => startingPoxXY.y,
          Position.defender => startingPoxXY.y - 10,
          Position.midfielder => startingPoxXY.y - (isWinger ? 30 : 20),
          Position.forward => startingPoxXY.y - (isWinger ? 50 : 30),
          _ => min(startingPoxXY.y - 100, 0),
        });
  }

  double get _posYMaxBoundary {
    return switch (position) {
      Position.goalKeeper => startingPoxXY.y + 10,
      Position.defender => startingPoxXY.y + (isWinger ? 140 : 30),
      Position.midfielder => startingPoxXY.y + (isWinger ? 110 : 40),
      Position.forward => startingPoxXY.y + (isWinger ? 100 : 90),
      _ => min(startingPoxXY.y + 200, 200),
    };
  }
}
