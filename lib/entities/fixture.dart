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
  List<FixtureRecord> recoreds = [];

  Timer? _timer; // Timer 인스턴스를 저장할 변수
  late StreamController<bool> _streamController;

  Stream<bool> get gameStream => _streamController.stream;

  ///현재 경기 시간
  Duration playTime = const Duration(seconds: 0);

  ///경기가 종료 되었는지 안되었는지
  bool get isGameEnd {
    return playTime.compareTo(const Duration(minutes: 90)) >= 0;
  }

  ///0.01초 = 실제 1초
  Duration _playSpeed = const Duration(milliseconds: 30);
  final _playTimeAmount = 10;

  gameStart() async {
    if (!_streamController.isClosed) {
      _timer?.cancel(); // 이전 타이머가 있다면 취소
      _timer = Timer.periodic(_playSpeed, (timer) {
        if (isGameEnd) {
          gameEnd(); // 스트림과 타이머를 종료하는 메소드 호출
        } else {
          //TODO
          [...home.club.startPlayers, ...away.club.startPlayers].forEach((player) {
            player.posXY = PosXY(
              max(15, min(85, player.posXY!.x + R().getDouble(min: -3, max: 3))),
              max(15, min(85, player.posXY!.y + R().getDouble(min: -3, max: 3))),
            );
          });

          playTime = Duration(seconds: playTime.inSeconds + _playTimeAmount);

          bool homeScored =
              Random().nextDouble() * 150 < home.club.attOverall / (away.club.defOverall + home.club.attOverall);
          bool awayScored =
              Random().nextDouble() * 150 < away.club.attOverall / (home.club.defOverall + away.club.attOverall);

          if (homeScored) {
            home.score();
            away.concede();

            recoreds.add(FixtureRecord(
              time: playTime,
              scoredClub: home.club,
              scoredPlayer: home.club.startPlayers[0],
              assistPlayer: home.club.startPlayers[1],
            ));
          }
          if (awayScored) {
            home.concede();
            away.score();

            recoreds.add(FixtureRecord(
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
