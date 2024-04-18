// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:soccer_simulator/entities/ball.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/pos/pos.dart';

class Fixture {
  Fixture({required this.home, required this.away}) {
    _streamController = StreamController<FixtureRecord>.broadcast();
    playerStream = StreamGroup.merge(allPlayers.map((e) => e.playerStream).toList()).asBroadcastStream();

    _streamSubscription = playerStream.listen((event) {
      if (event.action != PlayerAction.none && isGameStart) {
        records.add(FixtureRecord(
          time: playTime,
          club: home.club.players.where((element) => element.id == event.player.id).isEmpty ? away.club : home.club,
          player: event.player,
          action: event.action,
          isGameEnd: isGameEnd,
        ));
      }
    });
  }

  Fixture.empty() {
    home = ClubInFixture.empty();
    away = ClubInFixture.empty();
  }
  ////테스트용
  bool stopWhenGoal = false;
  late final ClubInFixture home;
  late final ClubInFixture away;
  List<FixtureRecord> records = [];

  StreamSubscription<PlayerEvent>? _streamSubscription;

  Timer? _timer; // Timer 인스턴스를 저장할 변수
  late StreamController<FixtureRecord> _streamController;

  Stream<FixtureRecord> get gameStream => _streamController.stream;

  late Stream<PlayerEvent> playerStream;

  ///현재 경기 시간
  Duration playTime = const Duration(seconds: 0);

  ///해당 경기를 시뮬레이션으로 구동할지 나타내는 변수
  bool isSimulation = true;

  ///경기가 시작 되었는지 안되었는지
  bool isGameStart = false;

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

  ///0.01초 = 실제 1초
  Duration _playSpeed = const Duration(milliseconds: 0);
  final _playTimeAmount = 10;

  final Ball _ball = Ball();

  get ballPosXY => _ball.posXY;

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

  setBallPos() {
    if (playerWithBall != null) _ball.posXY = playerWithBall!.posXY;
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
    required Player assistPlayer,
  }) async {
    scoredClub.score();
    concedeClub.concede();
    if (!isSimulation && stopWhenGoal) {
      pause();
      await Future.delayed(const Duration(seconds: 2));
      gameStart();
    }

    for (var player in scoredClub.club.players) {
      player.hasBall = false;
      player.resetPosXY();
    }

    for (var player in concedeClub.club.players) {
      player.hasBall = false;
      player.resetPosXY();
    }

    concedeClub.club.players.first.hasBall = true;
    _ball.posXY = PosXY(50, 100);

    assistPlayer.assist += 1;
  }

  pause() {
    _timer?.cancel();
  }

  gameStart() async {
    isGameStart = true;
    if (playerWithBall == null) home.club.players.first.hasBall = true;

    if (!_streamController.isClosed) {
      for (var player in home.club.players) {
        player.gameStart(fixture: this, team: home, opposite: away, ball: _ball, isHome: true);
      }
      for (var player in away.club.players) {
        player.gameStart(fixture: this, team: away, opposite: home, ball: _ball, isHome: false);
      }
      _timer?.cancel();
      _timer = Timer.periodic(_playSpeed, (timer) async {
        if (isGameEnd) {
          for (var player in allPlayers) {
            player.gameEnd();
          }
          gameEnd(); // 스트림과 타이머를 종료하는 메소드 호출
        } else {
          isSimulation ? updateGameInSimulate() : updateGame();
          if (isGameEnd) {
            playerWithBall?.hasBall = false;
            _ball.posXY = PosXY(50, 100);
          }
          _streamController.add(FixtureRecord(
            time: playTime,
            isGameEnd: isGameEnd,
          ));
        }
      });
    }
  }

  void gameEnd() {
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

    _timer?.cancel();
    _streamController.close();
  }

  void updateTimeSpeed(Duration newTimeSpeed) {
    _playSpeed = newTimeSpeed;

    for (var player in allPlayers) {
      player.updateTimeSpeed(newTimeSpeed);
    }

    if (_timer?.isActive ?? false) {
      gameStart(); // 타이머가 활성 상태인 경우, play를 다시 호출하여 타이머를 재시작
    }
  }

  Future<void> dispose() async {
    await _streamSubscription?.cancel();
  }

  List<Player> get allPlayers => [...home.club.players, ...away.club.players];
}

class ClubInFixture {
  late final Club club;
  int _scoredGoal = 0;
  int hasBallTime = 0;
  int shoot = 0;
  int pass = 0;
  int tackle = 0;
  int dribble = 0;

  score() {
    _scoredGoal += 1;
    club.gf++;
  }

  concede() {
    club.ga++;
  }

  get goal {
    return _scoredGoal;
  }

  ClubInFixture({
    required this.club,
  });

  ClubInFixture.empty() {
    club = Club.empty();
  }
}

class FixtureRecord {
  final Duration time;
  final Club? club;
  final PlayerAction? action;
  final Player? player;
  final bool isGameEnd;

  FixtureRecord({
    required this.time,
    required this.isGameEnd,
    this.club,
    this.action,
    this.player,
  });

  @override
  String toString() {
    return 'FixtureRecord(time: $time, club: ${club?.name}, action: $action, player: ${player?.name})';
  }
}
