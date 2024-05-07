// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:soccer_simulator/entities/ball.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/dbManager/jsonable_interface.dart';
import 'package:soccer_simulator/entities/fixture/club_in_fixture.dart';
import 'package:soccer_simulator/entities/fixture/vo/fixture_record.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/player/vo/player_act_event.dart';
import 'package:soccer_simulator/entities/pos/pos.dart';
import 'package:soccer_simulator/enum/player_action.enum.dart';
import 'package:soccer_simulator/utils/color.dart';

class Fixture implements Jsonable {
  Fixture({required this.home, required this.away}) {
    _streamController = StreamController<FixtureRecord>.broadcast();
  }

  Fixture.empty() {
    home = ClubInFixture.empty();
    away = ClubInFixture.empty();
  }

  bool _isReady = false;

  ///홈 팀 데이터
  late final ClubInFixture home;

  ///어웨이 팀 데이터
  late final ClubInFixture away;

  ///경기 정보
  List<FixtureRecord> records = [];

  ///플레이어들의 stream을 모을 streamSubscription
  StreamSubscription<PlayerActEvent>? _streamSubscription;

  ///게임 시간을 증가시키는 타이머
  Timer? _timer; // Timer 인스턴스를 저장할 변수

  ///게임 시간이 지나면 이벤트를 발생시키는 streamController
  late StreamController<FixtureRecord> _streamController;

  ///fixtureRecord가 발생하는 stream
  Stream<FixtureRecord> get gameStream => _streamController.stream;

  ///플레이어 이벤트가 발생하는 stream
  late Stream<PlayerActEvent>? playerStream;

  ///현재 경기 시간
  Duration playTime = const Duration(seconds: 0);

  ///해당 경기를 시뮬레이션으로 구동할지 나타내는 변수
  bool isSimulation = false;

  ///경기가 시작 되었는지 안되었는지
  bool isGameStart = false;

  /// 현재 골킥인지 여부
  bool isGoalKick = false;

  Duration _playSpeed = const Duration(microseconds: 1000);

  late int _playTimeAmount = 10;

  final Ball ball = Ball();

  ///경기가 종료 되었는지 안되었는지
  bool get isGameEnd {
    return playTime.compareTo(const Duration(minutes: 90)) >= 0;
  }

  ///경기가 종료 되었는지 안되었는지
  bool get isFirstHalfEnd {
    return playTime.compareTo(const Duration(minutes: 45)) >= 0;
  }

  ///경기 스피드
  Duration get playSpeed {
    return _playSpeed;
  }

  int get homeBallPercent {
    return (max(1, home.hasBallTime) * 100 / max(1, home.hasBallTime + away.hasBallTime)).round();
  }

  int get awayBallPercent {
    return 100 - homeBallPercent;
  }

  bool get isHomeTeamBall {
    return home.club.startPlayers.where((player) => player.hasBall).isNotEmpty;
  }

  Player? get playerWithBall {
    return [...home.club.players, ...away.club.players, null].firstWhere((player) => player?.hasBall ?? true);
  }

  _setBallPos() {
    if (playerWithBall != null) ball.posXY = playerWithBall!.posXY;
  }

  updateGameInSimulate() {
    playTime = Duration(seconds: playTime.inSeconds + _playTimeAmount);

    bool homeScored = Random().nextDouble() * 150 < home.club.attOverall / (away.club.defOverall + home.club.attOverall);
    bool awayScored = Random().nextDouble() * 150 < away.club.attOverall / (home.club.defOverall + away.club.attOverall);

    if (homeScored) {
      scored(
        scoredClub: home,
        concedeClub: away,
        scoredPlayer: home.club.startPlayers[0],
        assistPlayer: home.club.startPlayers[1],
      );
    }
    if (awayScored) {
      scored(
        scoredClub: away,
        concedeClub: home,
        scoredPlayer: away.club.startPlayers[0],
        assistPlayer: away.club.startPlayers[1],
      );
    }
  }

  updateGame() async {
    playTime = Duration(seconds: playTime.inSeconds + _playTimeAmount);

    if (isHomeTeamBall) {
      home.hasBallTime += _playTimeAmount;
    } else {
      away.hasBallTime += _playTimeAmount;
    }
  }

  ///점수가 났을 떄 기록하는 함수
  scored({
    required ClubInFixture scoredClub,
    required ClubInFixture concedeClub,
    required Player scoredPlayer,
    required Player? assistPlayer,
  }) async {
    scoredClub.score();
    concedeClub.concede();

    for (var player in scoredClub.club.players) {
      player.hasBall = false;
      player.resetPosXY();
    }

    for (var player in concedeClub.club.players) {
      player.hasBall = false;
      player.resetPosXY();
    }

    concedeClub.club.players.first.hasBall = true;
    ball.posXY = PosXY(50, 100);

    assistPlayer?.assist();
  }

  pause() {
    _timer?.cancel();
  }

  ready() {
    if (!_isReady) {
      _isReady = true;
      for (var player in allPlayers) {
        player.ready(_playSpeed);
      }

      playerStream = StreamGroup.merge(allPlayers.map((e) => e.playerStream!).toList()).asBroadcastStream();

      _streamSubscription = playerStream?.listen((event) {
        if ([
              PlayerAction.goal,
              PlayerAction.assist,
              PlayerAction.shoot,
            ].contains(event.action) &&
            isGameStart) {
          records.add(FixtureRecord(
            time: playTime,
            club: home.club.players.where((element) => element.id == event.player.id).isEmpty ? away.club : home.club,
            player: event.player,
            action: event.action,
            isGameEnd: isGameEnd,
          ));
        }
        _setBallPos();
      });

      ///홈팀 유니폼 홈유니폼으로 설정
      home.club.color = home.club.homeColor;

      double homeDiff = C().colorDifference(home.club.homeColor, away.club.homeColor);
      double awayDiff = C().colorDifference(home.club.homeColor, away.club.awayColor);

      ///어웨이 유니폼 홈유니폼으로 설정
      ///
      if (homeDiff < 100) {
        away.club.color = homeDiff > awayDiff ? away.club.homeColor : away.club.awayColor;
      } else {
        away.club.color = away.club.homeColor;
      }
    }
  }

  gameStart() async {
    isGameStart = true;
    if (playerWithBall == null) home.club.players.first.hasBall = true;

    if (!_streamController.isClosed) {
      for (var player in home.club.players) {
        player.gameStart(fixture: this);
      }
      for (var player in away.club.players) {
        player.gameStart(fixture: this);
      }
      _timer?.cancel();
      _timer = Timer.periodic(_playSpeed, (timer) async {
        _streamController.add(FixtureRecord(
          time: playTime,
          isGameEnd: isGameEnd,
        ));
        if (isGameEnd) {
          gameEnd();
        } else {
          isSimulation ? updateGameInSimulate() : updateGame();
        }
      });
    }
  }

  void gameEnd() async {
    playerWithBall?.hasBall = false;
    ball.posXY = PosXY(50, 100);

    for (var player in allPlayers) {
      player.gameEnd();
    }

    if (home.goal == away.goal) {
      home.club.draw();
      away.club.draw();
    } else if (home.goal > away.goal) {
      home.club.win();
      away.club.lose();
    } else {
      away.club.win();
      home.club.lose();
    }

    await _streamController.close();
    await _streamSubscription?.cancel();
    _streamSubscription = null;
    playerStream = null;
    _timer?.cancel();
  }

  void updateTimeSpeed(Duration newTimeSpeed) {
    _playSpeed = newTimeSpeed;

    for (var player in allPlayers) {
      player.updatePlaySpeed(newTimeSpeed);
    }

    if (_timer?.isActive ?? false) {
      gameStart(); // 타이머가 활성 상태인 경우, play를 다시 호출하여 타이머를 재시작
    }
  }

  Future<void> dispose() async {
    await _streamSubscription?.cancel();
  }

  List<Player> get allPlayers => [...home.club.players, ...away.club.players];

  Fixture.fromJson(Map<dynamic, dynamic> map, List<Club> clubs) {
    Club homeClub = clubs.firstWhere(
      (club) => club.id == map['home_club_id'],
      orElse: () => Club.empty(),
    );
    Club awayClub = clubs.firstWhere(
      (club) => club.id == map['away_club_id'],
      orElse: () => Club.empty(),
    );

    home = ClubInFixture.fromJson(map['home'], homeClub);
    away = ClubInFixture.fromJson(map['away'], awayClub);
    records = (map['records'] as List).map((e) => FixtureRecord.fromJson(e)).toList();
    playTime = Duration(microseconds: map['playTime']);
    isSimulation = map['isSimulation'];
    isGameStart = map['isGameStart'];
    _playSpeed = Duration(microseconds: map['_playSpeed']);
    _playTimeAmount = map['_playTimeAmount'];
    _streamController = StreamController<FixtureRecord>.broadcast();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'home': home.toJson(),
      'away': away.toJson(),
      'home_club_id': home.club.id,
      'away_club_id': away.club.id,
      'records': records.map((e) => e.toJson()).toList(),
      'playTime': playTime.inMicroseconds,
      'isSimulation': isSimulation,
      'isGameStart': isGameStart,
      '_playSpeed': _playSpeed.inMicroseconds,
      '_playTimeAmount': _playTimeAmount,
    };
  }
}
