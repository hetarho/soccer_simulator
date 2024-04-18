// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:soccer_simulator/entities/tactics.dart';
import 'package:uuid/uuid.dart';

import 'package:soccer_simulator/entities/ball.dart';
import 'package:soccer_simulator/entities/fixture.dart';
import 'package:soccer_simulator/entities/member.dart';
import 'package:soccer_simulator/entities/player_stat.dart';
import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:soccer_simulator/enum/player.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/enum/training_type.dart';
import 'package:soccer_simulator/utils/random.dart';

part 'player.action.dart';
part 'player.grow.dart';

class Player extends Member {
  late StreamController<PlayerEvent> _streamController;
  Stream<PlayerEvent> get playerStream => _streamController.stream;
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
    _streamController = StreamController<PlayerEvent>.broadcast();
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
    return Duration(milliseconds: (_playSpeed.inMilliseconds * 50 / reflex).round());
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
      if (teamHasBall) {
        actionWidthBall(team: team, opposite: opposite, ball: ball, fixture: fixture);
      } else {
        actionWithOutBall(team: team, opposite: opposite, ball: ball, fixture: fixture);
      }
      if (lastAction != null) _streamController.add(PlayerEvent(player: this, action: lastAction!));
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
    this.personalTrainingTypes = const [],
    this.teamTrainingTypePercent = 0.5,
  }) {
    this.height = height ?? R().getDouble(min: 165, max: 210);
    this.bodyType = bodyType ?? R().getBodyType();
    this.soccerIQ = soccerIQ ?? R().getInt(min: 30, max: 120);
    this.reflex = reflex ?? R().getInt(min: 30, max: 120);
    this.speed = speed ?? R().getInt(min: 30, max: 120);
    this.flexibility = flexibility ?? R().getInt(min: 30, max: 120);
    _potential = potential ?? R().getInt(min: 30, max: 120);
    _stat = stat ?? Stat.random(position: position);
    _streamController = StreamController<PlayerEvent>.broadcast();
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
  void addStat(Stat stat, int point) {
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
  bool _hasBall = false;

  bool get hasBall => _hasBall;

  set hasBall(bool newVal) {
    if (newVal) {
      _streamController.add(PlayerEvent(player: this, action: PlayerAction.none));
    }
    _hasBall = newVal;
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
/// 드리블 - 키 + 체형 + 축구지능 + 반응속도 + 체력 + 기술 + 유연성
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
  none('none'),
  shoot('shoot'),
  tackle('tackle'),
  pass('pass'),
  press('press'),
  dribble('dribble'),
  goal('goal'),
  assist('assist'),
  keeping('keeping');

  final String text;
  const PlayerAction(this.text);

  @override
  String toString() => text;
}

class PlayerEvent {
  final Player player;
  final PlayerAction action;
  PlayerEvent({
    required this.player,
    required this.action,
  });
}
