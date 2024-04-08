// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:soccer_simulator/entities/ball.dart';
import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/player.dart';

class Fixture {
  Fixture({required this.home, required this.away}) {
    _streamController = StreamController<FixtureState>.broadcast();
    home.club.players.first.hasBall = true;
  }

  final ClubInFixture home;
  final ClubInFixture away;
  List<FixtureRecord> records = [];
  FixtureState state = FixtureState();

  Timer? _timer; // Timer 인스턴스를 저장할 변수
  late StreamController<FixtureState> _streamController;

  Stream<FixtureState> get gameStream => _streamController.stream;

  ///현재 경기 시간
  Duration playTime = const Duration(seconds: 0);

  ///해당 경기를 시뮬레이션으로 구동할지 나타내는 변수
  bool isSimulation = true;

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
  Duration _playSpeed = const Duration(milliseconds: 10);
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

  Player get playerWithBall {
    return [...home.club.players, ...away.club.players].firstWhere((player) => player.hasBall);
  }

  updateGameInSimulate() {
    playTime = Duration(seconds: playTime.inSeconds + _playTimeAmount);

    bool homeScored = Random().nextDouble() * 150 < home.club.attOverall / (away.club.defOverall + home.club.attOverall);
    bool awayScored = Random().nextDouble() * 150 < away.club.attOverall / (home.club.defOverall + away.club.attOverall);

    if (homeScored) {
      _scored(
        scoredClub: home,
        concedeClub: away,
        scoredPlayer: home.club.startPlayers[0],
        assistPlayer: home.club.startPlayers[1],
      );
    }
    if (awayScored) {
      _scored(
        scoredClub: away,
        concedeClub: home,
        scoredPlayer: away.club.startPlayers[0],
        assistPlayer: away.club.startPlayers[1],
      );
    }
  }

  playWithBallTeam(List<Player> team, List<Player> opposite) {
    for (var player in team) {
      player.actionWidthBall(team: team.where((teamPlayer) => teamPlayer.id != player.id).toList(), opposite: opposite, ball: _ball);
    }
  }

  playWithOutBallTeam(List<Player> team, List<Player> opposite) {
    for (var player in team) {
      player.actionWithOutBall(team: team.where((teamPlayer) => teamPlayer.id != player.id).toList(), opposite: opposite, ball: _ball);
    }
  }

  updateGame() async {
    List<Player> homePlayers = home.club.startPlayers;
    List<Player> awayPlayers = away.club.startPlayers;

    List<Player> withBallTeamPlayers = isHomeTeamBall ? homePlayers : awayPlayers;
    List<Player> withOutBallTeamPlayers = !isHomeTeamBall ? homePlayers : awayPlayers;

    playWithBallTeam(withBallTeamPlayers, withOutBallTeamPlayers);
    playWithOutBallTeam(withOutBallTeamPlayers, withBallTeamPlayers);

    _ball.posXY = playerWithBall.posXY;

    playTime = Duration(seconds: playTime.inSeconds + _playTimeAmount);

    if (isHomeTeamBall) {
      home.hasBallTime += _playTimeAmount;
    } else {
      away.hasBallTime += _playTimeAmount;
    }

    bool homeScored = Random().nextDouble() * 150 < home.club.attOverall / (away.club.defOverall + home.club.attOverall);
    bool awayScored = Random().nextDouble() * 150 < away.club.attOverall / (home.club.defOverall + away.club.attOverall);

    if (homeScored) {
      _scored(
        scoredClub: home,
        concedeClub: away,
        scoredPlayer: home.club.startPlayers[0],
        assistPlayer: home.club.startPlayers[1],
      );
    }
    if (awayScored) {
      _scored(
        scoredClub: away,
        concedeClub: home,
        scoredPlayer: away.club.startPlayers[0],
        assistPlayer: away.club.startPlayers[1],
      );
    }
  }

  ///점수가 났을 떄 기록하는 함수
  _scored({
    required ClubInFixture scoredClub,
    required ClubInFixture concedeClub,
    required Player scoredPlayer,
    required Player assistPlayer,
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
    _ball.posXY = PosXY(50, 100);

    records.add(FixtureRecord(
      time: playTime,
      scoredClub: scoredClub.club,
      scoredPlayer: scoredPlayer,
      assistPlayer: assistPlayer,
    ));
    // pause();
    // await Future.delayed(const Duration(seconds: 2));
    // gameStart();
  }

  pause() {
    _timer?.cancel();
  }

  gameStart() async {
    if (!_streamController.isClosed) {
      _timer?.cancel();
      _timer = Timer.periodic(_playSpeed, (timer) async {
        if (isGameEnd) {
          gameEnd(); // 스트림과 타이머를 종료하는 메소드 호출
        } else {
          isSimulation ? updateGameInSimulate() : updateGame();
          state.time = playTime;
          state.homeScore = home.goal;
          state.awayScore = away.goal;
          state.isEnd = isGameEnd;
          _streamController.add(state);
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
    if (_timer?.isActive ?? false) {
      gameStart(); // 타이머가 활성 상태인 경우, play를 다시 호출하여 타이머를 재시작
    }
  }
}

class ClubInFixture {
  final Club club;
  int _scoredGoal = 0;
  int hasBallTime = 0;
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
}

class FixtureRecord {
  final Duration time;
  final Club scoredClub;
  final Player scoredPlayer;
  final Player assistPlayer;

  FixtureRecord({
    required this.time,
    required this.scoredClub,
    required this.scoredPlayer,
    required this.assistPlayer,
  });
}

class FixtureState {
  Duration time = const Duration(seconds: 0);
  int homeScore = 0;
  int awayScore = 0;
  bool isEnd = false;

  FixtureState();
}
