// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/player/vo/player_act_event.dart';
import 'package:soccer_simulator/entities/player/vo/player_game_record.dart';
import 'package:soccer_simulator/entities/tactics/tactics.dart';
import 'package:soccer_simulator/enum/national.dart';
import 'package:soccer_simulator/enum/player_action.dart';
import 'package:soccer_simulator/utils/math.dart';
import 'package:soccer_simulator/utils/function.dart';
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
  Duration _playSpeed = const Duration(milliseconds: 1);

  ///현재 경기 시간
  Duration playTime = const Duration(seconds: 0);

  void updateTimeSpeed(Duration newTimeSpeed) {
    _playSpeed = newTimeSpeed;
  }

  Duration get playSpeed {
    return Duration(milliseconds: (_playSpeed.inMilliseconds * 10 / sqrt(reflex / 2)).round());
  }

  Player.create({
    required super.name,
    DateTime? birthDay,
    National? national,
    required this.backNumber,
    required PlayerRole role,
    Stat? stat,
    int? potential,
    double? height,
    BodyType? bodyType,
    int? soccerIQ,
    int? reflex,
    int? flexibility,
    int? speed,
    required int min,
    required int max,
    Tactics? tactics,
    this.personalTrainingTypes = const [],
    this.teamTrainingTypePercent = 0.5,
  }) : super(
          birthDay: birthDay ?? R().getDate(),
          national: national ?? R().getNational(),
        ) {
    this.height = height ?? R().getDouble(min: 165, max: 210);
    this.bodyType = bodyType ?? R().getBodyType();
    this.soccerIQ = soccerIQ ?? R().getInt(min: min, max: max);
    this.reflex = reflex ?? R().getInt(min: min, max: max);
    this.speed = speed ?? R().getInt(min: min, max: max);
    this.flexibility = flexibility ?? R().getInt(min: min, max: max);
    _potential = potential ?? R().getInt(min: min, max: max);
    _stat = stat ?? Stat.create(role: role, min: min, max: max);
    _streamController = StreamController<PlayerActEvent>.broadcast();
    this.tactics = tactics ?? Tactics(pressDistance: 15, freeLevel: PlayerFreeLevel.middle);
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

    position = getPositionFromPosXY(newValue);

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
  int? backNumber;

  ///키
  late double height;

  ///체형
  late BodyType bodyType;

  ///축구 지능
  late int soccerIQ;

  ///반응 속도
  late int reflex;

  ///스피드
  late int speed;

  ///유연성
  late int flexibility;

  //선수의 스텟
  late Stat _stat;

  Club? team;

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

  int get overall {
    return ((_stat.stamina +
                _stat.strength +
                _stat.composure +
                _stat.teamwork +
                switch (role) {
                  PlayerRole.forward => _stat.attSkill,
                  PlayerRole.midfielder => _stat.passSkill,
                  PlayerRole.defender => _stat.defSkill,
                  PlayerRole.goalKeeper => _stat.gkSkill,
                }) /
            5)
        .round();
  }

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

  double rotateDegree = 0;

  double get _posXMinBoundary {
    return max(
        0,
        startingPoxXY.x +
            switch (position ?? wantPosition) {
              Position.st => -10,
              Position.cf => -20,
              Position.lf => -20,
              Position.rf => -15,
              Position.lw => -15,
              Position.rw => -5,
              Position.lm => -10,
              Position.rm => -10,
              Position.cm => -10,
              Position.am => -20,
              Position.dm => -35,
              Position.lb => -25,
              Position.cb => -5,
              Position.rb => -5,
              Position.gk => -5,
            });
  }

  double get _posXMaxBoundary {
    return min(
        100,
        startingPoxXY.x +
            switch (position ?? wantPosition) {
              Position.st => 10,
              Position.cf => 20,
              Position.lf => 15,
              Position.rf => 20,
              Position.lw => 5,
              Position.rw => 15,
              Position.lm => 10,
              Position.rm => 10,
              Position.cm => 10,
              Position.am => 20,
              Position.dm => 35,
              Position.lb => 5,
              Position.cb => 5,
              Position.rb => 25,
              Position.gk => 5,
            });
  }

  double get _posYMinBoundary {
    return max(
        0,
        startingPoxXY.y +
            switch (position ?? wantPosition) {
              Position.st => -15,
              Position.cf => -25,
              Position.lf => -25,
              Position.rf => -25,
              Position.lw => -40,
              Position.rw => -40,
              Position.lm => -30,
              Position.rm => -30,
              Position.cm => -30,
              Position.am => -30,
              Position.dm => -30,
              Position.lb => -20,
              Position.cb => -20,
              Position.rb => -20,
              Position.gk => -20,
            });
  }

  double get _posYMaxBoundary {
    return min(
        200,
        startingPoxXY.y +
            switch (position ?? wantPosition) {
              Position.st => 90,
              Position.cf => 90,
              Position.lf => 90,
              Position.rf => 90,
              Position.lw => 90,
              Position.rw => 90,
              Position.lm => 60,
              Position.rm => 60,
              Position.cm => 60,
              Position.am => 80,
              Position.dm => 40,
              Position.lb => 30,
              Position.cb => 30,
              Position.rb => 30,
              Position.gk => 5,
            });
  }
}
