import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/stat.dart';
import 'package:soccer_simulator/enum/national.dart';
import 'package:soccer_simulator/enum/player.dart';
import 'package:soccer_simulator/enum/position.dart';
import 'package:soccer_simulator/main.dart';

class PlayerDetail extends ConsumerStatefulWidget {
  const PlayerDetail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayerDetailState();
}

class _PlayerDetailState extends ConsumerState<PlayerDetail> {
  int plusMinus = 1;
  Color _buttonColor = Colors.green[100]!;

  @override
  Widget build(BuildContext context) {
    Player player = ref.read(playerProvider) ??
        Player(
          name: '',
          bodyType: BodyType.normal,
          flexibility: 0,
          backNumber: 0,
          reflex: 0,
          soccerIQ: 0,
          speed: 0,
          birthDay: DateTime.now(),
          national: National.algeria,
          height: 123,
          stat: Stat(),
        );
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PositionBadge(position: player.position ?? Position.st, role: player.role),
                  const SizedBox(width: 8),
                  Text(
                    '${player.backNumber}.',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    player.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${player.age})',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${player.soccerIQ}'),
                Text('${player.reflex}'),
                Text('${player.speed}'),
                Text('${player.flexibility}'),
                Text('${player.stat.stamina}'),
                Text('${player.potential}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatButton(
                    color: _buttonColor,
                    text: '축구지능',
                    onClick: () {
                      setState(() {
                        player.soccerIQ += plusMinus * 1;
                      });
                    }),
                StatButton(
                    color: _buttonColor,
                    text: '반응속도',
                    onClick: () {
                      setState(() {
                        player.reflex += plusMinus * 1;
                      });
                    }),
                StatButton(
                    color: _buttonColor,
                    text: '스피드',
                    onClick: () {
                      setState(() {
                        player.speed += plusMinus * 1;
                      });
                    }),
                StatButton(
                    color: _buttonColor,
                    text: '유연성',
                    onClick: () {
                      setState(() {
                        player.flexibility += plusMinus * 1;
                      });
                    }),
                StatButton(
                    color: _buttonColor,
                    text: '체력',
                    onClick: () {
                      setState(() {
                        player.stat.add(Stat(stamina: plusMinus * 1));
                      });
                    }),
                StatButton(
                    color: _buttonColor,
                    text: '잠재력',
                    onClick: () {
                      setState(() {
                        player.potential += plusMinus * 1;
                      });
                    }),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${player.stat.strength}'),
                Text('${player.stat.attSkill}'),
                Text('${player.stat.passSkill}'),
                Text('${player.stat.defSkill}'),
                Text('${player.stat.gkSkill}'),
                Text('${player.stat.composure}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatButton(
                    color: _buttonColor,
                    text: '근력',
                    onClick: () {
                      setState(() {
                        player.stat.add(Stat(strength: plusMinus * 1));
                      });
                    }),
                StatButton(
                    color: _buttonColor,
                    text: '공격스킬',
                    onClick: () {
                      setState(() {
                        player.stat.add(Stat(attSkill: plusMinus * 1));
                      });
                    }),
                StatButton(
                    color: _buttonColor,
                    text: '패스스킬',
                    onClick: () {
                      setState(() {
                        player.stat.add(Stat(passSkill: plusMinus * 1));
                      });
                    }),
                StatButton(
                    color: _buttonColor,
                    text: '수비스킬',
                    onClick: () {
                      setState(() {
                        player.stat.add(Stat(defSkill: plusMinus * 1));
                      });
                    }),
                StatButton(
                    color: _buttonColor,
                    text: '키핑스킬',
                    onClick: () {
                      setState(() {
                        player.stat.add(Stat(gkSkill: plusMinus * 1));
                      });
                    }),
                StatButton(
                    color: _buttonColor,
                    text: '침착함',
                    onClick: () {
                      setState(() {
                        player.stat.add(Stat(composure: plusMinus * 1));
                      });
                    }),
              ],
            ),
            const SizedBox(height: 48),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('슈팅'),
                Text('중거리'),
                Text('키패스'),
                Text('짧은패스'),
                Text('롱패스'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${player.shootingStat}'),
                Text('${player.midRangeShootStat}'),
                Text('${player.keyPassStat}'),
                Text('${player.shortPassStat}'),
                Text('${player.longPassStat}'),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('헤딩'),
                Text('드리블'),
                Text('탈압박'),
                Text('태클'),
                Text('인터셉트'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${player.headerStat}'),
                Text('${player.dribbleStat}'),
                Text('${player.evadePressStat}'),
                Text('${player.tackleStat}'),
                Text('${player.interceptStat}'),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('압박'),
                Text('침투'),
                Text('판단력'),
                Text('시야'),
                Text('선방'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${player.pressureStat}'),
                Text('${player.penetrationStat}'),
                Text('${player.judgementStat}'),
                Text('${player.visionStat}'),
                Text('${player.keepingStat}'),
              ],
            ),
            const SizedBox(height: 48),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('골'),
                Text('어시스트'),
                Text('패스성공'),
                Text('패스 성공률'),
                Text('수비성공'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${player.seasonGoal}'),
                Text('${player.seasonAssist}'),
                Text('${player.seasonPassSuccess}'),
                Text('${player.seasonPassSuccessPercent}%'),
                Text('${player.seasonDefSuccess}'),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  plusMinus = -1 * plusMinus;
                  _buttonColor = plusMinus == 1 ? Colors.green[100]! : Colors.red[100]!;
                  setState(() {});
                },
                child: const Text('추가 제거 변경'))
          ],
        ),
      ),
    );
  }
}

class StatButton extends StatefulWidget {
  const StatButton({super.key, required this.text, required this.onClick, required this.color});
  final String text;
  final Function onClick;
  final Color color;
  @override
  State<StatButton> createState() => _StatButtonState();
}

class _StatButtonState extends State<StatButton> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  _onTapEvent() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (_stopwatch.elapsed.inMilliseconds == 0) return;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      widget.onClick();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _stopwatch.start();
        _onTapEvent();
      },
      onTapUp: (TapUpDetails details) {
        _stopwatch.stop();
        if (_stopwatch.elapsed.inMilliseconds < 100) {
          widget.onClick();
        }
        _timer?.cancel();
        _timer = null;
        _stopwatch.reset();
      },
      child: Container(
        height: 35,
        width: 50,
        color: widget.color,
        child: Center(child: Text(widget.text)),
      ),
    );
  }
}

class PositionBadge extends StatelessWidget {
  const PositionBadge({super.key, required this.position, required this.role});
  final Position position;
  final PlayerRole role;

  Color _getColor(PlayerRole role) {
    return switch (role) {
      PlayerRole.forward => Colors.red,
      PlayerRole.midfielder => Colors.blue,
      PlayerRole.defender => Colors.orange,
      PlayerRole.goalKeeper => Colors.yellow,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      decoration: BoxDecoration(
        color: _getColor(role),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text(position.toString(), style: const TextStyle(fontSize: 16, color: Colors.white))),
    );
  }
}
