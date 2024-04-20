import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/entities/player/player.dart';
import 'package:soccer_simulator/entities/stat.dart';
import 'package:soccer_simulator/enum/national.dart';
import 'package:soccer_simulator/enum/player.dart';
import 'package:soccer_simulator/main.dart';

class PlayerDetail extends ConsumerWidget {
  const PlayerDetail({super.key});

  @override
  Widget build(BuildContext context, ref) {
    Player _player = ref.read(playerProvider) ??
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('키'),
                Text('축구지능'),
                Text('반응속도'),
                Text('스피드'),
                Text('유연성'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_player.height.round()}'),
                Text('${_player.soccerIQ}'),
                Text('${_player.reflex}'),
                Text('${_player.speed}'),
                Text('${_player.flexibility}'),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('체력'),
                Text('근력'),
                Text('공격스킬'),
                Text('패스스킬'),
                Text('수비스킬'),
                Text('침착함'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_player.stat.stamina}'),
                Text('${_player.stat.strength}'),
                Text('${_player.stat.attSkill}'),
                Text('${_player.stat.passSkill}'),
                Text('${_player.stat.defSkill}'),
                Text('${_player.stat.composure}'),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('슈팅'),
                Text('중거리'),
                Text('탈압박'),
                Text('압박'),
                Text('시야'),
                Text('골'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_player.shootingStat}'),
                Text('${_player.midRangeShootStat}'),
                Text('${_player.evadePressStat}'),
                Text('${_player.pressureStat}'),
                Text('${_player.visionStat}'),
                Text('${_player.seasonGoal}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
