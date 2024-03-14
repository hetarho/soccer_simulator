import 'dart:async';
import 'dart:math';

import 'package:soccer_simulator/entities/club.dart';

class Fixture {
  Fixture({required this.homeClub, required this.awayClub}) {
    _streamController = StreamController<Duration>.broadcast();
  }

  final Club homeClub;
  final Club awayClub;

  Timer? _timer; // Timer 인스턴스를 저장할 변수
  late StreamController<Duration> _streamController;

  Stream<Duration> get gameStream => _streamController.stream;

  ///현재 경기 시간
  Duration playTime = const Duration(seconds: 0);

  ///홈팀의 점유율 (1로 시작)
  double homeTeamBallPercentage = 1;

  ///경기가 종료 되었는지 안되었는지
  bool get isGameEnd {
    return playTime.compareTo(const Duration(minutes: 90)) > 0;
  }

  ///0.01초 = 실제 1초
  Duration playSpeed = const Duration(milliseconds: 10);

  gameStart() async {
    _timer?.cancel(); // 이전 타이머가 있다면 취소
    _timer = Timer.periodic(playSpeed, (timer) {
      if (isGameEnd) {
        gameEnd(); // 스트림과 타이머를 종료하는 메소드 호출
      } else {
        playTime = Duration(seconds: playTime.inSeconds + 10);
        homeTeamBallPercentage = min(max(0, homeTeamBallPercentage + (Random().nextDouble() * 0.2 - 0.1)), 1);
        _streamController.add(playTime);
      }
    });
  }

  void gameEnd() {
    _timer?.cancel();
    _streamController.close();
  }

  void updateTimeSpeed(Duration newTimeSpeed) {
    playSpeed = newTimeSpeed;
    if (_timer?.isActive ?? false) {
      gameStart(); // 타이머가 활성 상태인 경우, play를 다시 호출하여 타이머를 재시작
    }
  }
}
