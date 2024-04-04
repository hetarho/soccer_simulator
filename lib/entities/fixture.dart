// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:soccer_simulator/entities/club.dart';
import 'package:soccer_simulator/entities/player.dart';
import 'package:soccer_simulator/utils/random.dart';

class Fixture {
  Fixture({required this.home, required this.away}) {
    _streamController = StreamController<bool>.broadcast();
  }

  final ClubInFixture home;
  final ClubInFixture away;
  List<FixtureRecord> records = [];

  Timer? _timer; // Timer 인스턴스를 저장할 변수
  late StreamController<bool> _streamController;

  Stream<bool> get gameStream => _streamController.stream;

  ///현재 경기 시간
  Duration playTime = const Duration(seconds: 0);

  ///경기가 종료 되었는지 안되었는지
  bool get isGameEnd {
    return playTime.compareTo(const Duration(minutes: 90)) >= 0;
  }

  Duration get playSpeed {
    return _playSpeed;
  }

  ///0.01초 = 실제 1초
  Duration _playSpeed = const Duration(milliseconds: 10);
  final _playTimeAmount = 10;

  ///현재 볼의 위치
  PosXY _ballPosXY = PosXY(50, 100);

  get ballPosXY => _ballPosXY;

  gameStart() async {
    if (!_streamController.isClosed) {
      _timer?.cancel(); // 이전 타이머가 있다면 취소
      _timer = Timer.periodic(_playSpeed, (timer) {
        if (isGameEnd) {
          gameEnd(); // 스트림과 타이머를 종료하는 메소드 호출
        } else {
          //TODO
          const double testDistance = 10;
          for (var player in [...home.club.startPlayers, ...away.club.startPlayers]) {
            player.posXY = PosXY(
              max(0, min(100, player.posXY.x + R().getDouble(min: -1 * testDistance, max: testDistance))),
              max(0, min(200, player.posXY.y + R().getDouble(min: -1 * testDistance, max: testDistance))),
            );
          }
          _ballPosXY = PosXY(
            max(0, min(100, _ballPosXY.x + R().getDouble(min: -10 * testDistance, max: 10 * testDistance))),
            max(0, min(200, _ballPosXY.y + R().getDouble(min: -10 * testDistance, max: 10 * testDistance))),
          );

          playTime = Duration(seconds: playTime.inSeconds + _playTimeAmount);

          bool homeScored = Random().nextDouble() * 150 < home.club.attOverall / (away.club.defOverall + home.club.attOverall);
          bool awayScored = Random().nextDouble() * 150 < away.club.attOverall / (home.club.defOverall + away.club.attOverall);

          if (homeScored) {
            home.score();
            away.concede();

            records.add(FixtureRecord(
              time: playTime,
              scoredClub: home.club,
              scoredPlayer: home.club.startPlayers[0],
              assistPlayer: home.club.startPlayers[1],
            ));
          }
          if (awayScored) {
            home.concede();
            away.score();

            records.add(FixtureRecord(
              time: playTime,
              scoredClub: away.club,
              scoredPlayer: away.club.startPlayers[0],
              assistPlayer: away.club.startPlayers[1],
            ));
          }

          _streamController.add(isGameEnd);
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
